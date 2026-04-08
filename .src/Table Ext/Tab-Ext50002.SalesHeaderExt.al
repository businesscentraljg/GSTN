namespace GSTN.GSTN;

using Microsoft.Sales.Document;

tableextension 50002 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(60000; "Transporter ID"; Code[20])
        {
            Caption = 'Transporter ID';
            DataClassification = ToBeClassified;
        }
        field(60001; "Tranport Document Number"; Code[20])
        {
            Caption = 'Tranport Document Number';
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
