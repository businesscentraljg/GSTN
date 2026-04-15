page 50000 "GST Authentication Setup"
{
    ApplicationArea = All;
    Caption = 'GST Authentication Setup';
    PageType = Card;
    SourceTable = "GST Authentication Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Base URL"; Rec."Base URL")
                {
                    ToolTip = 'Specifies the value of the Base URL field.', Comment = '%';
                }
                field("GST App ID"; Rec."GST App ID")
                {
                    ToolTip = 'Specifies the value of the GST App ID field.', Comment = '%';
                }
                field("GST App Secret"; Rec."GST App Secret")
                {
                    ToolTip = 'Specifies the value of the GST App Secret field.', Comment = '%';
                }
                field("Access Token"; Rec."Access Token")
                {
                    ToolTip = 'Specifies the value of the Access Token field.', Comment = '%';
                }
                field("Token Type"; Rec."Token Type")
                {
                    ToolTip = 'Specifies the value of the Token Type field.', Comment = '%';
                }
                field(Scope; Rec.Scope)
                {
                    ToolTip = 'Specifies the value of the Scope field.', Comment = '%';
                }
                field("Token Expires At"; Rec."Token Expires At")
                {
                    ToolTip = 'Specifies the value of the Token Expires At field.', Comment = '%';
                }
                field(JTI; Rec.JTI)
                {
                    ToolTip = 'Specifies the value of the JTI field.', Comment = '%';
                }
                field("C Type"; Rec."C Type")
                {
                    ToolTip = 'Specifies the value of the Content Type field.', Comment = '%';
                }
                field("Show Message"; Rec."Show Message")
                {
                    ToolTip = 'Specifies the value of the Show Message field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Process)
            {
                Caption = 'Process';

                action(GenerateToken)
                {
                    Caption = 'Generate Token';
                    Image = Refresh;
                    ApplicationArea = All;
                    ToolTip = 'Executes the Generate Token action.';

                    trigger OnAction()
                    var
                        CU: Codeunit "GST Management";
                    begin
                        if not Confirm('Do you want to Genrate Token?') then exit;
                        CU.GetValidAccessToken();
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                group(Category_Category6)
                {
                    Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    actionref(GenerateToken_Category; GenerateToken)
                    {

                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
