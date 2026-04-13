codeunit 50002 "EI Generate IRN Mgt"
{
    Permissions = tabledata "Sales Invoice Header" = rim;
    procedure GenerateIRN(PostedInvoiceNo: Code[20])
    var
        SalesInvHdr: Record "Sales Invoice Header";
        Setup: Record "GSP Authentication Setup";
        Staging: Record "E-Invoice IRN Staging";
        CompanyInfo: Record "Company Information";
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
        CompanyInfo.Get();
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
        Headers.Add('user_name', CompanyInfo."GST User Name");
        Headers.Add('password', CompanyInfo."GST Password");
        Headers.Add('gstin', CompanyInfo."GST Registration No.");
        Headers.Add('requestid', RequestId);

        // -------------------------------
        // SEND REQUEST
        // -------------------------------
        Client.Send(Request, Response);
        Response.Content.ReadAs(ResponseText);


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
        Staging."GSTIN Used" := CompanyInfo."GST Registration No.";
        SaveTextToBlob(RequestJson, Staging, 'Request JSON');
        SaveTextToBlob(ResponseText, Staging, 'Response JSON');
        Staging."HTTP Status Code" := Response.HttpStatusCode();
        Staging."Error Text" := Response.ReasonPhrase();
        // Parse Response
        ParseIRNResponse(ResponseText, Staging, SalesInvHdr);

        // Insert staging
        Staging.Modify();

        If Response.IsSuccessStatusCode() then begin
            Response.Content.ReadAs(ResponseText);
            if GuiAllowed then
                //if Setup."Show Message" then
                    Message(ResponseText);
        end else begin
            Response.Content.ReadAs(ResponseText);
            if GuiAllowed then
                Error(ResponseText);
        end;
    end;

    local procedure ParseIRNResponse(ResponseText: Text; var Staging: Record "E-Invoice IRN Staging"; var SalesInvHdr: Record "Sales Invoice Header")
    var
        Root: JsonObject;
        Result: JsonObject;
        Token: JsonToken;
        JA: JsonArray;
        JO: JsonObject;
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeImageProvider2D: Interface "Barcode Image Provider 2D";
        TempBlob: Codeunit "Temp Blob";
        OS: OutStream;
        IS: InStream;
        QRText: Text;
        AckDateTime: DateTime;
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

            if Result.Get('Irn', Token) then begin
                Staging."IRN" := Token.AsValue().AsText();
                SalesInvHdr."IRN Hash" := Staging."IRN";
            end;

            if Result.Get('AckNo', Token) then begin
                Staging."Ack No." := Token.AsValue().AsText();
                SalesInvHdr."Acknowledgement No." := Staging."Ack No.";
            end;

            if Result.Get('AckDt', Token) then begin
                if Evaluate(AckDateTime, Token.AsValue().AsText()) then begin
                    Staging."Ack Date" := AckDateTime;
                    SalesInvHdr."Acknowledgement Date" := AckDateTime;
                end;
            end;

            if Result.Get('SignedInvoice', Token) then
                SaveTextToBlob(Token.AsValue().AsText(), Staging, 'Signed Invoice');

            if Result.Get('SignedQRCode', Token) then begin
                SaveTextToBlob(Token.AsValue().AsText(), Staging, 'Signed QR Code');
                QRText := Token.AsValue().AsText();

                TempBlob.CreateOutStream(OS);

                BarcodeImageProvider2D := Enum::"Barcode Image Provider 2D"::Dynamics2D;
                BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                if QRText <> '' then
                    TempBlob := BarcodeImageProvider2D.EncodeImage(QRText, BarcodeSymbology2D);

                TempBlob.CreateOutStream(OS);
                TempBlob.CreateInStream(IS);
                SalesInvHdr."QR Code Img".ImportStream(IS, Format(SalesInvHdr."No."), '');
            end;

            if Result.Get('Status', Token) then
                Staging."IRN Status" := Token.AsValue().AsText();

            if Result.Get('EwbNo', Token) then
                if Token.IsValue() then begin
                    Staging."EWB No." := Format(Token.AsValue());
                    SalesInvHdr."E-Way Bill No." := Staging."EWB No.";
                end;

            if Result.Get('EwbDt', Token) then begin
                if Token.IsValue() then
                    Staging."EWB Date" := Format(Token.AsValue());
            end;

            if Result.Get('EwbValidTill', Token) then
                if Token.IsValue() then
                    Staging."EWB Valid Till" := Format(Token.AsValue());

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
                        if Token.IsValue() then
                            Staging."Desc" := Format(Token.AsValue());
                end;
            end;
        end;
        SalesInvHdr.Modify();
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
        DistVal: JsonValue;
        DistInt: Integer;
    begin
        CompanyInfo.Get();
        SalesInvHdr.CalcFields(Amount, "Amount Including VAT");
        CalculateGSTHeader(SalesInvHdr."No.");
        CalculateAssVal(SalesInvHdr);
        // Version
        Json.Add('Version', '1.1');

        // Transaction Details
        TranDtls.Add('TaxSch', 'GST');
        TranDtls.Add('SupTyp', GetSupplyType(SalesInvHdr));
        TranDtls.Add('RegRev', 'N');
        JVal.SetValueToNull();
        //TranDtls.Add('EcmGstin', JVal);
        TranDtls.Add('IgstOnIntra', 'N');
        Json.Add('TranDtls', TranDtls);

        Randomize();
        RandomNo := Random(900) + 100;

        NewDocNo := SalesInvHdr."No." + '-' + Format(RandomNo);
        // Document Details
        DocDtls.Add('Typ', 'INV');
        DocDtls.Add('No', SalesInvHdr."No.");
        DocDtls.Add(
            'Dt',
            Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')
        );
        Json.Add('DocDtls', DocDtls);

        // Seller Details Company Info
        SellerDtls.Add('Gstin', CompanyInfo."GST Registration No.");
        SellerDtls.Add('LglNm', CompanyInfo."Name");
        //SellerDtls.Add('TrdNm', CompanyInfo."Name");
        SellerDtls.Add('Addr1', CompanyInfo."Address");
        SellerDtls.Add('Addr2', CompanyInfo."Address 2");
        SellerDtls.Add('Loc', CompanyInfo."City");
        SellerDtls.Add('Pin', CompanyInfo."Post Code");
        States.Get(CompanyInfo."State Code");
        SellerDtls.Add('Stcd', States."State Code (GST Reg. No.)");
        // SellerDtls.Add('Ph', CleanPhoneNo(CompanyInfo."Phone No."));
        //SellerDtls.Add('Em', CompanyInfo."E-Mail");
        Json.Add('SellerDtls', SellerDtls);

        // Buyer Details  customer info bill 
        States.Get(SalesInvHdr."GST Bill-to State Code");
        BuyerDtls.Add('Gstin', SalesInvHdr."Customer GST Reg. No.");
        BuyerDtls.Add('LglNm', SalesInvHdr."Bill-to Name");
        // BuyerDtls.Add('TrdNm', SalesInvHdr."Bill-to Name");
        BuyerDtls.Add('Pos', States."State Code (GST Reg. No.)");
        BuyerDtls.Add('Addr1', SalesInvHdr."Bill-to Address");
        BuyerDtls.Add('Addr2', SalesInvHdr."Bill-to Address 2");
        BuyerDtls.Add('Loc', SalesInvHdr."Bill-to City");
        BuyerDtls.Add('Pin', SalesInvHdr."Bill-to Post Code");
        BuyerDtls.Add('Stcd', States."State Code (GST Reg. No.)");
        //BuyerDtls.Add('Ph', CleanPhoneNo(SalesInvHdr."Bill-to Contact No."));
        //BuyerDtls.Add('Em', SalesInvHdr."Sell-to E-Mail");
        Json.Add('BuyerDtls', BuyerDtls);

        // Item List
        ItemArray := BuildItemLines(SalesInvHdr);
        Json.Add('ItemList', ItemArray);

        // Value Details
        ValDtls.Add('AssVal', Abs(AssVal));
        ValDtls.Add('CgstVal', Abs(TotalCGST));
        ValDtls.Add('SgstVal', Abs(TotalSGST));
        ValDtls.Add('IgstVal', Abs(TotalIGST));
        ValDtls.Add('CesVal', Abs(TotalCess));
        ValDtls.Add('StCesVal', Abs(TotalCess));
        ValDtls.Add('Discount', Abs(ValDiscountAmt));  //Line - inv. discount value
        ValDtls.Add('OthChrg', 0);
        ValDtls.Add('RndOffAmt', 0);
        ValDtls.Add('TotInvVal', Abs(AssVal) + Abs(TotalCGST) + Abs(TotalSGST) + Abs(TotalIGST) + Abs(TotalCess));
        Json.Add('ValDtls', ValDtls);

        //
        // PayDtls.Add('Nm', CompanyInfo.Name);
        // PayDtls.Add('Accdet', CompanyInfo."Bank Account No.");
        // PayDtls.Add('Mode', 'Bank Transfer');
        // PayDtls.Add('Fininsbr', CompanyInfo."Bank Branch No.");
        // PayDtls.Add('Payterm', SalesInvHdr."Payment Terms Code");
        // PayDtls.Add('Payinstr', '');
        // PayDtls.Add('Crtrn', '');
        // PayDtls.Add('Dirdr', '');
        // PayDtls.Add('Crday', 0);
        // PayDtls.Add('Paidamt', 0);
        // PayDtls.Add('Paymtdue', 0);
        // Json.Add('PayDtls', PayDtls);

        RefDtls.Add('InvRm', SalesInvHdr."Reference Invoice No.");
        // DocPerdDtls
        DocPerdDtls.Add('InvStDt', Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        DocPerdDtls.Add('InvEndDt', Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        RefDtls.Add('DocPerdDtls', DocPerdDtls);

        // PrecDocDtls (Array)
        PrecDocObj.Add('InvNo', SalesInvHdr."No.");
        PrecDocObj.Add('InvDt', Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        PrecDocObj.Add('OthRefNo', CopyStr(SalesInvHdr."External Document No.", 1, 20));
        PrecDocArray.Add(PrecDocObj);
        RefDtls.Add('PrecDocDtls', PrecDocArray);

        // // ContrDtls (Array)
        // ContrObj.Add('RecAdvRefr', '');
        // ContrObj.Add('RecAdvDt', '');
        // ContrObj.Add('Tendrefr', '');
        // ContrObj.Add('Contrrefr', '');
        // ContrObj.Add('Extrefr', '');
        // ContrObj.Add('Projrefr', '');
        // ContrObj.Add('Porefr', '');
        // ContrObj.Add('PoRefDt', '');
        // ContrArray.Add(ContrObj);
        // RefDtls.Add('ContrDtls', ContrArray);

        // Json.Add('RefDtls', RefDtls);

        // AddlDocObj.Add('Url', '');
        // AddlDocObj.Add('Docs', '');
        // AddlDocObj.Add('Info', '');

        // AddlDocArray.Add(AddlDocObj);
        // Json.Add('AddlDocDtls', AddlDocArray);

        // ExpDtls.Add('ShipBNo', '');
        // ExpDtls.Add('ShipBDt', '');
        // ExpDtls.Add('Port', '');
        // ExpDtls.Add('RefClm', '');
        // ExpDtls.Add('ForCur', '');
        // ExpDtls.Add('CntCode', '');
        // // Add ExpDuty as JSON null by using an uninitialized JsonToken
        // ExpDtls.Add('ExpDuty', NullToken);


        //Json.Add('ExpDtls', ExpDtls);


        EwbDtls.Add('Transid', SalesInvHdr."Transporter ID");
        if SalesInvHdr."Transport Name" <> '' then
            EwbDtls.Add('Transname', SalesInvHdr."Transport Name");

        DistInt := Round(SalesInvHdr."Distance (Km)", 1, '<');
        DistVal.SetValue(DistInt);
        EwbDtls.Add('Distance', DistVal);

        if SalesInvHdr."Transport Document Number" <> '' then
            EwbDtls.Add('Transdocno', SalesInvHdr."Transport Document Number");
        if SalesInvHdr."Transport Document Date" <> 0D then
            EwbDtls.Add('TransdocDt', SalesInvHdr."Transport Document Date");

        EwbDtls.Add('Vehno', SalesInvHdr."Vehicle No.");
        EwbDtls.Add('Vehtype', GetVechicalType(SalesInvHdr));
        // if SalesInvHdr."Mode of Transport" <> '' then
        //     EwbDtls.Add('TransMode', SalesInvHdr."Mode of Transport")
        // else
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
        SerialNo: Integer;
    begin
        Clear(SerialNo);
        Line.Reset();
        Line.SetRange("Document No.", SalesInvHdr."No.");
        Line.SetRange(Type, Line.Type::Item);
        if Line.FindSet() then
            repeat
                SerialNo += 1;
                Clear(ItemObj);
                CalculateGSTAmounts(SalesInvHdr."No.", Line."Line No.");

                ItemObj.Add('SlNo', Format(SerialNo));
                ItemObj.Add('PrdDesc', Line.Description);
                ItemObj.Add('IsServc', 'N');
                ItemObj.Add('HsnCd', Line."HSN/SAC Code");
                //ItemObj.Add('Barcde', '123456');
                ItemObj.Add('Qty', Line.Quantity);
                //ItemObj.Add('FreeQty', 0);
                ItemObj.Add('Unit', Line."Unit of Measure Code");
                ItemObj.Add('UnitPrice', Line."Unit Price");
                ItemObj.Add('TotAmt', Line."Line Amount");
                //ItemObj.Add('Discount', Line."Line Discount Amount");

                // ItemObj.Add('PreTaxVal', 0);
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
                ItemObj.Add('TotItemVal', Abs(Line."Line Amount" - Line."Line Discount Amount") + Abs(CGSTAmt) + Abs(SGSTAmt) + Abs(IGSTAmt) + Abs(CessAmt));
                // ItemObj.Add('OrdLineRef', '3256');
                // ItemObj.Add('OrgCntry', 'IN');
                // ItemObj.Add('PrdSlNo', '12345');

                // -------- Batch Details (ONE object, ONE use) --------
                // Clear(BchDtlsObj);
                // BchDtlsObj.Add('Nm', 'BATCH001');
                // BchDtlsObj.Add(
                //     'Expdt',
                //     Format(Line."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>')
                // );
                // BchDtlsObj.Add(
                //     'wrDt',
                //     Format(WorkDate(), 0, '<Day,2>/<Month,2>/<Year4>')
                // );
                // ItemObj.Add('BchDtls', BchDtlsObj);

                // -------- Attribute Details (ARRAY) --------
                // Clear(AttribObj1);
                // AttribObj1.Add('Nm', Line.Description);
                // AttribObj1.Add('Val', Format(Line.Amount));
                // AttribArray.Add(AttribObj1);

                // ItemObj.Add('AttribDtls', AttribArray);


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
        ValDiscountAmt: Decimal;
        GSTComponentCode: Text;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TotalCess: Decimal;

    local procedure CalculateGSTAmounts(DocNo: Code[20]; DocLineNo: Integer)
    var
        GSTDetailLedger: Record "Detailed GST Ledger Entry";
    begin
        // Clear(AssVal);
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
                //AssVal += GSTDetailLedger."GST Base Amount";
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

    local procedure CalculateAssVal(SalesInvHdr: Record "Sales Invoice Header")
    var
        Line: Record "Sales Invoice Line";
    begin
        Clear(AssVal);
        Clear(ValDiscountAmt);

        Line.Reset();
        Line.SetRange("Document No.", SalesInvHdr."No.");
        if Line.FindSet() then
            repeat
                AssVal += Abs(Line."Line Amount" - Line."Line Discount Amount");
                ValDiscountAmt += Line."Inv. Discount Amount";
            until Line.Next() = 0;
    end;

    local procedure CalculateGSTHeader(DocNo: Code[20])
    var
        GSTDetailLedger: Record "Detailed GST Ledger Entry";
    begin
        Clear(TotalCGST);
        Clear(TotalSGST);
        Clear(TotalIGST);
        Clear(TotalCess);

        GSTDetailLedger.Reset();
        GSTDetailLedger.SetRange("Document No.", DocNo);

        if GSTDetailLedger.FindSet() then
            repeat
                case GSTDetailLedger."GST Component Code" of
                    'CGST':
                        TotalCGST += GSTDetailLedger."GST Amount";
                    'SGST':
                        TotalSGST += GSTDetailLedger."GST Amount";
                    'IGST':
                        TotalIGST += GSTDetailLedger."GST Amount";
                    'CESS':
                        TotalCess += GSTDetailLedger."GST Amount";
                end;
            until GSTDetailLedger.Next() = 0;
    end;

    local procedure GetSupplyType(SalesInvHdr: Record "Sales Invoice Header"): Text
    begin
        if SalesInvHdr."GST Customer Type" = SalesInvHdr."GST Customer Type"::Registered then
            exit('B2B')
        else
            exit('B2C');
    end;

    local procedure GetVechicalType(SalesInvHdr: Record "Sales Invoice Header"): Text
    var

    begin
        if SalesInvHdr."Vehicle Type" = SalesInvHdr."Vehicle Type"::Regular then
            exit('R');

        if SalesInvHdr."Vehicle Type" = SalesInvHdr."Vehicle Type"::ODC then
            exit('O');
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
