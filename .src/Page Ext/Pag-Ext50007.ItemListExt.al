namespace GSTN.GSTN;

using Microsoft.Inventory.Item;

pageextension 50007 "Item List Ext" extends "Item List"
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
