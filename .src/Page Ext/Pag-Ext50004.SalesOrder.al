namespace GSTN.GSTN;

using Microsoft.Sales.Document;

pageextension 50004 "Sales Order" extends "Sales Order"
{
    layout
    {
        addlast("Tax Info")
        {
            field("Transporter ID"; Rec."Transporter ID")
            {
                ApplicationArea = All;
            }
            field("Transport Name"; Rec."Transport Name")
            {
                ApplicationArea = All;
            }
            field("Tranport Document Number"; Rec."Tranport Document Number")
            {
                ApplicationArea = All;
            }
            field("Transport Document Date"; Rec."Transport Document Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
