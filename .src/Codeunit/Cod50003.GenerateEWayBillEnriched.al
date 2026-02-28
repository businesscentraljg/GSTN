namespace GSTN.GSTN;
using Microsoft.Sales.History;
using Microsoft.Finance.TaxBase;
using Microsoft.Foundation.Company;
using Microsoft.Finance.GST.Base;

codeunit 50003 "Generate E-Way Bill Enriched"
{
    procedure GenerateEWayBillEnriched(PostedInvoiceNo: Code[20])
    var
        SalesInvHdr: Record "Sales Invoice Header";
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
        Staging."Document No." := SalesInvHdr."No.";
        Staging."Request DateTime" := CurrentDateTime();
        Staging."Request Id" := RequestId;
        Staging."GSTIN Used" := '05AAACG2115R1ZN';

        // Parse Response
        ParseIRNResponse(ResponseText, Staging);

        Staging.Modify();
    end;

    local procedure ParseIRNResponse(ResponseText: Text; var Staging: Record "EWay Bill Staging")
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
                Staging."Eway Bill No" := Token.AsValue().AsBigInteger();

            if Result.Get('ewayBillDate', Token) then
                Staging."Eway Bill Date" := Token.AsValue().AsText();

            if Result.Get('validUpto', Token) then
                Staging."Valid Upto" := Token.AsValue().AsText();

            if Result.Get('alert', Token) then
                Staging."Alert" := Token.AsValue().AsText();
        end;
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
    begin
        SalesInvHdr.CalcFields(Amount, "Amount Including VAT");
        CalculateGSTAmounts(SalesInvHdr."No.", 0);
        CompanyInfo.Get();
        Randomize();
        RandomNo := Random(900) + 100; // Generates 100–999

        NewDocNo := SalesInvHdr."No." + '-' + Format(RandomNo);
        // -------------------------
        // Header Values
        // -------------------------
        JsonObj.Add('supplyType', 'O');
        JsonObj.Add('subSupplyType', '1');
        JsonObj.Add('docType', 'INV');
        JsonObj.Add('docNo', NewDocNo);
        JsonObj.Add('docDate', Format(SalesInvHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
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
        JsonObj.Add('toTrdName', SalesInvHdr."Bill-to Name");
        JsonObj.Add('toAddr1', SalesInvHdr."Bill-to Address");
        JsonObj.Add('toAddr2', SalesInvHdr."Bill-to Address 2");
        JsonObj.Add('toPlace', SalesInvHdr."Bill-to City");
        JsonObj.Add('toPincode', SalesInvHdr."Bill-to Post Code");
        States.Get(SalesInvHdr."GST Bill-to State Code");
        JsonObj.Add('actToStateCode', States."State Code (GST Reg. No.)");
        JsonObj.Add('toStateCode', States."State Code (GST Reg. No.)");

        JsonObj.Add('totalValue', SalesInvHdr."Amount Including VAT");
        JsonObj.Add('cgstValue', Abs(CGSTAmt));
        JsonObj.Add('sgstValue', Abs(SGSTAmt));
        JsonObj.Add('igstValue', Abs(IGSTAmt));
        JsonObj.Add('totInvValue', Abs(AssVal) + Abs(CGSTAmt) + Abs(SGSTAmt) + Abs(IGSTAmt) + Abs(CessAmt));

        JsonObj.Add('transMode', SalesInvHdr."Transport Method");
        JsonObj.Add('transDistance', SalesInvHdr."Distance (Km)");
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
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
        if SalesInvLine.FindSet() then
            repeat
                Clear(ItemObj);
                CalculateGSTAmounts(SalesInvHdr."No.", SalesInvLine."Line No.");
                ItemObj.Add('productName', SalesInvLine."Description");
                ItemObj.Add('productDesc', SalesInvLine."Description");
                ItemObj.Add('hsnCode', SalesInvLine."HSN/SAC Code");
                ItemObj.Add('quantity', SalesInvLine.Quantity);
                ItemObj.Add('qtyUnit', SalesInvLine."Unit of Measure");
                ItemObj.Add('cgstRate', CGSTRate);
                ItemObj.Add('sgstRate', SGSTRate);
                ItemObj.Add('igstRate', IGSTRate);
                ItemObj.Add('taxableAmount', AssVal);
                ItemArray.Add(ItemObj);

            until SalesInvLine.Next() = 0;

        JsonObj.Add('itemList', ItemArray);

        // Convert JsonObject to Text
        JsonObj.WriteTo(JsonText);
        exit(JsonText);
    end;

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
}
