namespace GSTN.GSTN;

using Microsoft.Sales.History;

tableextension 50003 "Sales Shipment Header Ext" extends "Sales Shipment Header"
{
    fields
    {
        field(60000; "Transporter ID"; Code[20])
        {
            Caption = 'Transporter ID';
            DataClassification = ToBeClassified;
        }
        field(60001; "Transport Document Number"; Code[20])
        {
            Caption = 'Transport Document Number';
            DataClassification = ToBeClassified;
        }
        field(60002; "Transport Document Date"; Date)
        {
            Caption = 'Transport Document Date';
            DataClassification = ToBeClassified;
        }
        field(60003; "Transport Name"; Text[100])
        {
            Caption = 'Transport Name';
            DataClassification = ToBeClassified;
        }
    }
}
