namespace GSTN.GSTN;

using Microsoft.Inventory.Item;

tableextension 50007 Item extends Item
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
