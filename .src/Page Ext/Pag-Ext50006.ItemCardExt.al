namespace GSTN.GSTN;

using Microsoft.Inventory.Item;

pageextension 50006 "Item Card Ext" extends "Item Card"
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
