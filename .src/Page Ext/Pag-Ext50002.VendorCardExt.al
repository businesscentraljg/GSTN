namespace GSTN.GSTN;

using Microsoft.Purchases.Vendor;

pageextension 50002 "Vendor Card Ext" extends "Vendor Card"
{
    actions
    {
        addlast(Processing)
        {
            action(FetchGSTNDetails)
            {
                Caption = 'Fetch GSTN Details';
                Image = Refresh;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    CU: Codeunit "Vendor GSTN Search Management";
                begin
                    Rec.TestField("GST Registration No.");
                    if not Confirm('This will fetch and update GSTN details for the current vendor. Do you want to continue?', false) then
                        exit;

                    CU.VendorGSTNSearch(Rec."No.");
                    CurrPage.Update();
                    Message('GSTN details fetched and updated successfully.');
                end;
            }
        }
    }
}
