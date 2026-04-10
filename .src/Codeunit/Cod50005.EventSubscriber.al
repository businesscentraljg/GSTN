namespace GSTN.GSTN;
using Microsoft.Sales.Posting;
using Microsoft.Sales.Document;

codeunit 50005 "Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure "Sales-Post_OnBeforePostSalesDoc"(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.TestField("Vehicle No.");
        SalesHeader.TestField("Vehicle Type");
        SalesHeader.TestField("Transporter ID");
        SalesHeader.TestField("Bill-to Address 2");
    end;

}
