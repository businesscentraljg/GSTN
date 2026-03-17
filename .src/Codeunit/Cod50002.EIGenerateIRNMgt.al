codeunit 50002 "EI Generate IRN Mgt"
{
    Permissions = tabledata "Sales Invoice Header" = rim;
    procedure GenerateIRN(PostedInvoiceNo: Code[20])
    var
        SalesInvHdr: Record "Sales Invoice Header";
        Setup: Record "GSP Authentication Setup";
        Staging: Record "E-Invoice IRN Staging";
        GSPMgmt: Codeunit "GSP Management";
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        RequestJson: Text;
        ResponseText: Text;
        Url: Text;
        RequestId: Text;
        JsonResp: JsonArray;
    begin
        Setup.Get();
        SalesInvHdr.Get(PostedInvoiceNo);

        // if SalesInvHdr."IRN Hash" <> '' then
        //     Error('IRN already generated for Invoice %1.', PostedInvoiceNo);

        Url := Setup."Base URL" + '/test/enriched/ei/api/invoice';

        /* Request.SetRequestUri(URL);
        Request.Method('GET');

        Request.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + AccessToken);
        Request.Content := Content;
        Content.ReadAs(ResponseText);
        Client.Send(Request, Response); */
        //JSONTest();
        RequestId := CreateGuid();
        RequestJson := BuildInvoiceJson(SalesInvHdr);
        //RequestJson := JsonText;

        if Setup."Show Message" then
            Message(RequestJson);

        Content.WriteFrom(RequestJson);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        Request.Method('POST');
        Request.SetRequestUri(Url);
        Request.Content := Content;

        Request.GetHeaders(Headers);

        // 🔥 ADAEQUARE REQUIRED HEADERS
        Headers.Add('Authorization', 'Bearer ' + GSPMgmt.GetValidAccessToken());
        Headers.Add('user_name', 'adqgsphpusr1');
        Headers.Add('password', 'Gsp@1234');
        Headers.Add('gstin', '02AMBPG7773M002');
        Headers.Add('requestid', RequestId);

        // -------------------------------
        // SEND REQUEST
        // -------------------------------
        Client.Send(Request, Response);
        Response.Content.ReadAs(ResponseText);

        if Setup."Show Message" then
            Message(ResponseText);

        // if not JsonResp.ReadFrom(ResponseText) then
        //     Error('Invalid response JSON');

        // -------------------------------
        // CREATE STAGING (INSERT ONCE)
        // -------------------------------
        Staging.Init();
        Staging.Insert();
        Staging."Document Type" := Staging."Document Type"::Invoice;
        Staging."Document No." := SalesInvHdr."No.";
        Staging."Posting Date" := SalesInvHdr."Posting Date";
        Staging."Request DateTime" := CurrentDateTime();
        Staging."Request Id" := RequestId;
        Staging."GSTIN Used" := '02AMBPG7773M002';
        SaveTextToBlob(RequestJson, Staging, 'Request JSON');
        SaveTextToBlob(ResponseText, Staging, 'Response JSON');
        Staging."HTTP Status Code" := Response.HttpStatusCode();
        Staging."Error Text" := Response.ReasonPhrase();
        // Parse Response
        ParseIRNResponse(ResponseText, Staging);

        // Insert staging
        Staging.Modify();

        if Staging.Success then begin
            SalesInvHdr."IRN Hash" := Staging."IRN";
            SalesInvHdr."Acknowledgement No." := Staging."Ack No.";
            // SalesInvHdr."Acknowledgement Date" := Staging."Ack Date";
            SalesInvHdr."E-Way Bill No." := Staging."EWB No.";
            SalesInvHdr."QR Code" := Staging."Signed QR Code";
            SalesInvHdr.Modify();
        end;
    end;

    local procedure ParseIRNResponse(ResponseText: Text; var Staging: Record "E-Invoice IRN Staging")
    var
        Root: JsonObject;
        Result: JsonObject;
        Token: JsonToken;
        JA: JsonArray;
        JO: JsonObject;
    begin
        Root.ReadFrom(ResponseText);

        // Success
        if Root.Get('success', Token) then
            Staging.Success := Token.AsValue().AsBoolean();

        // Message
        if Root.Get('message', Token) then
            Staging.Message := Token.AsValue().AsText();

        // Result object
        if Root.Get('result', Token) then begin
            Result := Token.AsObject();

            if Result.Get('Irn', Token) then
                Staging."IRN" := Token.AsValue().AsText();

            if Result.Get('AckNo', Token) then
                Staging."Ack No." := Token.AsValue().AsText();

            if Result.Get('AckDt', Token) then
                Staging."Ack Date" := Token.AsValue().AsText();

            if Result.Get('SignedInvoice', Token) then
                SaveTextToBlob(Token.AsValue().AsText(), Staging, 'Signed Invoice');

            if Result.Get('SignedQRCode', Token) then
                SaveTextToBlob(Token.AsValue().AsText(), Staging, 'Signed QR Code');

            if Result.Get('Status', Token) then
                Staging."IRN Status" := Token.AsValue().AsText();

            if Result.Get('EwbNo', Token) then
                Staging."EWB No." := Token.AsValue().AsText();

            if Result.Get('EwbDt', Token) then
                Staging."EWB Date" := Token.AsValue().AsText();

            if Result.Get('EwbValidTill', Token) then
                Staging."EWB Valid Till" := Token.AsValue().AsText();

            Clear(JO);
            if Root.Get('info', Token) then begin
                JA := Token.AsArray();

                // 2️⃣ Check if array has elements
                if JA.Count() > 0 then begin

                    // 3️⃣ Get first object from array
                    JA.Get(0, Token);

                    // 4️⃣ Convert token to object
                    JO := Token.AsObject();

                    // 5️⃣ Read property from object

                    if JO.Get('InfCd', Token) then
                        Staging."InfCd" := Token.AsValue().AsText();

                    if JO.Get('Desc', Token) then
                        Staging."Desc" := Token.AsValue().AsText();

                end;
            end;
        end;
    end;

    local procedure SaveTextToBlob(TextValue: Text; var Staging: Record "E-Invoice IRN Staging"; FieldName: Text)
    var
        OutStr: OutStream;
    begin
        case FieldName of
            'Request JSON':
                Staging."Request JSON".CreateOutStream(OutStr);

            'Response JSON':
                Staging."Response JSON".CreateOutStream(OutStr);

            'Signed Invoice':
                Staging."Signed Invoice".CreateOutStream(OutStr);

            'Signed QR Code':
                Staging."Signed QR Code".CreateOutStream(OutStr);
        end;

        OutStr.WriteText(TextValue);
        Staging.Modify();
    end;

    local procedure BuildInvoiceJson(SalesInvHdr: Record "Sales Invoice Header"): Text
    var
        CompanyInfo: Record "Company Information";
        States: Record State;
        Json: JsonObject;
        TranDtls: JsonObject;
        DocDtls: JsonObject;
        SellerDtls: JsonObject;
        BuyerDtls: JsonObject;
        ValDtls: JsonObject;
        PayDtls: JsonObject;
        RefDtls: JsonObject;
        DocPerdDtls: JsonObject;
        PrecDocArray: JsonArray;
        PrecDocObj: JsonObject;
        ContrArray: JsonArray;
        ContrObj: JsonObject;
        AddlDocArray: JsonArray;
        AddlDocObj: JsonObject;
        ExpDtls: JsonObject;
        ItemArray: JsonArray;
        EwbDtls: JsonObject;
        JsonText: Text;
        NullToken: JsonToken;
        RandomNo: Integer;
        NewDocNo: Text;
        JVal: JsonValue;
    begin
        CompanyInfo.Get();
        SalesInvHdr.CalcFields(Amount, "Amount Including VAT");
        CalculateGSTAmounts(SalesInvHdr."No.", 0);

        // Version
        Json.Add('Version', '1.1');

        // Transaction Details
        TranDtls.Add('TaxSch', 'GST');
        TranDtls.Add('SupTyp', 'B2B');
        TranDtls.Add('RegRev', 'Y');
        JVal.SetValueToNull();
        TranDtls.Add('EcmGstin', JVal);
        TranDtls.Add('IgstOnIntra', 'N');
        Json.Add('TranDtls', TranDtls);

        Randomize();
        RandomNo := Random(900) + 100;

        NewDocNo := SalesInvHdr."No." + '-' + Format(RandomNo);
        // Document Details
        DocDtls.Add('Typ', 'INV');
        DocDtls.Add('No', NewDocNo);
        DocDtls.Add(
            'Dt',
            Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')
        );
        Json.Add('DocDtls', DocDtls);

        // Seller Details Company Info
        SellerDtls.Add('Gstin', CompanyInfo."GST Registration No.");
        SellerDtls.Add('LglNm', CompanyInfo."Name");
        SellerDtls.Add('TrdNm', CompanyInfo."Name");
        SellerDtls.Add('Addr1', CompanyInfo."Address");
        SellerDtls.Add('Addr2', CompanyInfo."Address 2");
        SellerDtls.Add('Loc', CompanyInfo."City");
        SellerDtls.Add('Pin', CompanyInfo."Post Code");
        States.Get(CompanyInfo."State Code");
        SellerDtls.Add('Stcd', States."State Code (GST Reg. No.)");
        SellerDtls.Add('Ph', CleanPhoneNo(CompanyInfo."Phone No."));
        SellerDtls.Add('Em', CompanyInfo."E-Mail");
        Json.Add('SellerDtls', SellerDtls);

        // Buyer Details  customer info bill 
        BuyerDtls.Add('Gstin', SalesInvHdr."Customer GST Reg. No.");
        BuyerDtls.Add('LglNm', SalesInvHdr."Bill-to Name");
        BuyerDtls.Add('TrdNm', SalesInvHdr."Bill-to Name");
        BuyerDtls.Add('Pos', '12');
        BuyerDtls.Add('Addr1', SalesInvHdr."Bill-to Address");
        BuyerDtls.Add('Addr2', SalesInvHdr."Bill-to Address 2");
        BuyerDtls.Add('Loc', SalesInvHdr."Bill-to City");
        BuyerDtls.Add('Pin', SalesInvHdr."Bill-to Post Code");
        States.Get(SalesInvHdr."GST Bill-to State Code");
        BuyerDtls.Add('Stcd', States."State Code (GST Reg. No.)");
        BuyerDtls.Add('Ph', CleanPhoneNo(SalesInvHdr."Bill-to Contact No."));
        BuyerDtls.Add('Em', SalesInvHdr."Sell-to E-Mail");
        Json.Add('BuyerDtls', BuyerDtls);

        // Item List
        ItemArray := BuildItemLines(SalesInvHdr);
        Json.Add('ItemList', ItemArray);

        // Value Details
        ValDtls.Add('AssVal', Abs(AssVal));
        ValDtls.Add('CgstVal', Abs(CGSTAmt));
        ValDtls.Add('SgstVal', Abs(SGSTAmt));
        ValDtls.Add('IgstVal', Abs(IGSTAmt));
        ValDtls.Add('CesVal', Abs(CessAmt));
        ValDtls.Add('StCesVal', 0);
        ValDtls.Add('Discount', 0);
        ValDtls.Add('OthChrg', 0);
        ValDtls.Add('RndOffAmt', 0);
        ValDtls.Add('TotInvVal', Abs(AssVal) + Abs(CGSTAmt) + Abs(SGSTAmt) + Abs(IGSTAmt) + Abs(CessAmt));
        Json.Add('ValDtls', ValDtls);

        //
        PayDtls.Add('Nm', 'ABCDE');
        PayDtls.Add('Accdet', '5697389713210');
        PayDtls.Add('Mode', 'Cash');
        PayDtls.Add('Fininsbr', 'SBIN11000');
        PayDtls.Add('Payterm', SalesInvHdr."Payment Terms Code");
        PayDtls.Add('Payinstr', 'Gift');
        PayDtls.Add('Crtrn', 'test');
        PayDtls.Add('Dirdr', 'test');
        PayDtls.Add('Crday', 100);
        PayDtls.Add('Paidamt', 10000);
        PayDtls.Add('Paymtdue', 5000);
        Json.Add('PayDtls', PayDtls);

        RefDtls.Add('InvRm', 'TEST');
        // DocPerdDtls
        DocPerdDtls.Add('InvStDt', Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        DocPerdDtls.Add('InvEndDt', Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        RefDtls.Add('DocPerdDtls', DocPerdDtls);

        // PrecDocDtls (Array)
        PrecDocObj.Add('InvNo', SalesInvHdr."No.");
        PrecDocObj.Add('InvDt', Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        PrecDocObj.Add('OthRefNo', '123456');
        PrecDocArray.Add(PrecDocObj);
        RefDtls.Add('PrecDocDtls', PrecDocArray);

        // ContrDtls (Array)
        ContrObj.Add('RecAdvRefr', 'Doc/003');
        ContrObj.Add('RecAdvDt', '01/08/2020');
        ContrObj.Add('Tendrefr', 'Abc001');
        ContrObj.Add('Contrrefr', 'Co123');
        ContrObj.Add('Extrefr', 'Yo456');
        ContrObj.Add('Projrefr', 'Doc-456');
        ContrObj.Add('Porefr', 'Doc-789');
        ContrObj.Add('PoRefDt', '01/08/2020');
        ContrArray.Add(ContrObj);
        RefDtls.Add('ContrDtls', ContrArray);

        Json.Add('RefDtls', RefDtls);

        AddlDocObj.Add('Url', 'https://einv-apisandbox.nic.in');
        AddlDocObj.Add('Docs', 'Test Doc');
        AddlDocObj.Add('Info', 'Document Test');

        AddlDocArray.Add(AddlDocObj);
        Json.Add('AddlDocDtls', AddlDocArray);

        ExpDtls.Add('ShipBNo', 'A-248');
        ExpDtls.Add('ShipBDt', '01/08/2020');
        ExpDtls.Add('Port', 'INABG1');
        ExpDtls.Add('RefClm', 'N');
        ExpDtls.Add('ForCur', 'AED');
        ExpDtls.Add('CntCode', 'AE');
        // Add ExpDuty as JSON null by using an uninitialized JsonToken
        ExpDtls.Add('ExpDuty', NullToken);


        Json.Add('ExpDtls', ExpDtls);

        EwbDtls.Add('Transid', '37AMBPG7773M002');
        EwbDtls.Add('Transname', 'XYZ EXPORTS');
        EwbDtls.Add('Distance', 0);
        EwbDtls.Add('Transdocno', NullToken);
        EwbDtls.Add('TransdocDt', NullToken);
        EwbDtls.Add('Vehno', 'ka123456');
        EwbDtls.Add('Vehtype', 'R');
        EwbDtls.Add('TransMode', '1');

        Json.Add('EwbDtls', EwbDtls);

        // Convert JsonObject to Text
        Json.WriteTo(JsonText);
        exit(JsonText);
    end;


    local procedure BuildItemLines(SalesInvHdr: Record "Sales Invoice Header"): JsonArray
    var
        Line: Record "Sales Invoice Line";
        ItemObj: JsonObject;
        Arr: JsonArray;
        AttribArray: JsonArray;
        BchDtlsObj: JsonObject;
        AttribObj1: JsonObject;
    begin
        Line.Reset();
        Line.SetRange("Document No.", SalesInvHdr."No.");
        if Line.FindSet() then
            repeat
                Clear(ItemObj);
                CalculateGSTAmounts(SalesInvHdr."No.", Line."Line No.");

                ItemObj.Add('SlNo', Line."Document No.");
                ItemObj.Add('PrdDesc', Line.Description);
                ItemObj.Add('IsServc', 'N');
                ItemObj.Add('HsnCd', Line."HSN/SAC Code");
                ItemObj.Add('Barcde', '123456');
                ItemObj.Add('Qty', Line.Quantity);
                ItemObj.Add('FreeQty', Line.Quantity);
                ItemObj.Add('Unit', Line."Unit of Measure Code");
                ItemObj.Add('UnitPrice', Line."Unit Price");
                ItemObj.Add('TotAmt', Line."Line Amount");
                ItemObj.Add('Discount', Line."Line Discount Amount");

                ItemObj.Add('PreTaxVal', Line."Line Amount" - Line."Line Discount Amount");
                ItemObj.Add('AssAmt', Line."Line Amount" - Line."Line Discount Amount");
                ItemObj.Add('GstRt', CGSTRate + SGSTRate + IGSTRate);

                ItemObj.Add('IgstAmt', Abs(IGSTAmt));
                ItemObj.Add('CgstAmt', Abs(CGSTAmt));
                ItemObj.Add('SgstAmt', Abs(SGSTAmt));
                ItemObj.Add('CesRt', CessRate);
                ItemObj.Add('CesAmt', Abs(CessAmt));
                ItemObj.Add('CesNonAdvlAmt', 0);
                ItemObj.Add('StateCesRt', 0);
                ItemObj.Add('StateCesAmt', 0);
                ItemObj.Add('StateCesNonAdvlAmt', 0);
                ItemObj.Add('OthChrg', 0);
                ItemObj.Add('TotItemVal', Abs(AssVal) + Abs(CGSTAmt) + Abs(SGSTAmt) + Abs(IGSTAmt) + Abs(CessAmt));
                ItemObj.Add('OrdLineRef', '3256');
                ItemObj.Add('OrgCntry', 'IN');
                ItemObj.Add('PrdSlNo', '12345');

                // -------- Batch Details (ONE object, ONE use) --------
                Clear(BchDtlsObj);
                BchDtlsObj.Add('Nm', 'BATCH001');
                BchDtlsObj.Add(
                    'Expdt',
                    Format(Line."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>')
                );
                BchDtlsObj.Add(
                    'wrDt',
                    Format(WorkDate(), 0, '<Day,2>/<Month,2>/<Year4>')
                );
                ItemObj.Add('BchDtls', BchDtlsObj);

                // -------- Attribute Details (ARRAY) --------
                Clear(AttribObj1);
                AttribObj1.Add('Nm', Line.Description);
                AttribObj1.Add('Val', Format(Line.Amount));
                AttribArray.Add(AttribObj1);

                ItemObj.Add('AttribDtls', AttribArray);


                Arr.Add(ItemObj);
            until Line.Next() = 0;

        exit(Arr);
    end;

    /* local procedure SaveTextToBlob(TextValue: Text; var Staging: Record "E-Invoice IRN Staging"; FieldName: Text)
    var
        OutStr: OutStream;
    begin
        case FieldName of
            'Request JSON':
                Staging."Request JSON".CreateOutStream(OutStr);
            'Response JSON':
                Staging."Response JSON".CreateOutStream(OutStr);
        end;
        OutStr.WriteText(TextValue);
    end; */

    var
        JsonText: Text;
        AssVal: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CessRate: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CessAmt: Decimal;
        GSTComponentCode: Text;

    local procedure CalculateGSTAmounts(DocNo: Code[20]; DocLineNo: Integer)
    var
        GSTDetailLedger: Record "Detailed GST Ledger Entry";
    begin
        Clear(AssVal);
        Clear(CGSTRate);
        Clear(SGSTRate);
        Clear(IGSTRate);
        Clear(CessRate);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        Clear(IGSTAmt);
        Clear(CessAmt);

        GSTDetailLedger.Reset();
        GSTDetailLedger.SetRange("Document No.", DocNo);

        // 🔥 If line mode
        if DocLineNo <> 0 then
            GSTDetailLedger.SetRange("Document Line No.", DocLineNo);

        if GSTDetailLedger.FindSet() then
            repeat
                AssVal += GSTDetailLedger."GST Base Amount";
                GSTComponentCode := GSTDetailLedger."GST Component Code";
                case GSTDetailLedger."GST Component Code" of

                    'CGST':
                        begin
                            CGSTRate := GSTDetailLedger."GST %";
                            CGSTAmt += GSTDetailLedger."GST Amount";
                        end;

                    'SGST':
                        begin
                            SGSTRate := GSTDetailLedger."GST %";
                            SGSTAmt += GSTDetailLedger."GST Amount";
                        end;

                    'IGST':
                        begin
                            IGSTRate := GSTDetailLedger."GST %";
                            IGSTAmt += GSTDetailLedger."GST Amount";
                        end;

                    'CESS':
                        begin
                            CessRate := GSTDetailLedger."GST %";
                            CessAmt += GSTDetailLedger."GST Amount";
                        end;
                end;

            until GSTDetailLedger.Next() = 0;
    end;

    local procedure CleanPhoneNo(Phone: Text): Text
    var
        Clean: Text;
    begin
        Clean := DelChr(Phone, '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-+ ()');

        if (StrLen(Clean) < 6) or (StrLen(Clean) > 12) then
            exit('');

        exit(Clean);
    end;

    procedure JSONTest()

    begin
        JsonText :=
    '{' +
    '"Version":"1.1",' +
    '"TranDtls":{' +
        '"TaxSch":"GST",' +
        '"SupTyp":"B2B",' +
        '"RegRev":"Y",' +
        '"EcmGstin":null,' +
        '"IgstOnIntra":"N"' +
    '},' +
    '"DocDtls":{' +
        '"Typ":"INV",' +
        '"No":"INV103296-12",' +
        '"Dt":"18/10/2025"' +
    '},' +
    '"SellerDtls":{' +
        '"Gstin":"02AMBPG7773M002",' +
        '"LglNm":"NIC company pvt ltd",' +
        '"TrdNm":"NIC Industries",' +
        '"Addr1":"5th block, kuvempu layout",' +
        '"Addr2":"kuvempu layout",' +
        '"Loc":"GANDHINAGAR",' +
        '"Pin":175032,' +
        '"Stcd":"02",' +
        '"Ph":"9000000000",' +
        '"Em":"abc@gmail.com"' +
    '},' +
    '"BuyerDtls":{' +
        '"Gstin":"36AAGCT1587Q1ZJ",' +
        '"LglNm":"XYZ company pvt ltd",' +
        '"TrdNm":"XYZ Industries",' +
        '"Pos":"12",' +
        '"Addr1":"7th block, kuvempu layout",' +
        '"Addr2":"kuvempu layout",' +
        '"Loc":"GANDHINAGAR",' +
        '"Pin":500055,' +
        '"Stcd":"36",' +
        '"Ph":"91111111111",' +
        '"Em":"xyz@yahoo.com"' +
    '},' +
    '"ItemList":[{' +
        '"SlNo":"1",' +
        '"PrdDesc":"Rice",' +
        '"IsServc":"N",' +
        '"HsnCd":"30049099",' +
        '"Barcde":"123456",' +
        '"Qty":100.345,' +
        '"FreeQty":10,' +
        '"Unit":"BAG",' +
        '"UnitPrice":99.545,' +
        '"TotAmt":9988.84,' +
        '"Discount":10,' +
        '"PreTaxVal":1,' +
        '"AssAmt":9978.84,' +
        '"GstRt":12,' +
        '"IgstAmt":1197.46,' +
        '"CgstAmt":0,' +
        '"SgstAmt":0,' +
        '"CesRt":5,' +
        '"CesAmt":498.94,' +
        '"CesNonAdvlAmt":10,' +
        '"StateCesRt":12,' +
        '"StateCesAmt":1197.46,' +
        '"StateCesNonAdvlAmt":5,' +
        '"OthChrg":10,' +
        '"TotItemVal":12897.7,' +
        '"OrdLineRef":"3256",' +
        '"OrgCntry":"AG",' +
        '"PrdSlNo":"12345",' +
        '"BchDtls":{' +
            '"Nm":"123456",' +
            '"Expdt":"01/08/2020",' +
            '"wrDt":"01/09/2020"' +
        '},' +
        '"AttribDtls":[{' +
            '"Nm":"Rice",' +
            '"Val":"10000"' +
        '}]' +
    '}],' +
    '"ValDtls":{' +
        '"AssVal":9978.84,' +
        '"CgstVal":0,' +
        '"SgstVal":0,' +
        '"IgstVal":1197.46,' +
        '"CesVal":508.94,' +
        '"StCesVal":1202.46,' +
        '"Discount":10,' +
        '"OthChrg":20,' +
        '"RndOffAmt":0.3,' +
        '"TotInvVal":12908' +
    '},' +
    '"PayDtls":{' +
        '"Nm":"ABCDE",' +
        '"Accdet":"5697389713210",' +
        '"Mode":"Cash",' +
        '"Fininsbr":"SBIN11000",' +
        '"Payterm":"100",' +
        '"Payinstr":"Gift",' +
        '"Crtrn":"test",' +
        '"Dirdr":"test",' +
        '"Crday":100,' +
        '"Paidamt":10000,' +
        '"Paymtdue":5000' +
    '},' +
    '"RefDtls":{' +
        '"InvRm":"TEST",' +
        '"DocPerdDtls":{' +
            '"InvStDt":"01/08/2020",' +
            '"InvEndDt":"01/09/2020"' +
        '},' +
        '"PrecDocDtls":[{' +
            '"InvNo":"DOC/002",' +
            '"InvDt":"01/08/2020",' +
            '"OthRefNo":"123456"' +
        '}],' +
        '"ContrDtls":[{' +
            '"RecAdvRefr":"Doc/003",' +
            '"RecAdvDt":"01/08/2020",' +
            '"Tendrefr":"Abc001",' +
            '"Contrrefr":"Co123",' +
            '"Extrefr":"Yo456",' +
            '"Projrefr":"Doc-456",' +
            '"Porefr":"Doc-789",' +
            '"PoRefDt":"01/08/2020"' +
        '}]' +
    '},' +
    '"AddlDocDtls":[{' +
        '"Url":"https://einv-apisandbox.nic.in",' +
        '"Docs":"Test Doc",' +
        '"Info":"Document Test"' +
    '}],' +
    '"ExpDtls":{' +
        '"ShipBNo":"A-248",' +
        '"ShipBDt":"01/08/2020",' +
        '"Port":"INABG1",' +
        '"RefClm":"N",' +
        '"ForCur":"AED",' +
        '"CntCode":"AE",' +
        '"ExpDuty":null' +
    '},' +
    '"EwbDtls":{' +
        '"Transid":"37AMBPG7773M002",' +
        '"Transname":"XYZ EXPORTS",' +
        '"Distance":0,' +
        '"Transdocno":null,' +
        '"TransdocDt":null,' +
        '"Vehno":"ka123456",' +
        '"Vehtype":"R",' +
        '"TransMode":"1"' +
    '}' +
    '}';
    end;
}
