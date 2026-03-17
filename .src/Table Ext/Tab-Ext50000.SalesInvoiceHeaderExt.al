namespace GSTN.GSTN;

using Microsoft.Sales.History;

tableextension 50000 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "QR Code Img"; Media)
        {
            Caption = 'QR Code Img';
            DataClassification = CustomerContent;
        }
    }
}
