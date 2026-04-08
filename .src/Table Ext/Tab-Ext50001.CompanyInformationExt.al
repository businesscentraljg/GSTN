namespace GSTN.GSTN;

using Microsoft.Foundation.Company;

tableextension 50001 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(50000; "GST User Name"; Code[30])
        {
            Caption = 'GST User Name';
            DataClassification = ToBeClassified;
        }
        field(50001; "GST Password"; Text[100])
        {
            Caption = 'GST Password';
            DataClassification = ToBeClassified;
        }
    }
}
