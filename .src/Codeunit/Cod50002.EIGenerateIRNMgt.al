codeunit 50002 "EI Generate IRN Mgt"
{
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

        RequestId := CreateGuid();
        RequestJson := BuildInvoiceJson(SalesInvHdr);

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

        if not JsonResp.ReadFrom(ResponseText) then
            Error('Invalid response JSON');

        // -------------------------------
        // CREATE STAGING (INSERT ONCE)
        // -------------------------------
        Staging.Init();
        Staging."Document Type" := Staging."Document Type"::Invoice;
        Staging."Document No." := SalesInvHdr."No.";
        Staging."Posting Date" := SalesInvHdr."Posting Date";
        Staging."Request DateTime" := CurrentDateTime();
        Staging."Request Id" := RequestId;
        Staging."GSTIN Used" := '02AMBPG7773M002';
        SaveTextToBlob(RequestJson, Staging, 'Request JSON');
        SaveTextToBlob(ResponseText, Staging, 'Response JSON');
        Staging."HTTP Status Code" := Response.HttpStatusCode();
        Staging.Insert(true);

        ParseIRNResponse(ResponseText, Staging);


        if Staging.Success then begin
            SalesInvHdr."IRN Hash" := Staging."IRN";
            // SalesInvHdr."IRN Ack No." := Format(Staging."Ack No.");
            // SalesInvHdr."IRN Ack Date" := DT2Date(Staging."Ack Date");
            SalesInvHdr.Modify(true);
        end;
    end;

    local procedure ParseIRNResponse(ResponseText: Text; var Staging: Record "E-Invoice IRN Staging")
    var
        Root: JsonObject;
        Result: JsonObject;
        Token: JsonToken;
    begin
        Root.ReadFrom(ResponseText);

        // success
        if Root.Get('success', Token) then
            Staging.Success := Token.AsValue().AsBoolean();

        // message
        if Root.Get('message', Token) then
            Staging.Message := Token.AsValue().AsText();

        // result object
        if Root.Get('result', Token) then begin
            Result := Token.AsObject();

            if Result.Get('Irn', Token) then
                Staging."IRN" := Token.AsValue().AsText();

            if Result.Get('AckNo', Token) then
                Staging."Ack No." := Token.AsValue().AsBigInteger();

            if Result.Get('AckDt', Token) then
                Staging."Ack Date" := Token.AsValue().AsDateTime();

            if Result.Get('EwbNo', Token) then
                Staging."EWB No." := Token.AsValue().AsBigInteger();

            if Result.Get('EwbValidTill', Token) then
                Staging."EWB Valid Till" := Token.AsValue().AsDateTime();
        end;
    end;


    local procedure BuildInvoiceJson(SalesInvHdr: Record "Sales Invoice Header"): Text
    var
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
    begin
        // Version
        Json.Add('Version', '1.1');

        // Transaction Details
        TranDtls.Add('TaxSch', 'GST');
        TranDtls.Add('SupTyp', 'B2B');
        TranDtls.Add('RegRev', 'Y');
        TranDtls.Add('EcmGstin', 'null');
        TranDtls.Add('IgstOnIntra', 'N');
        Json.Add('TranDtls', TranDtls);

        // Document Details
        DocDtls.Add('Typ', 'INV');
        DocDtls.Add('No', SalesInvHdr."No.");
        DocDtls.Add(
            'Dt',
            Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')
        );
        Json.Add('DocDtls', DocDtls);

        // Seller Details
        SellerDtls.Add('Gstin', '02AMBPG7773M002'); //company info
        SellerDtls.Add('LglNm', SalesInvHdr."Sell-to Customer Name");
        SellerDtls.Add('TrdNm', CompanyName);
        SellerDtls.Add('Addr1', SalesInvHdr."Sell-to Address");
        SellerDtls.Add('Addr2', SalesInvHdr."Sell-to Address 2");
        SellerDtls.Add('Loc', SalesInvHdr."Sell-to City");
        SellerDtls.Add('Pin', 175032);
        SellerDtls.Add('Stcd', '02');
        SellerDtls.Add('Ph', '9000000000');
        SellerDtls.Add('Em', SalesInvHdr."Sell-to E-Mail");
        Json.Add('SellerDtls', SellerDtls);

        // Buyer Details  customer info
        BuyerDtls.Add('Gstin', '36AAGCT1587Q1ZJ');
        BuyerDtls.Add('LglNm', SalesInvHdr."Ship-to Name");
        BuyerDtls.Add('TrdNm', CompanyName);
        BuyerDtls.Add('Pos', '12');
        BuyerDtls.Add('Addr1', SalesInvHdr."Ship-to Address");
        BuyerDtls.Add('Addr2', SalesInvHdr."Ship-to Address 2");
        BuyerDtls.Add('Loc', SalesInvHdr."Ship-to City");
        BuyerDtls.Add('Pin', 500055);
        BuyerDtls.Add('Stcd', '36');
        BuyerDtls.Add('Ph', '91111111111');
        BuyerDtls.Add('Em', 'xyz@yahoo.com');
        Json.Add('BuyerDtls', BuyerDtls);

        // Item List
        ItemArray := BuildItemLines(SalesInvHdr);
        Json.Add('ItemList', ItemArray);

        // Value Details
        ValDtls.Add('AssVal', SalesInvHdr."Amount");
        ValDtls.Add('CgstVal', 0);
        ValDtls.Add('SgstVal', 0);
        ValDtls.Add('IgstVal', SalesInvHdr."Amount");
        ValDtls.Add('CesVal', 0);
        ValDtls.Add('StCesVal', 0);
        ValDtls.Add('Discount', 0);
        ValDtls.Add('OthChrg', 0);
        ValDtls.Add('RndOffAmt', 0.3);
        ValDtls.Add('TotInvVal', SalesInvHdr."Amount Including VAT");
        Json.Add('ValDtls', ValDtls);

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
        DocPerdDtls.Add('InvStDt', '01/08/2020');
        DocPerdDtls.Add('InvEndDt', '01/09/2020');
        RefDtls.Add('DocPerdDtls', DocPerdDtls);

        // PrecDocDtls (Array)
        PrecDocObj.Add('InvNo', 'DOC/002');
        PrecDocObj.Add('InvDt', '01/08/2020');
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
        ExpDtls.Add('ExpDuty', 'null');

        Json.Add('ExpDtls', ExpDtls);

        EwbDtls.Add('Transid', '37AMBPG7773M002');
        EwbDtls.Add('Transname', 'XYZ EXPORTS');
        EwbDtls.Add('Distance', 0);
        EwbDtls.Add('Transdocno', 'null');
        EwbDtls.Add('TransdocDt', 'null');
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
                ItemObj.Add('SlNo', Format(Line."Line No."));
                ItemObj.Add('PrdDesc', Line.Description);
                ItemObj.Add('IsServc', 'N');
                ItemObj.Add('HsnCd', '30049099');
                ItemObj.Add('Barcde', '123456');
                ItemObj.Add('Qty', Line.Quantity);
                ItemObj.Add('FreeQty', Line.Quantity);
                ItemObj.Add('Unit', Line."Unit of Measure Code");
                ItemObj.Add('UnitPrice', Line."Unit Price");
                ItemObj.Add('TotAmt', Line."Line Amount");
                ItemObj.Add('Discount', Line."Line Discount Amount");
                ItemObj.Add('PreTaxVal', Line."Amount");
                ItemObj.Add('AssAmt', Line.Amount);
                ItemObj.Add('GstRt', Line."VAT %");
                ItemObj.Add('IgstAmt', Line.Amount);
                ItemObj.Add('CgstAmt', Line."Amount" / 2);
                ItemObj.Add('SgstAmt', Line."Amount" / 2);
                ItemObj.Add('CesRt', 0);
                ItemObj.Add('CesAmt', 0);
                ItemObj.Add('CesNonAdvlAmt', 0);
                ItemObj.Add('StateCesRt', 0);
                ItemObj.Add('StateCesAmt', 0);
                ItemObj.Add('StateCesNonAdvlAmt', 0);
                ItemObj.Add('OthChrg', 0);
                ItemObj.Add('TotItemVal', Line."Amount Including VAT");
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

    local procedure SaveTextToBlob(TextValue: Text; var Staging: Record "E-Invoice IRN Staging"; FieldName: Text)
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
    end;


}
