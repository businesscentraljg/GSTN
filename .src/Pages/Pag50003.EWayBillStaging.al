namespace GSTN.GSTN;

page 50003 "EWay Bill Staging"
{
    ApplicationArea = All;
    Caption = 'EWay Bill Staging';
    PageType = List;
    SourceTable = "EWay Bill Staging";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field(Success; Rec.Success)
                {
                    ToolTip = 'Specifies the value of the Success field.', Comment = '%';
                }
                field("EWay Bill Cancel Success"; Rec."EWay Bill Cancel Success")
                {
                    ToolTip = 'Specifies the value of the EWay Bill Cancel Success field.', Comment = '%';
                }
                field(Message; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.', Comment = '%';
                }
                field("Eway Bill No"; Rec."Eway Bill No")
                {
                    ToolTip = 'Specifies the value of the Eway Bill No field.', Comment = '%';
                }
                field("Eway Bill Date"; Rec."Eway Bill Date")
                {
                    ToolTip = 'Specifies the value of the Eway Bill Date field.', Comment = '%';
                }
                field("Valid Upto"; Rec."Valid Upto")
                {
                    ToolTip = 'Specifies the value of the Valid Upto field.', Comment = '%';
                }
                field(Alert; Rec.Alert)
                {
                    ToolTip = 'Specifies the value of the Alert field.', Comment = '%';
                }
                field("GSTIN Used"; Rec."GSTIN Used")
                {
                    ToolTip = 'Specifies the value of the GSTIN Used field.', Comment = '%';
                }
                field("Request Id"; Rec."Request Id")
                {
                    ToolTip = 'Specifies the value of the Request Id field.', Comment = '%';
                }
                field("Request DateTime"; Rec."Request DateTime")
                {
                    ToolTip = 'Specifies the value of the Request DateTime field.', Comment = '%';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
            }
        }
    }
}
