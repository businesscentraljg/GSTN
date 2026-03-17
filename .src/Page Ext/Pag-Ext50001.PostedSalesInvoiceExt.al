pageextension 50001 "Posted Sales Invoice Ext1" extends "Posted Sales Invoice"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(QRFactBox; "Sales Invoice IRN QR FactBox")
            {
                Caption = 'IRN QR Code';
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("EI - Generate IRN")
            {
                ApplicationArea = All;
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    IRNMgt: Codeunit "EI Generate IRN Mgt";
                begin
                    //Rec.TestField("Customer GST Reg. No.");
                    IRNMgt.GenerateIRN(Rec."No.");
                    Message('IRN process completed');
                end;
            }
            action("Generate E-Way Bill Enriched")
            {
                ApplicationArea = All;
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    EWayBillMgt: Codeunit "Generate E-Way Bill Enriched";
                begin
                    //Rec.TestField("Customer GST Reg. No.");
                    EWayBillMgt.GenerateEWayBillEnriched(Rec."No.");
                    Message('E-Way Bill process completed');
                end;
            }
        }
    }
}
