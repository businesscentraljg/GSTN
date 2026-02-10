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
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Request JSON"; Rec."Request JSON")
                {
                    ToolTip = 'Specifies the value of the Request JSON field.', Comment = '%';
                }
                field("Request DateTime"; Rec."Request DateTime")
                {
                    ToolTip = 'Specifies the value of the Request DateTime field.', Comment = '%';
                }
                field("Response JSON"; Rec."Response JSON")
                {
                    ToolTip = 'Specifies the value of the Response JSON field.', Comment = '%';
                }
                field(Success; Rec.Success)
                {
                    ToolTip = 'Specifies the value of the Success field.', Comment = '%';
                }
                field(Message; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.', Comment = '%';
                }
                field(IRN; Rec.IRN)
                {
                    ToolTip = 'Specifies the value of the IRN field.', Comment = '%';
                }
                field("Ack No."; Rec."Ack No.")
                {
                    ToolTip = 'Specifies the value of the Ack No. field.', Comment = '%';
                }
                field("Ack Date"; Rec."Ack Date")
                {
                    ToolTip = 'Specifies the value of the Ack Date field.', Comment = '%';
                }
                field("EWB No."; Rec."EWB No.")
                {
                    ToolTip = 'Specifies the value of the EWB No. field.', Comment = '%';
                }
                field("EWB Valid Till"; Rec."EWB Valid Till")
                {
                    ToolTip = 'Specifies the value of the EWB Valid Till field.', Comment = '%';
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
                field("User Name Used"; Rec."User Name Used")
                {
                    ToolTip = 'Specifies the value of the User Name Used field.', Comment = '%';
                }
            }
        }
    }
}
