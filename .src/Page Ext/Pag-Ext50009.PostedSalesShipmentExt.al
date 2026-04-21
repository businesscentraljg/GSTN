namespace GSTN.GSTN;

using Microsoft.Sales.History;

pageextension 50009 "Posted Sales Shipment Ext" extends "Posted Sales Shipment"
{
    layout
    {
        addlast("Tax Information")
        {
            field("E-Way Bill No."; Rec."E-Way Bill No.")
            {
                ApplicationArea = All;
            }
            field("Transporter ID"; Rec."Transporter ID")
            {
                ApplicationArea = All;
            }
            field("Transport Name"; Rec."Transport Name")
            {
                ApplicationArea = All;
            }
            field("Transport Document Number"; Rec."Transport Document Number")
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
            action("Generate E-Way Bill Enriched")
            {
                ApplicationArea = All;
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    EWayBillEnriched();
                end;
            }
            action("Cancellation of E-way")
            {
                ApplicationArea = All;
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    CancelEWayBill();
                end;
            }
        }
    }
    local procedure EWayBillEnriched()
    var
        EWayBillMgt: Codeunit "Generate E-Way Bill Enriched";
        Staging: Record "EWay Bill Staging";
        ConfirmReupload: Boolean;
    begin
        // 🔍 Check existing E-Way Bill in staging
        Staging.Reset();
        Staging.SetRange("Document No.", Rec."No.");
        Staging.SetRange(Success, true);
        if Staging.FindFirst() then begin
            Error('E-Way Bill already generated for this document');
        end else begin
            ConfirmReupload := true;
            if Staging.FindFirst() then
                ConfirmReupload := Dialog.Confirm('An E-Way Bill generation attempt already exists for this document. Do you want to generate again?');

            if ConfirmReupload then begin
                if not Confirm('Do you want to generate E-Way Bill for this document?') then
                    exit;
                EWayBillMgt.GenerateEWayBillEnrichedShipment(Rec."No.");
            end;
        end;
    end;

    local procedure CancelEWayBill()
    var
        EWayBillMgt: Codeunit "Generate E-Way Bill Enriched";
        Staging: Record "EWay Bill Staging";
    begin
        Rec.TestField("E-Way Bill No.");

        Staging.Reset();
        Staging.SetRange("Document No.", Rec."No.");
        Staging.SetRange("EWay Bill Cancel Success", true);
        if Staging.FindFirst() then begin
            Error('E-Way Bill already cancelled for this document');
        end else begin
            if not Confirm('Do you want to cancel E-Way Bill for this document?') then
                exit;
            EWayBillMgt.CancelShipmentEWayBill(Rec."No.");
        end;
    end;
}
