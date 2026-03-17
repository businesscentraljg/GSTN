namespace GSTN.GSTN;

using Microsoft.Sales.History;

page 50004 "Sales Invoice IRN QR FactBox"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice IRN QR FactBox';
    PageType = CardPart;
    SourceTable = "Sales Invoice Header";

    layout
    {
        area(content)
        {
            field("QR Code Img"; Rec."QR Code Img")
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
        }
    }
}
