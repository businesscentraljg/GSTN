pageextension 50000 "Customer Card Ext1" extends "Customer Card"
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
                    CU: Codeunit "Customer GSTN";
                begin
                    Rec.TestField("GST Registration No.");
                    if not Confirm('This will fetch and update GSTN details for the current customer. Do you want to continue?', false) then
                        exit;

                    CU.GSTNSearch(Rec."No.");
                    CurrPage.Update();
                    Message('GSTN details fetched and updated successfully.');
                end;
            }

            action(PrintCustomerLedger)
            {
                Caption = 'Customer Ledger Report';
                Image = Print;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    CustLedgerEntry: Record Customer;
                begin
                    CustLedgerEntry.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Customer Ledger Report", true, false, CustLedgerEntry);
                end;
            }
        }
    }
}
