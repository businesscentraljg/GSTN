namespace GSTN.GSTN;

using Microsoft.Sales.Document;

tableextension 50004 "Sales Line Ext" extends "Sales Line"
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
