codeunit 50001 "GSTN Search Management"
{
    procedure SearchGSTNAndUpdateCustomer(CustomerNo: Code[20])
    var
        Cust: Record Customer;
        RootObj: JsonObject;
        ResultObj: JsonObject;
        JT: JsonToken;
        RawJson: Text;
    begin
        if not Cust.Get(CustomerNo) then
            Error('Customer not found');

        Cust.TestField("GST Registration No.");

        // HTTP only
        RootObj := FetchGSTNFromAPI(Cust."GST Registration No.");

        // Convert JSON → Text (AL way)
        RootObj.WriteTo(RawJson);

        // Extract result
        RootObj.Get('result', JT);
        ResultObj := JT.AsObject();

        // DB writes AFTER HTTP
        InsertGSTNStaging(Cust, ResultObj, RawJson);
    end;

    procedure FetchGSTNFromAPI(GSTIN: Code[20]): JsonObject
    var
        GSPSetup: Record "GSP Authentication Setup";
        GSPMgmt: Codeunit "GSP Management";
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        ResponseText: Text;
        JsonObj: JsonObject;
        JT: JsonToken;
        AccessToken: Text;
        URL: Text;
        Content: HttpContent;
    begin
        GSPSetup.Get();

        AccessToken := GSPMgmt.GetValidAccessToken();

        URL := GSPSetup."Base URL" + '/test/enriched/commonapi/search' + '?action=TP&gstin=' + GSTIN;

        Request.SetRequestUri(URL);
        Request.Method('GET');

        Request.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + AccessToken);
        Request.Content := Content;
        Content.ReadAs(ResponseText);
        Client.Send(Request, Response);

        if not Response.IsSuccessStatusCode() then
            Error('GSTN Search failed. Status Code: %1', Response.HttpStatusCode());

        Response.Content().ReadAs(ResponseText);

        if not JsonObj.ReadFrom(ResponseText) then
            Error('Invalid JSON received from GSTN');

        if not JsonObj.Get('success', JT) then
            Error('Invalid GSTN response');

        if not JT.AsValue().AsBoolean() then
            Error('GSTN search unsuccessful');

        exit(JsonObj);
    end;

    // =========================
    // CUSTOMER UPDATE
    // =========================
    local procedure UpdateCustomerFromGSTN(var Cust: Record Customer; GSTNSTaging: Record "GSTN Search Staging")
    var
        JT: JsonToken;
        PrAdrObj: JsonObject;
        AddrObj: JsonObject;
    begin
        // Cust.Validate("GST Legal Name", GetText(Result, 'lgnm'));
        // Cust.Validate("GST Trade Name", GetText(Result, 'tradeNam'));
        // Cust.Validate("GST Status", GetText(Result, 'sts'));
        // Cust.Validate("GST Taxpayer Type", GetText(Result, 'dty'));
        // Cust.Validate("GST Constitution", GetText(Result, 'ctb'));
        // Cust.Validate("GST Registration Date", GetDate(Result, 'rgdt'));
        // Cust.Validate("GST Last Updated Date", GetDate(Result, 'lstupdt'));
        // Cust.Validate("GST Cancellation Date", GetDate(Result, 'cxdt'));
        // Cust.Validate("GST E-Invoice Status", GetText(Result, 'einvoiceStatus'));
        // Cust.Validate("GST State Jurisdiction Code", GetText(Result, 'stjCd'));
        // Cust.Validate("GST Centre Jurisdiction Code", GetText(Result, 'ctjCd'));
        // Cust.Validate("GST State Jurisdiction", GetText(Result, 'stj'));
        // Cust.Validate("GST Centre Jurisdiction", GetText(Result, 'ctj'));
        /*  if Result.Get('pradr', JT) then begin
             PrAdrObj := JT.AsObject();

             if PrAdrObj.Get('addr', JT) then begin
                 AddrObj := JT.AsObject();

                 // Address line (combine door + street)
                 Cust.Address :=
                     GetText(AddrObj, 'bno') + ' ' + GetText(AddrObj, 'st');

                 Cust."Address 2" := GetText(AddrObj, 'bnm');
                 Cust.City := GetText(AddrObj, 'loc');
                 Cust.County := GetText(AddrObj, 'dst');
                 Cust."Post Code" := GetText(AddrObj, 'pncd');
                 //Cust."State Code" := GetText(AddrObj, 'stcd');
             end;
         end; */
        Cust.Address := GSTNSTaging."Pr. Door No." + ' ' + GSTNSTaging."Pr. Street";
        Cust."Address 2" := GSTNSTaging."Pr. Building Name";
        Cust.Validate(City, GSTNSTaging."Pr. Location");
        Cust.County := GSTNSTaging."Pr. District";
        Cust.Validate("Post Code", GSTNSTaging."Pr. Pincode");
        Cust.Modify(true);
    end;


    // =========================
    // STAGING INSERT (ONE TABLE)
    // =========================
    local procedure InsertGSTNStaging(Cust: Record Customer; Result: JsonObject; RawJson: Text)
    var
        Stg: Record "GSTN Search Staging";
        JT: JsonToken;
        PrAdrObj: JsonObject;
        AddrObj: JsonObject;
        OutS: OutStream;
    begin
        Stg.Init();
        Stg."Customer No." := Cust."No.";
        Stg.GSTIN := GetText(Result, 'gstin');

        // BASIC
        Stg."Legal Name" := GetText(Result, 'lgnm');
        Stg."Trade Name" := GetText(Result, 'tradeNam');
        Stg.Status := GetText(Result, 'sts');
        Stg."Taxpayer Type" := GetText(Result, 'dty');
        Stg.Constitution := GetText(Result, 'ctb');
        Stg."Registration Date" := GetDate(Result, 'rgdt');
        Stg."Last Updated Date" := GetDate(Result, 'lstupdt');
        Stg."Cancellation Date" := GetDate(Result, 'cxdt');
        Stg."E-Invoice Status" := GetText(Result, 'einvoiceStatus');

        // JURISDICTION
        Stg."State Jurisdiction" := GetText(Result, 'stj');
        Stg."Centre Jurisdiction" := GetText(Result, 'ctj');
        Stg."State Jurisdiction Code" := GetText(Result, 'stjCd');
        Stg."Centre Jurisdiction Code" := GetText(Result, 'ctjCd');

        // PRINCIPAL ADDRESS
        if Result.Get('pradr', JT) then begin
            PrAdrObj := JT.AsObject();
            if PrAdrObj.Get('addr', JT) then begin
                AddrObj := JT.AsObject();
                Stg."Pr. Building Name" := GetText(AddrObj, 'bnm');
                Stg."Pr. Street" := GetText(AddrObj, 'st');
                Stg."Pr. Location" := GetText(AddrObj, 'loc');
                Stg."Pr. Door No." := GetText(AddrObj, 'bno');
                Stg."Pr. Floor No." := GetText(AddrObj, 'flno');
                Stg."Pr. District" := GetText(AddrObj, 'dst');
                Stg."Pr. State" := GetText(AddrObj, 'stcd');
                Stg."Pr. Pincode" := GetText(AddrObj, 'pncd');
                Stg."Pr. Latitude" := GetText(AddrObj, 'lt');
                Stg."Pr. Longitude" := GetText(AddrObj, 'lg');
            end;

            Stg."Pr. Nature of Business" := GetText(PrAdrObj, 'ntr');
        end;

        // ARRAYS → BLOB
        WriteJsonArrayToBlob(Result, 'nba', Stg);
        WriteJsonArrayToBlob(Result, 'adadr', Stg);

        // RAW JSON
        Stg."Raw JSON Response".CreateOutStream(OutS);
        OutS.WriteText(RawJson);

        Stg."Created At" := CurrentDateTime();
        Stg."Created By" := UserId();
        Stg.Insert();

        UpdateCustomerFromGSTN(Cust, Stg);
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

    // =========================
    // JSON HELPERS
    // =========================
    local procedure GetText(JObj: JsonObject; Name: Text): Text
    var
        JT: JsonToken;
    begin
        if JObj.Get(Name, JT) then
            exit(JT.AsValue().AsText());
    end;


    local procedure GetDate(JObj: JsonObject; Name: Text): Date
    var
        Txt: Text;
        D: Date;
    begin
        Txt := GetText(JObj, Name);
        if Txt <> '' then
            Evaluate(D, Txt); // DD/MM/YYYY
        exit(D);
    end;

}
