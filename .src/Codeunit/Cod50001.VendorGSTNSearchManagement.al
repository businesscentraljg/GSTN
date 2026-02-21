codeunit 50001 "Vendor GSTN Search Management"
{
    procedure VendorGSTNSearch(VendorNo: Code[20])
    var
        Vend: Record Vendor;
        Setup: Record "GSP Authentication Setup";
        GSPMgmt: Codeunit "GSP Management";
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        ResponseText: Text;
        Url: Text;
        Staging: Record "GSTN Search Staging";
    begin
        Setup.Get();

        if not Vend.Get(VendorNo) then
            Error('Vendor not found');

        Vend.TestField("GST Registration No.");

        Url := Setup."Base URL" + '/test/enriched/commonapi/search?action=TP&gstin=' + Vend."GST Registration No.";

        Request.Method('GET');
        Request.SetRequestUri(Url);

        Request.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + GSPMgmt.GetValidAccessToken());
        Response.Content().ReadAs(ResponseText);

        Client.Send(Request, Response);
        Response.Content.ReadAs(ResponseText);

        if Setup."Show Message" then
            Message(ResponseText);

        if not Response.IsSuccessStatusCode() then
            Error('GSTN Search failed. Status Code: %1', Response.HttpStatusCode());

        // -------------------------
        // CREATE STAGING (INSERT ONCE)
        // -------------------------
        Staging.Init();
        Staging.Insert();
        Staging.Type := Staging.Type::Vendor;
        Staging."No." := Vend."No.";
        Staging.GSTIN := Vend."GST Registration No.";
        Staging."HTTP Status Code" := Response.HttpStatusCode();
        Staging."Error Text" := Response.ReasonPhrase();
        Staging."Created By" := UserId;
        Staging."Created At" := CurrentDateTime();
        // Parse Response
        ParseGSTNSearchResponse(ResponseText, Staging);

        Staging.Modify();

        // Update Customer from staging
        UpdateVendorFromGSTN(Vend, Staging);
    end;


    // ===================================
    // PARSE GSTN RESPONSE
    // ===================================
    local procedure ParseGSTNSearchResponse(ResponseText: Text; var Staging: Record "GSTN Search Staging")
    var
        Root: JsonObject;
        Result: JsonObject;
        PrAdrObj: JsonObject;
        AddrObj: JsonObject;
        Token: JsonToken;
        OutS: OutStream;
    begin
        Root.ReadFrom(ResponseText);

        // Success
        if Root.Get('success', Token) then
            Staging.Success := Token.AsValue().AsBoolean();

        // Message
        if Root.Get('message', Token) then
            Staging.Message := Token.AsValue().AsText();

        // Result
        if Root.Get('result', Token) then begin
            Result := Token.AsObject();

            if Result.Get('stjCd', Token) then
                Staging."State Jurisdiction Code" := Token.AsValue().AsText();

            if Result.Get('lgnm', Token) then
                Staging."Legal Name" := Token.AsValue().AsText();

            if Result.Get('stj', Token) then
                Staging."State Jurisdiction" := Token.AsValue().AsText();

            if Result.Get('dty', Token) then
                Staging."Taxpayer Type" := Token.AsValue().AsText();

            if Result.Get('cxdt', Token) then
                Evaluate(Staging."Cancellation Date", Token.AsValue().AsText());

            if Result.Get('gstin', Token) then
                Staging.GSTIN := Token.AsValue().AsText();

            if Result.Get('lstupdt', Token) then
                Evaluate(Staging."Last Updated Date", Token.AsValue().AsText());

            if Result.Get('rgdt', Token) then
                Evaluate(Staging."Registration Date", Token.AsValue().AsText());

            if Result.Get('ctb', Token) then
                Staging.Constitution := Token.AsValue().AsText();

            // Principal Address
            if Result.Get('pradr', Token) then begin
                PrAdrObj := Token.AsObject();

                if PrAdrObj.Get('addr', Token) then begin
                    AddrObj := Token.AsObject();

                    if AddrObj.Get('bnm', Token) then
                        Staging."Pr. Building Name" := Token.AsValue().AsText();

                    if AddrObj.Get('st', Token) then
                        Staging."Pr. Street" := Token.AsValue().AsText();

                    if AddrObj.Get('loc', Token) then
                        Staging."Pr. Location" := Token.AsValue().AsText();

                    if AddrObj.Get('bno', Token) then
                        Staging."Pr. Door No." := Token.AsValue().AsText();

                    if AddrObj.Get('dst', Token) then
                        Staging."Pr. District" := Token.AsValue().AsText();

                    if AddrObj.Get('locality', Token) then
                        Staging."Pr. Locality" := Token.AsValue().AsText();

                    if AddrObj.Get('lt', Token) then
                        Staging."Pr. Latitude" := Token.AsValue().AsText();

                    if AddrObj.Get('pncd', Token) then
                        Staging."Pr. Pincode" := Token.AsValue().AsText();

                    if AddrObj.Get('landmark', Token) then
                        Staging."Pr. LandMark" := Token.AsValue().AsText();

                    if AddrObj.Get('stcd', Token) then
                        Staging."Pr. State" := Token.AsValue().AsText();

                    if AddrObj.Get('geocodelvl', Token) then
                        Staging."Pr. Geo Code Level" := Token.AsValue().AsText();

                    if AddrObj.Get('flno', Token) then
                        Staging."Pr. Floor No." := Token.AsValue().AsText();

                    if AddrObj.Get('lg', Token) then
                        Staging."Pr. Longitude" := Token.AsValue().AsText();
                end;
            end;

            if Result.Get('ctjCd', Token) then
                Staging."Centre Jurisdiction Code" := Token.AsValue().AsText();

            if Result.Get('sts', Token) then
                Staging.Status := Token.AsValue().AsText();

            if Result.Get('tradeNam', Token) then
                Staging."Trade Name" := Token.AsValue().AsText();

            if Result.Get('ctj', Token) then
                Staging."Centre Jurisdiction" := Token.AsValue().AsText();

            if Result.Get('einvoiceStatus', Token) then
                Staging."E-Invoice Status" := Token.AsValue().AsText();
        end;

        WriteJsonArrayToBlob(Result, 'nba', Staging);
        WriteJsonArrayToBlob(Result, 'adadr', Staging);
        // Save Raw JSON
        Staging."Raw JSON Response".CreateOutStream(OutS);
        OutS.WriteText(ResponseText);
    end;

    local procedure WriteJsonArrayToBlob(JObj: JsonObject; FieldName: Text; var Stg: Record "GSTN Search Staging")
    var
        JT: JsonToken;
        Arr: JsonArray;
        Txt: Text;
        OutS: OutStream;
    begin
        if JObj.Get(FieldName, JT) then begin
            Arr := JT.AsArray();
            Arr.WriteTo(Txt);   // ✅ AL supported

            if FieldName = 'nba' then begin
                Stg."Nature of Business (JSON)".CreateOutStream(OutS);
                OutS.WriteText(Txt);
            end;

            if FieldName = 'adadr' then begin
                Stg."Additional Address (JSON)".CreateOutStream(OutS);
                OutS.WriteText(Txt);
            end;
        end;
    end;

    // ===================================
    // UPDATE VENDOR
    // ===================================
    local procedure UpdateVendorFromGSTN(var Vend: Record Vendor; Staging: Record "GSTN Search Staging")
    begin
        Vend.Address := Staging."Pr. Door No." + ' ' + Staging."Pr. Street";
        Vend."Address 2" := Staging."Pr. Building Name";
        Vend.Validate(City, Staging."Pr. Location");
        Vend.County := Staging."Pr. District";
        Vend.Validate("Post Code", Staging."Pr. Pincode");

        Vend.Modify(true);
    end;
}
