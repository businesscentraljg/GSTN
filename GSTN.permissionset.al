namespace GSTN;

permissionset 50000 GSTN
{
    Assignable = true;
    Permissions = tabledata "E-Invoice IRN Staging"=RIMD,
        tabledata "GSP Authentication Setup"=RIMD,
        tabledata "GSTN Search Staging"=RIMD,
        table "E-Invoice IRN Staging"=X,
        table "GSP Authentication Setup"=X,
        table "GSTN Search Staging"=X,
        codeunit "EI Generate IRN Mgt"=X,
        codeunit "GSP Management"=X,
        codeunit "GSTN Search Management"=X,
        page "E-Invoice IRN Staging"=X,
        page "GSP Authentication Setup"=X,
        page "GSTN Search Staging"=X;
}