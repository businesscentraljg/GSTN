namespace GSTN.GSTN;

using Microsoft.Inventory.BOM;

pageextension 50008 "Assembly BOM Ext" extends "Assembly BOM"
{
    layout
    {
        addafter("No.")
        {
            field("Reference No."; Rec."Reference No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
