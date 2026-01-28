codeunit 50000 "GSP Management"
{
    procedure GetValidAccessToken(): Text
    var
        GSPSetup: Record "GSP Authentication Setup";
    begin
        GSPSetup.Get();

        if (GSPSetup."Access Token" = '') or (CurrentDateTime() >= GSPSetup."Token Expires At") then
            GenerateNewToken();

        exit(GSPSetup."Access Token");
    end;

    local procedure GenerateNewToken()
    var
        GSPSetup: Record "GSP Authentication Setup";
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
        GSPSetup.Get();
        GSPSetup.TestField("GSP App ID");
        GSPSetup.TestField("GSP App Secret");
        GSPSetup.TestField("Base URL");

        Request.SetRequestUri(GSPSetup."Base URL" + '/gsp/authenticate?grant_type=token');
        Request.Method := 'POST';

        // Headers
        Request.GetHeaders(Headers);
        Headers.Add('gspappid', GSPSetup."GSP App ID");
        Headers.Add('gspappsecret', GSPSetup."GSP App Secret");

        Client.Send(Request, Response);

        if not Response.IsSuccessStatusCode() then
            Error('GSP token generation failed. Status: %1', Response.HttpStatusCode());

        // ✅ Step 1: Read response as Text
        Response.Content().ReadAs(ResponseText);

        // ✅ Step 2: Convert Text → JsonObject
        if not JsonObj.ReadFrom(ResponseText) then
            Error('Invalid JSON response from GSP');

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
        GSPSetup."Access Token" := AccessToken;
        GSPSetup."Token Type" := TokenType;
        GSPSetup.Scope := Scope;
        GSPSetup."Token Expires At" := ExpiryDT;
        GSPSetup.JTI := JTI;

        GSPSetup.Modify();
    end;

}

