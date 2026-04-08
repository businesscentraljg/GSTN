namespace GSTN.GSTN;

using Microsoft.Foundation.Company;

pageextension 50003 "Company Information Ext" extends "Company Information"
{
    layout
    {
        addlast("Tax Information")
        {
            field("GST User Name"; Rec."GST User Name")
            {
                ApplicationArea = All;
            }
            field("GST Password"; Rec."GST Password")
            {
                ApplicationArea = All;
            }
        }
    }
}
