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
        addlast("Tax Info")
        {
            field("Transporter ID"; Rec."Transporter ID")
            {
                ApplicationArea = All;
            }
            field("Transport Name"; Rec."Transport Name")
            {
                ApplicationArea = All;
            }
            field("Tranport Document Number"; Rec."Tranport Document Number")
            {
                ApplicationArea = All;
            }
            field("Transport Document Date"; Rec."Transport Document Date")
            {
                ApplicationArea = All;
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
                    // IRNMgt.GenerateIRN(Rec."No.");
                    GenerateIRN();
                end;
            }
            action("Generate E-Way Bill Enriched")
            {
                ApplicationArea = All;
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
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
    local procedure GenerateIRN()
    var
        IRNMgt: Codeunit "EI Generate IRN Mgt";
        Staging: Record "E-Invoice IRN Staging";
        ConfirmReupload: Boolean;
    begin
        // 🔍 Check existing IRN in staging
        Staging.Reset();
        Staging.SetRange("Document No.", Rec."No.");
        Staging.SetRange(Success, true);
        if Staging.FindFirst() then begin
            Error('IRN already generated for this document. IRN: %1', Staging."IRN");
        end else begin
            ConfirmReupload := true;
            if Staging.FindFirst() then
                ConfirmReupload := Dialog.Confirm('An IRN generation attempt already exists for this document. Do you want to generate again?');

            if ConfirmReupload then begin
                if not Confirm('Do you want to generate IRN for this document?') then
                    exit;
                IRNMgt.GenerateIRN(Rec."No.");
            end;
        end;
    end;
}
