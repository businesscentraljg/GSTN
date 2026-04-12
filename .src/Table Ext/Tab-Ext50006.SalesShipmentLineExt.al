namespace GSTN.GSTN;

using Microsoft.Sales.History;

tableextension 50006 "Sales Shipment Line Ext" extends "Sales Shipment Line"
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
