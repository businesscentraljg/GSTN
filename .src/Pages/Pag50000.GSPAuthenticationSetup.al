page 50000 "GSP Authentication Setup"
{
    ApplicationArea = All;
    Caption = 'GSP Authentication Setup';
    PageType = Card;
    SourceTable = "GSP Authentication Setup";
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
                field("GSP App ID"; Rec."GSP App ID")
                {
                    ToolTip = 'Specifies the value of the GSP App ID field.', Comment = '%';
                }
                field("GSP App Secret"; Rec."GSP App Secret")
                {
                    ToolTip = 'Specifies the value of the GSP App Secret field.', Comment = '%';
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
                        CU: Codeunit "GSP Management";
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
