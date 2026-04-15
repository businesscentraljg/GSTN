codeunit 50000 "GST Management"
{
    procedure GetValidAccessToken(): Text
    var
        GSTSetup: Record "GST Authentication Setup";
    begin
        GSTSetup.Get();

        if (GSTSetup."Access Token" = '') or (CurrentDateTime() >= GSTSetup."Token Expires At") then
            GenerateNewToken();

        exit(GSTSetup."Access Token");
    end;

    local procedure GenerateNewToken()
    var
        GSTSetup: Record "GST Authentication Setup";
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        ResponseText: Text;
        JsonObj: JsonObject;
        JsonToken: JsonToken;
        AccessToken: Text;
        TokenType: Text;
        Scope: Text;
        ExpiresIn: Integer;
        JTI: Text;
        ExpiryDT: DateTime;
        ExpiryDate: Date;
        ExpiryTime: Time;
        RemainingSeconds: Integer;
        DaysToAdd: Integer;
    begin
        GSTSetup.Get();
        GSTSetup.TestField("GST App ID");
        GSTSetup.TestField("GST App Secret");
        GSTSetup.TestField("Base URL");

        Request.SetRequestUri(GSTSetup."Base URL" + '/GST/authenticate?grant_type=token');
        Request.Method := 'POST';

        // Headers
        Request.GetHeaders(Headers);
        Headers.Add('GSTappid', GSTSetup."GST App ID");
        Headers.Add('GSTappsecret', GSTSetup."GST App Secret");

        Client.Send(Request, Response);

        if not Response.IsSuccessStatusCode() then
            Error('GST token generation failed. Status: %1', Response.HttpStatusCode());

        // ✅ Step 1: Read response as Text
        Response.Content().ReadAs(ResponseText);

        // ✅ Step 2: Convert Text → JsonObject
        if not JsonObj.ReadFrom(ResponseText) then
            Error('Invalid JSON response from GST');

        // ✅ Step 3: Read fields safely
        if JsonObj.Get('access_token', JsonToken) then
            AccessToken := JsonToken.AsValue().AsText();

        if JsonObj.Get('token_type', JsonToken) then
            TokenType := JsonToken.AsValue().AsText();

        if JsonObj.Get('scope', JsonToken) then
            Scope := JsonToken.AsValue().AsText();

        if JsonObj.Get('expires_in', JsonToken) then
            ExpiresIn := JsonToken.AsValue().AsInteger();

        if JsonObj.Get('jti', JsonToken) then
            JTI := JsonToken.AsValue().AsText();

        // Expiry calculation
        // expires_in is in seconds
        DaysToAdd := ExpiresIn DIV 86400;           // seconds per day
        RemainingSeconds := ExpiresIn MOD 86400;    // remaining seconds

        ExpiryDate := Today + DaysToAdd;
        ExpiryTime := Time + (RemainingSeconds * 1000);

        ExpiryDT := CreateDateTime(ExpiryDate, ExpiryTime);


        // Save to setup
        GSTSetup."Access Token" := AccessToken;
        GSTSetup."Token Type" := TokenType;
        GSTSetup.Scope := Scope;
        GSTSetup."Token Expires At" := ExpiryDT;
        GSTSetup.JTI := JTI;

        GSTSetup.Modify();
    end;

}

