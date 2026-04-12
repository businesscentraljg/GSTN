namespace GSTN.GSTN;

using Microsoft.Sales.History;

tableextension 50005 "Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = ToBeClassified;
        }
    }
}
