page 50001 "GSTN Search Staging"
{
    ApplicationArea = All;
    Caption = 'GSTN Search Staging';
    PageType = List;
    SourceTable = "GSTN Search Staging";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field(GSTIN; Rec.GSTIN)
                {
                    ToolTip = 'Specifies the value of the GSTIN field.', Comment = '%';
                }
                field("Legal Name"; Rec."Legal Name")
                {
                    ToolTip = 'Specifies the value of the Legal Name field.', Comment = '%';
                }
                field("Trade Name"; Rec."Trade Name")
                {
                    ToolTip = 'Specifies the value of the Trade Name field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Taxpayer Type"; Rec."Taxpayer Type")
                {
                    ToolTip = 'Specifies the value of the Taxpayer Type field.', Comment = '%';
                }
                field(Constitution; Rec.Constitution)
                {
                    ToolTip = 'Specifies the value of the Constitution field.', Comment = '%';
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ToolTip = 'Specifies the value of the Registration Date field.', Comment = '%';
                }
                field("Last Updated Date"; Rec."Last Updated Date")
                {
                    ToolTip = 'Specifies the value of the Last Updated Date field.', Comment = '%';
                }
                field("Cancellation Date"; Rec."Cancellation Date")
                {
                    ToolTip = 'Specifies the value of the Cancellation Date field.', Comment = '%';
                }
                field("E-Invoice Status"; Rec."E-Invoice Status")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Status field.', Comment = '%';
                }
                field("State Jurisdiction"; Rec."State Jurisdiction")
                {
                    ToolTip = 'Specifies the value of the State Jurisdiction field.', Comment = '%';
                }
                field("Centre Jurisdiction"; Rec."Centre Jurisdiction")
                {
                    ToolTip = 'Specifies the value of the Centre Jurisdiction field.', Comment = '%';
                }
                field("State Jurisdiction Code"; Rec."State Jurisdiction Code")
                {
                    ToolTip = 'Specifies the value of the State Jurisdiction Code field.', Comment = '%';
                }
                field("Centre Jurisdiction Code"; Rec."Centre Jurisdiction Code")
                {
                    ToolTip = 'Specifies the value of the Centre Jurisdiction Code field.', Comment = '%';
                }
                field("Pr. Building Name"; Rec."Pr. Building Name")
                {
                    ToolTip = 'Specifies the value of the Pr. Building Name field.', Comment = '%';
                }
                field("Pr. Street"; Rec."Pr. Street")
                {
                    ToolTip = 'Specifies the value of the Pr. Street field.', Comment = '%';
                }
                field("Pr. Location"; Rec."Pr. Location")
                {
                    ToolTip = 'Specifies the value of the Pr. Location field.', Comment = '%';
                }
                field("Pr. Door No."; Rec."Pr. Door No.")
                {
                    ToolTip = 'Specifies the value of the Pr. Door No. field.', Comment = '%';
                }
                field("Pr. Floor No."; Rec."Pr. Floor No.")
                {
                    ToolTip = 'Specifies the value of the Pr. Floor No. field.', Comment = '%';
                }
                field("Pr. District"; Rec."Pr. District")
                {
                    ToolTip = 'Specifies the value of the Pr. District field.', Comment = '%';
                }
                field("Pr. State"; Rec."Pr. State")
                {
                    ToolTip = 'Specifies the value of the Pr. State field.', Comment = '%';
                }
                field("Pr. Pincode"; Rec."Pr. Pincode")
                {
                    ToolTip = 'Specifies the value of the Pr. Pincode field.', Comment = '%';
                }
                field("Pr. Latitude"; Rec."Pr. Latitude")
                {
                    ToolTip = 'Specifies the value of the Pr. Latitude field.', Comment = '%';
                }
                field("Pr. Longitude"; Rec."Pr. Longitude")
                {
                    ToolTip = 'Specifies the value of the Pr. Longitude field.', Comment = '%';
                }
                field("Pr. Nature of Business"; Rec."Pr. Nature of Business")
                {
                    ToolTip = 'Specifies the value of the Pr. Nature of Business field.', Comment = '%';
                }
                field("Nature of Business (JSON)"; Rec."Nature of Business (JSON)")
                {
                    ToolTip = 'Specifies the value of the Nature of Business (JSON) field.', Comment = '%';
                }
                field("Additional Address (JSON)"; Rec."Additional Address (JSON)")
                {
                    ToolTip = 'Specifies the value of the Additional Address (JSON) field.', Comment = '%';
                }
                field("Raw JSON Response"; Rec."Raw JSON Response")
                {
                    ToolTip = 'Specifies the value of the Raw JSON Response field.', Comment = '%';
                }
                field("Created At"; Rec."Created At")
                {
                    ToolTip = 'Specifies the value of the Created At field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
            }
        }
    }
}
