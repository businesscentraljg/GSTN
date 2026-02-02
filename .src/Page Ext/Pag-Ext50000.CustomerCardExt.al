pageextension 50000 "Customer Card Ext" extends "Customer Card"
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
                    GSTNMgr: Codeunit "GSTN Search Management";
                begin
                    Rec.TestField("GST Registration No.");
                    if not Confirm('This will fetch and update GSTN details for the current customer. Do you want to continue?', false) then
                        exit;
                    
                    GSTNMgr.SearchGSTNAndUpdateCustomer(Rec."No.");
                    CurrPage.Update();
                    Message('GSTN details fetched and updated successfully.');
                end;
            }
        }
    }
}
