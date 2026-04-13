page 50002 "E-Invoice IRN Staging"
{
    ApplicationArea = All;
    Caption = 'E-Invoice IRN Staging';
    PageType = List;
    SourceTable = "E-Invoice IRN Staging";
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Request DateTime"; Rec."Request DateTime")
                {
                    ToolTip = 'Specifies the value of the Request DateTime field.', Comment = '%';
                }
                field(Success; Rec.Success)
                {
                    ToolTip = 'Specifies the value of the Success field.', Comment = '%';
                }
                field("IRN Cancel Success"; Rec."IRN Cancel Success")
                {
                    ToolTip = 'Specifies the value of the IRN Cancel Success field.', Comment = '%';
                }
                field(Message; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.', Comment = '%';
                }
                field("Ack No."; Rec."Ack No.")
                {
                    ToolTip = 'Specifies the value of the Ack No. field.', Comment = '%';
                }
                field("Ack Date"; Rec."Ack Date")
                {
                    ToolTip = 'Specifies the value of the Ack Date field.', Comment = '%';
                }
                field(IRN; Rec.IRN)
                {
                    ToolTip = 'Specifies the value of the IRN field.', Comment = '%';
                }
                field("Signed Invoice"; Rec."Signed Invoice")
                {
                    ToolTip = 'Specifies the value of the Signed Invoice field.', Comment = '%';
                }
                field("Signed QR Code"; Rec."Signed QR Code")
                {
                    ToolTip = 'Specifies the value of the Signed QR Code field.', Comment = '%';
                }
                field("IRN Status"; Rec."IRN Status")
                {
                    ToolTip = 'Specifies the value of the IRN Status field.', Comment = '%';
                }
                field("EWB No."; Rec."EWB No.")
                {
                    ToolTip = 'Specifies the value of the EWB No. field.', Comment = '%';
                }
                field("EWB Date"; Rec."EWB Date")
                {
                    ToolTip = 'Specifies the value of the EWB Date field.', Comment = '%';
                }
                field("EWB Valid Till"; Rec."EWB Valid Till")
                {
                    ToolTip = 'Specifies the value of the EWB Valid Till field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(InfCd; Rec.InfCd)
                {
                    ToolTip = 'Specifies the value of the InfCd field.', Comment = '%';
                }
                field(Desc; Rec.Desc)
                {
                    ToolTip = 'Specifies the value of the Desc field.', Comment = '%';
                }
                field("HTTP Status Code"; Rec."HTTP Status Code")
                {
                    ToolTip = 'Specifies the value of the HTTP Status Code field.', Comment = '%';
                }
                field("Error Text"; Rec."Error Text")
                {
                    ToolTip = 'Specifies the value of the Error Text field.', Comment = '%';
                }
                field("Request Id"; Rec."Request Id")
                {
                    ToolTip = 'Specifies the value of the Request Id field.', Comment = '%';
                }
                field("GSTIN Used"; Rec."GSTIN Used")
                {
                    ToolTip = 'Specifies the value of the GSTIN Used field.', Comment = '%';
                }
            }
        }
    }
}
