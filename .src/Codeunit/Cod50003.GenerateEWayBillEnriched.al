namespace GSTN.GSTN;
using Microsoft.Sales.History;
using Microsoft.Finance.TaxBase;
using Microsoft.Foundation.Company;
using Microsoft.Finance.GST.Base;

codeunit 50003 "Generate E-Way Bill Enriched"
{
    Permissions = tabledata "Sales Invoice Header" = rim;

    #region EWAY bill Sales Invoice Enriched
    procedure GenerateEWayBillEnriched(PostedInvoiceNo: Code[20])
    var
        SalesInvHdr: Record "Sales Invoice Header";
        Setup: Record "GSP Authentication Setup";
        Staging: Record "EWay Bill Staging";
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

        Url := Setup."Base URL" + '/test/enriched/ewb/ewayapi?action=GENEWAYBILL';

        // JSONString();
        RequestId := CreateGuid();
        RequestJson := BuildEWayJson(SalesInvHdr);

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
        Headers.Add('username', CompanyInfo."GST User Name");
        Headers.Add('password', CompanyInfo."GST Password");
        Headers.Add('gstin', CompanyInfo."GST Registration No.");
        Headers.Add('requestid', RequestId);
        if Setup."C Type" <> '' then
            Headers.Add('ctype', Setup."C Type");

        // -------------------------------
        // SEND REQUEST
        // -------------------------------
        Client.Send(Request, Response);
        Response.Content.ReadAs(ResponseText);

        If Response.IsSuccessStatusCode() then begin
            Response.Content.ReadAs(ResponseText);
            if GuiAllowed then
                if Setup."Show Message" then
                    Message(ResponseText);
        end else begin
            Response.Content.ReadAs(ResponseText);
            if GuiAllowed then
                Error(ResponseText);
        end;
        // -------------------------------
        // CREATE STAGING (INSERT ONCE)
        // -------------------------------
        Staging.Init();
        Staging.Insert();
        Staging."Document No." := SalesInvHdr."No.";
        Staging."Request DateTime" := CurrentDateTime();
        Staging."Request Id" := RequestId;
        Staging."GSTIN Used" := CompanyInfo."GST Registration No.";

        // Parse Response
        ParseIRNResponse(ResponseText, Staging, SalesInvHdr);

        Staging.Modify();


    end;

    local procedure ParseIRNResponse(ResponseText: Text; var Staging: Record "EWay Bill Staging"; var SalesInvHdr: Record "Sales Invoice Header")
    var
        Root: JsonObject;
        Result: JsonObject;
        Token: JsonToken;
        EWBDate: DateTime;
        EWBTime: Time;
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

            if Result.Get('ewayBillNo', Token) then
                if Token.IsValue() then begin
                    Staging."Eway Bill No" := Format(Token.AsValue());
                    SalesInvHdr."E-Way Bill No." := Staging."Eway Bill No";
                end;

            if Result.Get('ewayBillDate', Token) then
                Staging."Eway Bill Date" := Token.AsValue().AsText();

            if Result.Get('validUpto', Token) then
                Staging."Valid Upto" := Token.AsValue().AsText();

            if Result.Get('alert', Token) then
                Staging."Alert" := Token.AsValue().AsText();
        end;
        SalesInvHdr.Modify();
    end;

    procedure BuildEWayJson(SalesInvHdr: Record "Sales Invoice Header"): Text
    var
        CompanyInfo: Record "Company Information";
        States: Record State;
        JsonObj: JsonObject;
        ItemArray: JsonArray;
        ItemObj: JsonObject;
        SalesInvLine: Record "Sales Invoice Line";
        JsonText: Text;
        RandomNo: Integer;
        NewDocNo: Text;
        DistVal: JsonValue;
        DistInt: Integer;
    begin
        SalesInvHdr.CalcFields(Amount, "Amount Including VAT");
        CalculateGSTAmounts(SalesInvHdr."No.", 0);
        CalculateAssVal(SalesInvHdr);
        CalculateGSTHeader(SalesInvHdr."No.");
        CompanyInfo.Get();
        Randomize();
        RandomNo := Random(900) + 1; // Generates 1–900

        NewDocNo := SalesInvHdr."No." + '-' + Format(RandomNo);
        // -------------------------
        // Header Values
        // -------------------------
        JsonObj.Add('supplyType', 'O');
        JsonObj.Add('subSupplyType', '1');
        JsonObj.Add('docType', 'INV');
        JsonObj.Add('docNo', SalesInvHdr."No.");
        JsonObj.Add('docDate', Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        JsonObj.Add('fromGstin', CompanyInfo."GST Registration No.");
        JsonObj.Add('fromTrdName', CompanyInfo."Name");
        JsonObj.Add('fromAddr1', CompanyInfo."Address");
        JsonObj.Add('fromAddr2', CompanyInfo."Address 2");
        JsonObj.Add('fromPlace', CompanyInfo."City");
        JsonObj.Add('fromPincode', CompanyInfo."Post Code");
        JsonObj.Add('actFromStateCode', 29);
        States.Get(CompanyInfo."State Code");
        JsonObj.Add('fromStateCode', States."State Code (GST Reg. No.)");

        JsonObj.Add('toGstin', SalesInvHdr."Customer GST Reg. No.");
        JsonObj.Add('toTrdName', SalesInvHdr."Bill-to Name");
        JsonObj.Add('toAddr1', SalesInvHdr."Bill-to Address");
        JsonObj.Add('toAddr2', SalesInvHdr."Bill-to Address 2");
        JsonObj.Add('toPlace', SalesInvHdr."Bill-to City");
        JsonObj.Add('toPincode', SalesInvHdr."Bill-to Post Code");
        States.Get(SalesInvHdr."GST Bill-to State Code");
        JsonObj.Add('actToStateCode', States."State Code (GST Reg. No.)");
        JsonObj.Add('toStateCode', States."State Code (GST Reg. No.)");
        JsonObj.Add('transactionType', 1);

        JsonObj.Add('totalValue', SalesInvHdr."Amount Including VAT");
        JsonObj.Add('cgstValue', Abs(CGSTAmt));
        JsonObj.Add('sgstValue', Abs(SGSTAmt));
        JsonObj.Add('igstValue', Abs(IGSTAmt));
        JsonObj.Add('cessValue', Abs(CessAmt));
        JsonObj.Add('totInvValue', Abs(AssVal) + Abs(TotalCGST) + Abs(TotalSGST) + Abs(TotalIGST) + Abs(TotalCess));

        JsonObj.Add('transMode', '1');

        DistInt := Round(SalesInvHdr."Distance (Km)", 1, '<');
        DistVal.SetValue(DistInt);
        JsonObj.Add('transDistance', DistVal);
        if SalesInvHdr."Transport Name" <> '' then
            JsonObj.Add('transporterName', SalesInvHdr."Transport Name");
        JsonObj.Add('transporterid', SalesInvHdr."Transporter ID");
        if SalesInvHdr."Transport Document Number" <> '' then
            JsonObj.Add('transDocNo', SalesInvHdr."Transport Document Number");
        if SalesInvHdr."Transport Document Date" <> 0D then
            JsonObj.Add('transDocDate', SalesInvHdr."Transport Document Date");
        JsonObj.Add('vehicleNo', SalesInvHdr."Vehicle No.");
        JsonObj.Add('vehicleType', GetVechicalType(SalesInvHdr));


        // -------------------------
        // Item Loop
        // -------------------------
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        if SalesInvLine.FindSet() then
            repeat
                Clear(ItemObj);
                CalculateGSTAmounts(SalesInvHdr."No.", SalesInvLine."Line No.");
                ItemObj.Add('productName', SalesInvLine."Description");
                ItemObj.Add('productDesc', SalesInvLine."Description");
                ItemObj.Add('hsnCode', SalesInvLine."HSN/SAC Code");
                ItemObj.Add('quantity', SalesInvLine.Quantity);
                ItemObj.Add('qtyUnit', SalesInvLine."Unit of Measure Code");
                ItemObj.Add('taxableAmount', Abs(AssVal));
                ItemObj.Add('sgstRate', SGSTRate);
                ItemObj.Add('cgstRate', CGSTRate);
                ItemObj.Add('igstRate', IGSTRate);
                ItemObj.Add('cessRate', CessRate);
                ItemObj.Add('cessAdvol', Abs(CessAmt));
                ItemArray.Add(ItemObj);

            until SalesInvLine.Next() = 0;

        JsonObj.Add('itemList', ItemArray);

        // Convert JsonObject to Text
        JsonObj.WriteTo(JsonText);
        exit(JsonText);
    end;
    #endregion
    local procedure CalculateGSTAmounts(DocNo: Code[20]; DocLineNo: Integer)
    var
        GSTDetailLedger: Record "Detailed GST Ledger Entry";
    begin
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

    local procedure GetVechicalType(SalesInvHdr: Record "Sales Invoice Header"): Text
    var

    begin
        if SalesInvHdr."Vehicle Type" = SalesInvHdr."Vehicle Type"::Regular then
            exit('R');

        if SalesInvHdr."Vehicle Type" = SalesInvHdr."Vehicle Type"::ODC then
            exit('O');
    end;

    #region EWAY bill Sales Shipment Enriched
    procedure GenerateEWayBillEnrichedShipment(No: Code[20])
    var
        SalesShipmentHdr: Record "Sales Shipment Header";
        Setup: Record "GSP Authentication Setup";
        Staging: Record "EWay Bill Staging";
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
        SalesShipmentHdr.Get(No);

        Url := Setup."Base URL" + '/test/enriched/ewb/ewayapi?action=GENEWAYBILL';

        // JSONString();
        RequestId := CreateGuid();
        RequestJson := BuildEWayJsonShipment(SalesShipmentHdr);

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
        Headers.Add('username', '05AAACG2115R1ZN');
        Headers.Add('password', 'abc123@@');
        Headers.Add('gstin', '05AAACG2115R1ZN');
        Headers.Add('requestid', RequestId);

        // -------------------------------
        // SEND REQUEST
        // -------------------------------
        Client.Send(Request, Response);
        Response.Content.ReadAs(ResponseText);

        if Setup."Show Message" then
            Message(ResponseText);
        // -------------------------------
        // CREATE STAGING (INSERT ONCE)
        // -------------------------------
        Staging.Init();
        Staging.Insert();
        Staging."Document No." := SalesShipmentHdr."No.";
        Staging."Request DateTime" := CurrentDateTime();
        Staging."Request Id" := RequestId;
        Staging."GSTIN Used" := '05AAACG2115R1ZN';

        // Parse Response
        ParseIRNResponseShipment(ResponseText, Staging, SalesShipmentHdr);

        Staging.Modify();
    end;

    local procedure ParseIRNResponseShipment(ResponseText: Text; var Staging: Record "EWay Bill Staging"; var SalesShipmentHdr: Record "Sales Shipment Header")
    var
        Root: JsonObject;
        Result: JsonObject;
        Token: JsonToken;
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

            if Result.Get('ewayBillNo', Token) then
                if Token.IsValue() then begin
                    Staging."Eway Bill No" := Format(Token.AsValue());
                    SalesShipmentHdr."E-Way Bill No." := Staging."Eway Bill No";
                end;

            if Result.Get('ewayBillDate', Token) then
                Staging."Eway Bill Date" := Token.AsValue().AsText();

            if Result.Get('validUpto', Token) then
                Staging."Valid Upto" := Token.AsValue().AsText();

            if Result.Get('alert', Token) then
                Staging."Alert" := Token.AsValue().AsText();
        end;
    end;

    procedure BuildEWayJsonShipment(SalesShipmentHdr: Record "Sales Shipment Header"): Text
    var
        CompanyInfo: Record "Company Information";
        States: Record State;
        JsonObj: JsonObject;
        ItemArray: JsonArray;
        ItemObj: JsonObject;
        SalesShipmentLine: Record "Sales Shipment Line";
        JsonText: Text;
        RandomNo: Integer;
        NewDocNo: Text;
    begin
        //SalesShipmentHdr.CalcFields(Amount, "Amount Including VAT");
        CalculateGSTAmounts(SalesShipmentHdr."No.", 0);
        CompanyInfo.Get();
        Randomize();
        RandomNo := Random(900) + 100; // Generates 100–999

        NewDocNo := SalesShipmentHdr."No." + '-' + Format(RandomNo);
        // -------------------------
        // Header Values
        // -------------------------
        JsonObj.Add('supplyType', 'O');
        JsonObj.Add('subSupplyType', '1');
        JsonObj.Add('docType', 'INV');
        JsonObj.Add('docNo', NewDocNo);
        JsonObj.Add('docDate', Format(SalesShipmentHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        JsonObj.Add('fromGstin', '05AAACG2115R1ZN');
        JsonObj.Add('fromTrdName', CompanyInfo."Name");
        JsonObj.Add('fromAddr1', CompanyInfo."Address");
        JsonObj.Add('fromAddr2', CompanyInfo."Address 2");
        JsonObj.Add('fromPlace', CompanyInfo."City");
        JsonObj.Add('fromPincode', CompanyInfo."Post Code");
        JsonObj.Add('actFromStateCode', 29);
        States.Get(CompanyInfo."State Code");
        JsonObj.Add('fromStateCode', States."State Code (GST Reg. No.)");

        JsonObj.Add('toGstin', '05AAACG2140A1ZL');
        JsonObj.Add('toTrdName', SalesShipmentHdr."Bill-to Name");
        JsonObj.Add('toAddr1', SalesShipmentHdr."Bill-to Address");
        JsonObj.Add('toAddr2', SalesShipmentHdr."Bill-to Address 2");
        JsonObj.Add('toPlace', SalesShipmentHdr."Bill-to City");
        JsonObj.Add('toPincode', SalesShipmentHdr."Bill-to Post Code");
        States.Get(SalesShipmentHdr."GST Bill-to State Code");
        JsonObj.Add('actToStateCode', States."State Code (GST Reg. No.)");
        JsonObj.Add('toStateCode', States."State Code (GST Reg. No.)");

        JsonObj.Add('totalValue', Abs(AssVal) + Abs(CGSTAmt) + Abs(SGSTAmt) + Abs(IGSTAmt) + Abs(CessAmt));
        JsonObj.Add('cgstValue', Abs(CGSTAmt));
        JsonObj.Add('sgstValue', Abs(SGSTAmt));
        JsonObj.Add('igstValue', Abs(IGSTAmt));
        JsonObj.Add('totInvValue', Abs(AssVal) + Abs(CGSTAmt) + Abs(SGSTAmt) + Abs(IGSTAmt) + Abs(CessAmt));

        JsonObj.Add('transMode', SalesShipmentHdr."Transport Method");
        JsonObj.Add('transDistance', SalesShipmentHdr."Distance (Km)");
        JsonObj.Add('transporterId', '');
        JsonObj.Add('transporterName', '');
        JsonObj.Add('transDocNo', '');
        JsonObj.Add('transDocDate', '');
        JsonObj.Add('vehicleNo', 'PVC1234');
        JsonObj.Add('vehicleType', 'R');
        JsonObj.Add('TransactionType', 1);

        // -------------------------
        // Item Loop
        // -------------------------
        SalesShipmentLine.Reset();
        SalesShipmentLine.SetRange("Document No.", SalesShipmentHdr."No.");
        if SalesShipmentLine.FindSet() then
            repeat
                Clear(ItemObj);
                CalculateGSTAmounts(SalesShipmentHdr."No.", SalesShipmentLine."Line No.");
                ItemObj.Add('productName', SalesShipmentLine."Description");
                ItemObj.Add('productDesc', SalesShipmentLine."Description");
                ItemObj.Add('hsnCode', SalesShipmentLine."HSN/SAC Code");
                ItemObj.Add('quantity', SalesShipmentLine.Quantity);
                ItemObj.Add('qtyUnit', SalesShipmentLine."Unit of Measure");
                ItemObj.Add('cgstRate', CGSTRate);
                ItemObj.Add('sgstRate', SGSTRate);
                ItemObj.Add('igstRate', IGSTRate);
                ItemObj.Add('taxableAmount', AssVal);
                ItemArray.Add(ItemObj);

            until SalesShipmentLine.Next() = 0;

        JsonObj.Add('itemList', ItemArray);

        // Convert JsonObject to Text
        JsonObj.WriteTo(JsonText);
        exit(JsonText);
    end;
    #endregion

    #region Cancel EWay Bill
    procedure CancelEWayBill(PostedInvoiceNo: Code[20])
    var
        SalesInvHdr: Record "Sales Invoice Header";
        Setup: Record "GSP Authentication Setup";
        Staging: Record "EWay Bill Staging";
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

        Url := Setup."Base URL" + '/test/enriched/ewb/ewayapi?action=CANEWB';

        // JSONString();
        RequestId := CreateGuid();
        // 🔹 Prepare JSON Body
        RequestJson :=
          '{' +
            '"ewbNo": ' + Format(SalesInvHdr."E-Way Bill No.") + ',' +
            '"cancelRsnCode": 2,' +
            '"cancelRmrk": "Cancelled the order"' +
          '}';

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
        Headers.Add('username', CompanyInfo."GST User Name");
        Headers.Add('password', CompanyInfo."GST Password");
        Headers.Add('gstin', CompanyInfo."GST Registration No.");
        Headers.Add('requestid', RequestId);
        if Setup."C Type" <> '' then
            Headers.Add('ctype', Setup."C Type");

        // -------------------------------
        // SEND REQUEST
        // -------------------------------
        Client.Send(Request, Response);
        Response.Content.ReadAs(ResponseText);

        If Response.IsSuccessStatusCode() then begin
            Response.Content.ReadAs(ResponseText);
            if GuiAllowed then
                if Setup."Show Message" then
                    Message(ResponseText);
        end else begin
            Response.Content.ReadAs(ResponseText);
            if GuiAllowed then
                Error(ResponseText);
        end;
        // -------------------------------
        // CREATE STAGING (INSERT ONCE)
        // -------------------------------
        Staging.Init();
        Staging.Insert();
        Staging."Document No." := SalesInvHdr."No.";
        Staging."Request DateTime" := CurrentDateTime();
        Staging."Request Id" := RequestId;
        Staging."GSTIN Used" := CompanyInfo."GST Registration No.";

        CancelEwayBillInvoice(ResponseText, Staging, SalesInvHdr);
        Staging.Modify();


    end;


    local procedure CancelEwayBillInvoice(ResponseText: Text; var Staging: Record "EWay Bill Staging"; var SalesInvHdr: Record "Sales Invoice Header")
    var
        Root: JsonObject;
        Result: JsonObject;
        Token: JsonToken;
    begin
        Root.ReadFrom(ResponseText);

        // Success
        if Root.Get('success', Token) then begin
            Staging."EWay Bill Cancel Success" := Token.AsValue().AsBoolean();
            SalesInvHdr."Eway Bill Cancel" := Token.AsValue().AsBoolean();
        end;
        // Message
        if Root.Get('message', Token) then
            Staging.Message := Token.AsValue().AsText();

        SalesInvHdr.Modify();
    end;


    #endregion

    #region Cancel IRN
    procedure CancelIRN_Invoice(PostedInvoiceNo: Code[20])
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

        Url := Setup."Base URL" + '/test/enriched/ei/api/invoice/cancel';

        // JSONString();
        RequestId := CreateGuid();
        // 🔹 Prepare JSON Body
        RequestJson :=
          '{' +
            '"Irn":' + '"' + SalesInvHdr."IRN Hash" + '",' +
            '"Cnlrsn": "1",' +
            '"Cnlrem": "Wrong entry"' +
          '}';

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
        if Setup."C Type" <> '' then
            Headers.Add('ctype', Setup."C Type");

        // -------------------------------
        // SEND REQUEST
        // -------------------------------
        Client.Send(Request, Response);
        Response.Content.ReadAs(ResponseText);

        If Response.IsSuccessStatusCode() then begin
            Response.Content.ReadAs(ResponseText);
            if GuiAllowed then
                if Setup."Show Message" then
                    Message(ResponseText);
        end else begin
            Response.Content.ReadAs(ResponseText);
            if GuiAllowed then
                Error(ResponseText);
        end;
        // -------------------------------
        // CREATE STAGING (INSERT ONCE)
        // -------------------------------
        Staging.Init();
        Staging.Insert();
        Staging."Document No." := SalesInvHdr."No.";
        Staging."Request DateTime" := CurrentDateTime();
        Staging."Request Id" := RequestId;
        Staging."GSTIN Used" := CompanyInfo."GST Registration No.";

        CancelIRNInvoice(ResponseText, Staging, SalesInvHdr);
        Staging.Modify();
    end;


    local procedure CancelIRNInvoice(ResponseText: Text; var Staging: Record "E-Invoice IRN Staging"; var SalesInvHdr: Record "Sales Invoice Header")
    var
        Root: JsonObject;
        Result: JsonObject;
        Token: JsonToken;
    begin
        Root.ReadFrom(ResponseText);

        // Success
        if Root.Get('success', Token) then begin
            Staging."IRN Cancel Success" := Token.AsValue().AsBoolean();
            SalesInvHdr."IRN Cancel" := Token.AsValue().AsBoolean();
        end;
        // Message
        if Root.Get('message', Token) then
            Staging.Message := Token.AsValue().AsText();

        SalesInvHdr.Modify();
    end;

    #endregion
    var
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
        ValDiscountAmt: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TotalCess: Decimal;

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
}
