report 50010 "Customer Ledger Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src\Reports\CustomerLedgerReport.rdl';
    ApplicationArea = All;
    Caption = 'Customer Ledger Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = true;

            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number);

                column(CompanyName; CompanyInfoRec.Name)
                {
                }
                column(ReportTitle; ReportTitleText)
                {
                }
                column(CustomerName; Customer.Name)
                {
                }
                column(CustomerDetails; CustomerDetailsText)
                {
                }
                column(PostingDateText; PostingDateText)
                {
                }
                column(DocumentNo; DocumentNoText)
                {
                }
                column(ExternalDocNo; ExternalDocNoText)
                {
                }
                column(Description; DescriptionText)
                {
                }
                column(DebitAmountText; DebitAmountText)
                {
                }
                column(CreditAmountText; CreditAmountText)
                {
                }
                column(BalanceAmountText; BalanceAmountText)
                {
                }
                column(IsOpeningBalance; IsOpeningBalance)
                {
                }
                column(IsTotalRow; IsTotalRow)
                {
                }

                trigger OnPreDataItem()
                begin
                    BuildLedgerRows(Customer);

                    if RowCount = 0 then
                        CurrReport.Break();

                    SetRange(Number, 1, RowCount);
                end;

                trigger OnAfterGetRecord()
                begin
                    LoadRow(Number);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                LoadCustomerContext(Customer);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfoRec.Get();

        if (FromDate <> 0D) and (ToDate = 0D) then
            ToDate := WorkDate();
    end;

    var
        CompanyInfoRec: Record "Company Information";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        StateRec: Record State;
        FromDate: Date;
        ToDate: Date;
        ReportTitleText: Text;
        CustomerDetailsText: Text;
        PostingDateText: Text[30];
        DocumentNoText: Text[100];
        ExternalDocNoText: Text[100];
        DescriptionText: Text[250];
        DebitAmountText: Text[50];
        CreditAmountText: Text[50];
        BalanceAmountText: Text[50];
        IsOpeningBalance: Boolean;
        IsTotalRow: Boolean;
        RowDateList: List of [Text];
        RowDocumentNoList: List of [Text];
        RowExternalDocNoList: List of [Text];
        RowDescriptionList: List of [Text];
        RowDebitAmountList: List of [Text];
        RowCreditAmountList: List of [Text];
        RowBalanceAmountList: List of [Text];
        RowIsOpeningList: List of [Boolean];
        RowIsTotalList: List of [Boolean];
        RowCount: Integer;
        OpeningBalanceValue: Decimal;
        RunningBalanceValue: Decimal;
        TotalDebitAmount: Decimal;
        TotalCreditAmount: Decimal;

    local procedure LoadCustomerContext(var CurrentCustomer: Record Customer)
    var
        StateDescription: Text;
    begin
        StateDescription := GetStateDescription(CurrentCustomer."State Code");
        ReportTitleText := StrSubstNo('General Ledger From %1 To %2', FormatReportDate(FromDate), FormatReportDate(ToDate));

        CustomerDetailsText :=
          StrSubstNo(
            'GSTIN : %1 , PAN : %2 , City : %3 , State : %4',
            CurrentCustomer."GST Registration No.",
            CurrentCustomer."P.A.N. No.",
            CurrentCustomer.City,
            StateDescription);
    end;

    local procedure BuildLedgerRows(var CurrentCustomer: Record Customer)
    var
        EntryAmount: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        StartDate: Date;
        EndDate: Date;
    begin
        ClearRowBuffers();

        StartDate := FromDate;
        EndDate := ToDate;
        OpeningBalanceValue := CalculateOpeningBalance(CurrentCustomer."No.", StartDate);
        RunningBalanceValue := OpeningBalanceValue;
        TotalDebitAmount := 0;
        TotalCreditAmount := 0;

        AddRow('', '', '', 'Balance B/f', '', '', FormatBalanceAmount(RunningBalanceValue), true, false);

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Customer No.", "Posting Date", "Entry No.");
        CustLedgerEntry.SetRange("Customer No.", CurrentCustomer."No.");

        if StartDate <> 0D then begin
            if EndDate = 0D then
                EndDate := WorkDate();
            CustLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
        end else
            if EndDate <> 0D then
                CustLedgerEntry.SetRange("Posting Date", 0D, EndDate);

        CustLedgerEntry.SetAutoCalcFields(Amount);

        if CustLedgerEntry.FindSet() then
            repeat
                EntryAmount := CustLedgerEntry.Amount;
                DebitAmount := 0;
                CreditAmount := 0;

                if EntryAmount >= 0 then begin
                    DebitAmount := EntryAmount;
                    TotalDebitAmount += DebitAmount;
                end else begin
                    CreditAmount := Abs(EntryAmount);
                    TotalCreditAmount += CreditAmount;
                end;

                RunningBalanceValue += EntryAmount;

                AddRow(
                  FormatReportDate(CustLedgerEntry."Posting Date"),
                  CustLedgerEntry."Document No.",
                  CustLedgerEntry."External Document No.",
                  CustLedgerEntry.Description,
                  FormatAmount(DebitAmount),
                  FormatAmount(CreditAmount),
                  FormatBalanceAmount(RunningBalanceValue),
                  false,
                  false);
            until CustLedgerEntry.Next() = 0;

        AddRow(
          '',
          '',
          '',
          'T o t a l :',
          FormatAmount(TotalDebitAmount),
          FormatAmount(TotalCreditAmount),
          FormatBalanceAmount(RunningBalanceValue),
          false,
          true);

        RowCount := RowDateList.Count();
    end;

    local procedure AddRow(DateText: Text; RefNo: Text; BillNo: Text; Particulars: Text; DebitText: Text; CreditText: Text; BalanceText: Text; OpeningRow: Boolean; TotalRow: Boolean)
    begin
        RowDateList.Add(DateText);
        RowDocumentNoList.Add(RefNo);
        RowExternalDocNoList.Add(BillNo);
        RowDescriptionList.Add(Particulars);
        RowDebitAmountList.Add(DebitText);
        RowCreditAmountList.Add(CreditText);
        RowBalanceAmountList.Add(BalanceText);
        RowIsOpeningList.Add(OpeningRow);
        RowIsTotalList.Add(TotalRow);
    end;

    local procedure LoadRow(RowNo: Integer)
    begin
        PostingDateText := CopyStr(RowDateList.Get(RowNo), 1, MaxStrLen(PostingDateText));
        DocumentNoText := CopyStr(RowDocumentNoList.Get(RowNo), 1, MaxStrLen(DocumentNoText));
        ExternalDocNoText := CopyStr(RowExternalDocNoList.Get(RowNo), 1, MaxStrLen(ExternalDocNoText));
        DescriptionText := CopyStr(RowDescriptionList.Get(RowNo), 1, MaxStrLen(DescriptionText));
        DebitAmountText := CopyStr(RowDebitAmountList.Get(RowNo), 1, MaxStrLen(DebitAmountText));
        CreditAmountText := CopyStr(RowCreditAmountList.Get(RowNo), 1, MaxStrLen(CreditAmountText));
        BalanceAmountText := CopyStr(RowBalanceAmountList.Get(RowNo), 1, MaxStrLen(BalanceAmountText));
        IsOpeningBalance := RowIsOpeningList.Get(RowNo);
        IsTotalRow := RowIsTotalList.Get(RowNo);
    end;

    local procedure ClearRowBuffers()
    begin
        Clear(RowDateList);
        Clear(RowDocumentNoList);
        Clear(RowExternalDocNoList);
        Clear(RowDescriptionList);
        Clear(RowDebitAmountList);
        Clear(RowCreditAmountList);
        Clear(RowBalanceAmountList);
        Clear(RowIsOpeningList);
        Clear(RowIsTotalList);
        RowCount := 0;
    end;

    local procedure CalculateOpeningBalance(CustomerNo: Code[20]; StartDate: Date): Decimal
    var
        PreviousEntry: Record "Cust. Ledger Entry";
        OpeningAmount: Decimal;
    begin
        if StartDate = 0D then
            exit(0);

        PreviousEntry.SetRange("Customer No.", CustomerNo);
        PreviousEntry.SetFilter("Posting Date", '<%1', StartDate);
        PreviousEntry.SetAutoCalcFields(Amount);

        if PreviousEntry.FindSet() then
            repeat
                OpeningAmount += PreviousEntry.Amount;
            until PreviousEntry.Next() = 0;

        exit(OpeningAmount);
    end;

    local procedure GetStateDescription(StateCode: Code[10]): Text
    begin
        if StateCode = '' then
            exit('');

        StateRec.Reset();
        StateRec.SetRange(Code, StateCode);
        if StateRec.FindFirst() then
            exit(StateRec.Description);

        exit(StateCode);
    end;

    local procedure FormatAmount(AmountValue: Decimal): Text
    begin
        if AmountValue = 0 then
            exit('');

        exit(Format(Round(Abs(AmountValue), 0.01), 0, '<Precision,2:2><Standard Format,0>'));
    end;

    local procedure FormatBalanceAmount(AmountValue: Decimal): Text
    begin
        if AmountValue < 0 then
            exit(StrSubstNo('%1 CR', Format(Round(Abs(AmountValue), 0.01), 0, '<Precision,2:2><Standard Format,0>')));

        exit(StrSubstNo('%1 DR', Format(Round(AmountValue, 0.01), 0, '<Precision,2:2><Standard Format,0>')));
    end;

    local procedure FormatReportDate(DateValue: Date): Text
    begin
        if DateValue = 0D then
            exit('');

        exit(Format(DateValue, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;
}
