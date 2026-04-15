namespace GSTN.GSTN;

using Microsoft.Inventory.BOM;

tableextension 50008 "BOM Component Ext" extends "BOM Component"
{
    fields
    {
        field(50000; "Reference No."; Code[50])
        {
            Caption = 'Reference No.';
            DataClassification = ToBeClassified;
        }
    }
}
