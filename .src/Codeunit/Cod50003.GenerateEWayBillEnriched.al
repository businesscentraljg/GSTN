namespace GSTN.GSTN;
using Microsoft.Sales.History;

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
        RequestJson := BuildEWayJson(PostedInvoiceNo);

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

    procedure BuildEWayJson(SalesInvNo: Code[20]): Text
    var
        JsonObj: JsonObject;
        ItemArray: JsonArray;
        ItemObj: JsonObject;
        SalesInvLine: Record "Sales Invoice Line";
        JsonText: Text;
    begin
        // -------------------------
        // Header Values
        // -------------------------
        JsonObj.Add('supplyType', 'O');
        JsonObj.Add('subSupplyType', '1');
        JsonObj.Add('docType', 'INV');
        JsonObj.Add('docNo', '12M3-872732389-5');
        JsonObj.Add('docDate', '15/10/2025');
        JsonObj.Add('fromGstin', '05AAACG2115R1ZN');
        JsonObj.Add('fromTrdName', 'WELTON');
        JsonObj.Add('fromAddr1', '2ND CROSS NO 59 19 A');
        JsonObj.Add('fromAddr2', 'GROUND FLOOR OSBORNE ROAD');
        JsonObj.Add('fromPlace', 'FRAZER TOWN');
        JsonObj.Add('fromPincode', 560042);
        JsonObj.Add('actFromStateCode', 29);
        JsonObj.Add('fromStateCode', 29);

        JsonObj.Add('toGstin', '05AAACG2140A1ZL');
        JsonObj.Add('toTrdName', 'STHUTHYA');
        JsonObj.Add('toAddr1', 'Shree Nilaya');
        JsonObj.Add('toAddr2', 'Dasarahosahalli');
        JsonObj.Add('toPlace', 'Beml Nagar');
        JsonObj.Add('toPincode', 500003);
        JsonObj.Add('actToStateCode', 36);
        JsonObj.Add('toStateCode', 36);

        JsonObj.Add('totalValue', 5609889.00);
        JsonObj.Add('cgstValue', 0.00);
        JsonObj.Add('sgstValue', 0.00);
        JsonObj.Add('igstValue', 168296.67);
        JsonObj.Add('totInvValue', 5778185.67);

        JsonObj.Add('transMode', '1');
        JsonObj.Add('transDistance', 570);
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
        SalesInvLine.SetRange("Document No.", SalesInvNo);
        if SalesInvLine.FindSet() then
            repeat
                Clear(ItemObj);

                ItemObj.Add('productName', 'Wheat');
                ItemObj.Add('productDesc', 'Wheat');
                ItemObj.Add('hsnCode', 100190);
                ItemObj.Add('quantity', 4);
                ItemObj.Add('qtyUnit', 'BOX');
                ItemObj.Add('cgstRate', 0);
                ItemObj.Add('sgstRate', 0);
                ItemObj.Add('igstRate', 3);
                ItemObj.Add('taxableAmount', 5609889.00);
                ItemArray.Add(ItemObj);

            until SalesInvLine.Next() = 0;

        JsonObj.Add('itemList', ItemArray);

        // Convert JsonObject to Text
        JsonObj.WriteTo(JsonText);
        exit(JsonText);
    end;
}
