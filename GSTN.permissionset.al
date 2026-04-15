namespace GSTN;

using GSTN.GSTN;

permissionset 50000 GSTN
{
    Assignable = true;
    Permissions = tabledata "E-Invoice IRN Staging" = RIMD,
        tabledata "GST Authentication Setup" = RIMD,
        tabledata "GSTN Search Staging" = RIMD,
        table "E-Invoice IRN Staging" = X,
        table "GST Authentication Setup" = X,
        table "GSTN Search Staging" = X,
        codeunit "EI Generate IRN Mgt" = X,
        codeunit "GST Management" = X,
        page "E-Invoice IRN Staging" = X,
        page "GST Authentication Setup" = X,
        page "GSTN Search Staging" = X,
        tabledata "EWay Bill Staging" = RIMD,
        table "EWay Bill Staging" = X,
        codeunit "Customer GSTN" = X,
        codeunit "Generate E-Way Bill Enriched" = X,
        codeunit "Vendor GSTN Search Management" = X,
        page "EWay Bill Staging" = X,
        report "GST-Sales Invoice" = X,
        report "Purchase Order" = X,
        report "Sales Invoice" = X,
        report "Sales Order" = X,
        report "Sales Quote" = X,
        page "Sales Invoice IRN QR FactBox" = X,
        codeunit "Event Subscriber" = X;
}