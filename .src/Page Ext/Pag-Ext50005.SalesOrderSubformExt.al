namespace GSTN.GSTN;

using Microsoft.Sales.Document;

pageextension 50005 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
