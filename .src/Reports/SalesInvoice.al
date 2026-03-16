report 50003 "Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src\Reports\SalesInvoice.rdl';
    ApplicationArea = all;
    // UsageCategory = ReportsAndAnalysis;
    Caption = 'Sales Invoice Tax';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.";
            column(Picture_CompanyInfo; CompanyInfo.Picture)
            {
            }
            column(Name_CompanyInfo; CompanyInfo.Name)
            {
            }
            column(Name2_CompanyInfo; CompanyInfo."Name 2")
            {
            }
            column(VATRegistrationNo_CompanyInfo; CompanyInfo."VAT Registration No.")
            {
            }
            column(Address_CompanyInfo; CompanyInfo.Address)
            {
            }
            column(Address2_CompanyInfo; CompanyInfo."Address 2")
            {
            }
            column(CINNo_CompanyInfo; CompanyInfo."ARN No.")//23092025
            {
            }
            column(City_Post________Code_Companyinfo; CompanyInfo.City + ' - ' + CompanyInfo."Post Code")
            {
            }
            column(PanNo; CompanyInfo."P.A.N. No.")
            {
            }
            column(Country_CompanyInfo; CompanyInfo.County)
            {
            }
            column(Email_CompanyInfo; CompanyInfo."E-Mail")
            {
            }
            column(Web_CompanyInfo; CompanyInfo."Home Page")
            {
            }
            column(Ph1_CompanyInfo; CompanyInfo."Phone No.")
            {
            }
            column(Ph2_CompanyInfo; CompanyInfo."Phone No. 2")
            {
            }
            /*    column(TIN_No_CompInfo; CompanyInfo."T.I.N. No.")
                {
                }
                column(CST_No_CompInfo; CompanyInfo."C.S.T No.")
                {
                } */
            column(GST_CompanyInfo; 'GST Reg. No. ' + CompanyInfo."GST Registration No.")
            {
            }
            column(GST_Loc_noinfo; RecLocation."GST Registration No.")
            {
            }
            /*    column(ECC_No_CompInfo; CompanyInfo."E.C.C. No.")
                {
                } */
            column(TINNOEffectiveDate_CompanyInfo; CompanyInfo."Created DateTime") //23092025
            {
            }
            column(ROName__CompanyInfo; CompanyInfo.Name) //23092025
            {
            }
            column(ROAddr2_CompanyInfo; CompanyInfo.Address)//23092025
            {
            }
            column(ROAddr_CompanyInfo; CompanyInfo."Address 2")//23092025
            {
            }
            column(ROCity_CompanyInfo; CompanyInfo.City)//23092025
            {
            }
            column(ROPostCode_CompanyInfo; CompanyInfo."Country/Region Code")//23092025
            {
            }
            column(FaxNo_CompanyInfo; CompanyInfo."Fax No.")
            {
            }
            /*     column(Comp_FSSAI_no; CompanyInfo."Factories Act. Regd. No.")
                {
                }
                column(TIN_No_Location; RecLocation."T.I.N. No.")
                {
                }
                column(CST_No_Location; RecLocation."C.S.T No.")
                {
                }
                column(ECC_No_Location; RecLocation."E.C.C. No.")
                {
                }*/
            column(Fssai_no; RecLocation."Location ARN No.") //23092025
            {
            }
            column(ExpectedReceiptDate_PurchaseHeader; "Sales Invoice Header"."Shipment Date")
            {
            }
            column(No_PurchaseHeader; "Sales Invoice Header"."No.")
            {
            }
            column(OrderDate_PurchaseHeader; "Sales Invoice Header"."Order Date")
            {
            }
            column(QuoteNo_PurchaseHeader; "Sales Invoice Header"."Quote No.")
            {
            }
            column(BuyfromVendorNo_PurchaseHeader; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(BuyfromVendorName_PurchaseHeader; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(BuyfromVendorName2_PurchaseHeader; "Sales Invoice Header"."Sell-to Customer Name 2")
            {
            }
            column(BuyfromAddress_PurchaseHeader; "Sales Invoice Header"."Sell-to Address")
            {
            }
            column(BuyfromAddress2_PurchaseHeader; "Sales Invoice Header"."Sell-to Address 2")
            {
            }
            column(BuyfromCity_PurchaseHeader; "Sales Invoice Header"."Sell-to City")
            {
            }
            column(BuyfromContact_PurchaseHeader; "Sales Invoice Header"."Sell-to Contact")
            {
            }
            column(BuyfromPostCode_PurchaseHeader; "Sales Invoice Header"."Sell-to Post Code")
            {
            }
            column(PhnNo_Vendor; RecVendor."Phone No.")
            {
            }
            column(Vendor_Gsttno; RecVendor."GST Registration No.")
            {
            }
            column(Fax_Vendor; RsVendor."Fax No.")
            {
            }
            column(MobileNo_Contact; RecContact."Mobile Phone No.")
            {
            }
            column(CurrencyCode_PurchaseHeader; "Sales Invoice Header"."Currency Code")
            {
            }
            column(ShiptoPostCode_PurchaseHeader; "Sales Invoice Header"."Ship-to Post Code")
            {
            }
            column(ShiptoName_PurchaseHeader; "Sales Invoice Header"."Ship-to Name")
            {
            }
            column(ShiptoName2_PurchaseHeader; "Sales Invoice Header"."Ship-to Name 2")
            {
            }
            column(ShiptoAddress_PurchaseHeader; "Sales Invoice Header"."Ship-to Address")
            {
            }
            column(ShiptoAddress2_PurchaseHeader; "Sales Invoice Header"."Ship-to Address 2")
            {
            }
            column(ShiptoCity_PurchaseHeader; "Sales Invoice Header"."Ship-to City")
            {
            }
            column(Currency_Code; CurrencyCode)
            {
            }
            column(numtext; NumberText[1])
            {
            }
            column(FrieghtTerms_PurchaseHeader; "Sales Invoice Header"."Payment Terms Code" + ' .') //23092025
            {
            }
            column(VendorItemCode; RecVendorItem."Vendor Item No.")
            {
            }
            column(DocumentDate_PurchaseHeader; "Sales Invoice Header"."Document Date")
            {
            }
            column(Email; "RecPurch&PaySetup"."Order Nos.") //23092025
            {
            }
            column(Note1; "RecPurch&PaySetup"."Order Nos.") //23092025
            {
            }
            column(Note2; "RecPurch&PaySetup"."Order Nos.") //23092025
            {
            }
            column(Note; "RecPurch&PaySetup"."Order Nos." + ' .') //23092025
            {
            }
            column(VendorOrderNo_PurchaseHeader; "Sales Invoice Header"."External Document No.")
            {
            }
            column(PaymentTermsCode_PurchaseHeader; "Sales Invoice Header"."Payment Terms Code" + ' .')
            {
            }
            column(POValidityDate_PurchaseHeader; "Sales Invoice Header"."Posting Date")//23092025
            {
            }
            column(VendorOrderDate_PurchaseHeader; "Sales Invoice Header"."Posting Date")//23092025
            {
            }
            column(Amnd_No; RecPurchHeadArchive."No. of Archived Versions")
            {
            }
            column(Amnd_Date; RecPurchHeadArchive."Date Archived")
            {
            }
            column(AmndNo; AmndNo)
            {
            }
            column(PurchaserCode_PurchaseHeader; "Sales Invoice Header"."Salesperson Code")
            {
            }
            column(Approvedby_PurchaseHeader; "Sales Invoice Header".SystemCreatedBy) //23092025
            {
            }
            column(UserID_PurchaseHeader; "Sales Invoice Header"."User ID") //23092025
            {
            }
            column(PurchaserName; PurchaserName)
            {
            }
            column(Warranty_PurchaseHeader; "Sales Invoice Header"."No.")//23092025
            {
            }
            column(Installation_PurchaseHeader; "Sales Invoice Header"."No.")//23092025
            {
            }
            column(AmmendmentReason_PurchaseHeader; "Sales Invoice Header"."Reason Code")//23092025
            {
            }
            column(Remarks_header; Remarks_header)
            {
            }
            column(OtherTerms_PurchaseHeader; "Sales Invoice Header"."No.")//23092025
            {
            }
            column(PurchaseHeader_ApproverID; "Sales Invoice Header".SystemCreatedBy)//23092025
            {
            }
            column(Approver_name; Appr_name)
            {
            }
            column(Status_PurchaseHeader; 'Posted')
            {
            }
            column(CGSTAmt; CGSTAmt)
            {

            }
            column(SGSTAmt; SGSTAmt)
            {

            }
            column(IGSTAmt; IGSTAmt)
            {

            }
            column(TotalVal; TotalVal)
            {
            }
            column(Amttowords; TotalInvAmtinWords[1])
            {
            }
            column(TOTAL; TOTAL)
            {
            }
            dataitem("Purchase Line1"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                /*  column(AmountToVendor_PurchaseLine; "Purchase Line1"."Amount To Vendor")
                  {
                  } */
                column(Line_No_; "Line No.")
                { }
                column(sr; SRNO)
                {
                }
                column(Amount_PurchaseLine; "Purchase Line1".Amount)
                {
                }
                column(DirectUnitCost_PurchaseLine; "Purchase Line1"."Unit Price")
                {
                }
                column(No_PurchaseLine; "Purchase Line1"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line1".Description)
                {
                }
                column(Description2_PurchaseLine; "Purchase Line1"."Description 2")
                {
                }
                column(UnitofMeasure_PurchaseLine; "Purchase Line1"."Unit of Measure Code")
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line1".Quantity)
                {
                }
                /*    column(TaxAmount_PurchaseLine; "Purchase Line1"."Tax Amount")
                    {
                    }
                    column(ExciseAmount_PurchaseLine; "Purchase Line1"."Excise Amount")
                    {
                    } */
                column(AmountIncludingVAT_PurchaseLine; "Purchase Line1"."Amount Including VAT")
                {
                }
                column(LineDiscount_PurchaseLine; "Purchase Line1"."Line Discount %")
                {
                }
                column(LineAmount_PurchaseLine; "Purchase Line1"."Line Amount")
                {
                }
                column(ExciseAmt; ExciseAmt)
                {
                }
                column(Excise_Perc; "Excise%")
                {
                }
                column(Cst_Perc; "Cst%")
                {
                }
                column(Cst_Amount; CstAmount)
                {
                }
                column(Vat_perc; "Vat%")
                {
                }
                column(TaxAreaCode; TaxAreaCode)
                {
                }
                column(RoundOff; RoundOff)
                {
                }
                column(PayTerm; PayTerm)
                {
                }
                column(Charge; Charge)
                {
                }
                column(Charge1; Charge1)
                {
                }
                column(VendorItemNo_PurchaseLine; "Purchase Line1"."No.")
                {
                }
                column(ExpectedReceiptDate_PurchaseLine; "Purchase Line1"."Promised Delivery Date")
                {
                }
                column(Remarks; Comment_Remarks)
                {
                }
                column(GSTper; GSTper)
                {
                }
                column(GSTAMT; GSTAMT)
                {
                }
                column(SGST; SGSTAmtLine)
                {
                }
                column(CGST; CGSTAmtLine)
                {
                }
                column(IGST; IGSTAmtLine)
                {
                }
                column(UTGST; GSTAMT1[4])
                {
                }

                column(HSNCOde; "Purchase Line1"."HSN/SAC Code")
                {
                }




                trigger OnAfterGetRecord()
                begin
                    IF "Purchase Line1"."No." <> '' THEN
                        SRNO := SRNO + 1;

                    //  "Cst%" := "Purchase Line1"."Tax %";
                    //ExcisePer:=

                    /*    CstAmount := 0;
                        ExciseAmt := 0;
                        RecPurchaseLine.RESET;
                        RecPurchaseLine.SETFILTER(RecPurchaseLine."Document No.", "Sales Invoice Header"."No.");
                        IF RecPurchaseLine.FINDSET THEN BEGIN
                            REPEAT
                                CstAmount += RecPurchaseLine."Tax Amount";
                                ExciseAmt += RecPurchaseLine."Excise Amount";
                            UNTIL RecPurchaseLine.NEXT = 0;
                        END; */

                    //-------Here we get Total Amount
                    TOTALAMT := 0;
                    RecPurchaseLine.RESET;
                    RecPurchaseLine.SETFILTER(RecPurchaseLine."Document No.", "Sales Invoice Header"."No.");
                    IF RecPurchaseLine.FINDSET THEN
                        REPEAT
                            TOTALAMT += RecPurchaseLine.Amount;
                        UNTIL RecPurchaseLine.NEXT = 0;

                    /*    strordrline.RESET;
                        AmtToVendor := 0;
                        strordrline.RESET;
                        strordrline.SETRANGE(strordrline."Document No.", "Sales Invoice Header"."No.");
                        strordrline.SETFILTER("Tax/Charge Code", '<>%1', 'GST');
                        IF strordrline.FINDSET THEN
                            REPEAT
                                AmtToVendor += strordrline.Amount;
                            UNTIL strordrline.NEXT = 0; */
                    //MESSAGE(FORMAT(AmtToVendor));

                    //Here we get Total amt in Words
                    CLEAR(GrandTot);
                    RecPurchaseLine.RESET;
                    //GrandTot+=ROUND(AmtToVendor+TOTALAMT,1,'=');
                    GrandTot += ROUND(AmtToVendor + TOTALAMT);
                    RecCheck.InitTextVariable;
                    RecCheck.FormatNoText(NumberText, GrandTot, "Purchase Line1"."Currency Code");



                    //Here we get Comments of line
                    CLEAR(Comment_Remarks);
                    RecPurchComLine.RESET;
                    RecPurchComLine.SETRANGE(RecPurchComLine."No.", "Purchase Line1"."Document No.");
                    RecPurchComLine.SETRANGE(RecPurchComLine."Document Line No.", "Purchase Line1"."Line No.");
                    IF RecPurchComLine.FINDFIRST THEN
                        REPEAT
                            Comment_Remarks += RecPurchComLine.Comment;
                        UNTIL RecPurchComLine.NEXT = 0;

                    //Excise %
                    /*   RecExcise.RESET;
                       RecExcise.SETRANGE(RecExcise."Excise Prod. Posting Group", "Excise Prod. Posting Group");
                       IF RecExcise.FINDFIRST THEN
                           "Excise%" := RecExcise."BED %";
                       */


                    CLEAR(GSTper);
                    CLEAR(GSTAMT1);
                    CLEAR(GSTAMT);
                    /*   DetailGDTEntryBuffer.RESET;
                       DetailGDTEntryBuffer.SETRANGE("Document No.", "Purchase Line1"."Document No.");
                       DetailGDTEntryBuffer.SETRANGE("Document Type", DetailGDTEntryBuffer."Document Type"::Order);
                       DetailGDTEntryBuffer.SETRANGE("Transaction Type", DetailGDTEntryBuffer."Transaction Type"::Purchase);
                       DetailGDTEntryBuffer.SETRANGE("Line No.", "Purchase Line1"."Line No.");
                       IF DetailGDTEntryBuffer.FINDFIRST THEN
                           REPEAT
                               HSNCOde := DetailGDTEntryBuffer."HSN/SAC Code";
                               //IF (DetailGDTEntryBuffer."GST Component Code"='SGST') OR (DetailGDTEntryBuffer."GST Component Code"='CGST') THEN BEGIN
                               GSTper += DetailGDTEntryBuffer."GST %";
                               GSTAMT += DetailGDTEntryBuffer."GST Amount";
                           UNTIL DetailGDTEntryBuffer.NEXT = 0;

                       DetailedGSTLedgerEntry.RESET;
                       DetailedGSTLedgerEntry.SETRANGE("Document No.", "Purchase Line1"."Document No.");
                       IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
                           REPEAT

                               IF DetailedGSTLedgerEntry."GST Component Code" = 'CGST' THEN BEGIN

                                   GSTAMT1[1] += (DetailedGSTLedgerEntry."GST Amount");
                               END;
                               IF DetailedGSTLedgerEntry."GST Component Code" = 'SGST' THEN BEGIN

                                   GSTAMT1[2] += (DetailedGSTLedgerEntry."GST Amount");
                               END;
                               IF DetailedGSTLedgerEntry."GST Component Code" = 'IGST' THEN BEGIN

                                   GSTAMT1[3] += (DetailedGSTLedgerEntry."GST Amount");
                               END;
                               IF DetailedGSTLedgerEntry."GST Component Code" = 'UTGST' THEN BEGIN

                                   GSTAMT1[4] += (DetailedGSTLedgerEntry."GST Amount");
                               END;

                           UNTIL DetailedGSTLedgerEntry.NEXT = 0;
                       END;*/


                    //FOR CGST


                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", "Purchase Line1".RecordId);
                    TaxTransactionValue.SetRange("Tax Type", 'GST');
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter("Value ID", '%1|%2|%3', 2, 3, 6); //For IGST
                    if TaxTransactionValue.FindFirst() then begin
                        repeat
                            GSTper += TaxTransactionValue.Percent;
                            TaxComponent.Get('GST', TaxTransactionValue."Value ID");
                            GSTAMT += TaxRateComputation.RoundAmount(TaxTransactionValue.Amount, TaxComponent."Rounding Precision", TaxComponent.Direction);
                        until TaxTransactionValue.Next() = 0;
                    end;


                    // GSTAMT += CGSTAmtLine + IGSTAmtLine + SGSTAmtLine;
                    // CGSTAmt += CGSTAmtLine;
                    // SGSTAmt += SGSTAmtLine;
                    // IGSTAmt += IGSTAmtLine;






                    //   TotalTaxAmt := GSTAMT1[1] + GSTAMT1[2] + GSTAMT1[3] + GSTAMT1[4];

                end;

                trigger OnPreDataItem()
                begin
                    //TotAmt:=0;
                end;
            }
            dataitem("Purchase Header Archive"; "Sales Header Archive")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemLinkReference = "Sales Invoice Header";
                column(NoofArchivedVersions_PurchaseHeaderArchive; "Purchase Header Archive"."No. of Archived Versions")
                {
                }
                column(DateArchived_PurchaseHeaderArchive; "Purchase Header Archive"."Date Archived")
                {
                }
                column(VersionNo_PurchaseHeaderArchive; "Purchase Header Archive"."Version No.")
                {
                }
            }
            dataitem(Integer; Integer)
            {
                column(Number_Integer; Integer.Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF SrNoCnt > 18 THEN
                        newCnt := 18 - ROUND((SrNoCnt / 18 - ROUND(SrNoCnt / 18, 1, '<')) * 18, 1)
                    ELSE
                        newCnt := 18 - SrNoCnt;

                    Integer.SETRANGE(Integer.Number, 1, newCnt);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // Clear(CGSTAmt); 
                // Clear(SGSTAmt); 
                // Clear(IGSTAmt); 
                IF RecVendor.GET("Sales Invoice Header"."Sell-to Customer No.") THEN;
                IF RecContact.GET("Sales Invoice Header"."Sell-to Contact No.") THEN;
                IF "RecPurch&PaySetup".GET() THEN;
                //IF RecPurchComLine.GET() THEN;

                RecState.SETRANGE(RecState.Code, State);      // IF State are same then VAT else CST done 28-04-2016
                IF RecState.FINDFIRST THEN
                    VendState := RecState.Description;



                IF "Sales Invoice Header"."Currency Code" <> '' THEN
                    CurrencyCode := '(' + "Sales Invoice Header"."Currency Code" + ')'
                ELSE
                    RecPurchaser.RESET;
                RecPurchaser.SETRANGE(RecPurchaser.Code, "Salesperson Code");
                IF RecPurchaser.FINDFIRST THEN
                    PurchaserName := RecPurchaser.Code + '/' + RecPurchaser.Name;

                /*  RecPurchaser.RESET;
                 RecPurchaser.SETRANGE(RecPurchaser.Code, "Sales Invoice Header"."Approver ID");
                 IF RecPurchaser.FINDFIRST THEN
                     Appr_name := "Sales Invoice Header"."Approver ID" + '/' + RecPurchaser.Name; */ //23092025



                IF "Sales Invoice Header"."Currency Code" = '' THEN
                    CurrencyCode := '(INR)';

                RecLocation.SETRANGE(RecLocation.Code, "Sales Invoice Header"."Location Code");
                IF RecLocation.FINDFIRST THEN;


                //Here we get Payment Term
                RecPayTerm.RESET;
                RecPayTerm.SETRANGE(RecPayTerm.Code, "Sales Invoice Header"."Payment Terms Code");
                IF RecPayTerm.FINDFIRST THEN BEGIN
                    PayTerm := RecPayTerm.Description;
                END ELSE
                    PayTerm := '';


                //Charges caculations
                Charge := 0;
                //Charge1:=0;
                /*      RecStructOrderLine.RESET;
                     RecStructOrderLine.SETFILTER(RecStructOrderLine."Document No.", '%1', "Sales Invoice Header"."No.");
                     RecStructOrderLine.SETFILTER(RecStructOrderLine."Tax/Charge Type", '%1', RecStructOrderLine."Tax/Charge Type"::Charges);
                     IF RecStructOrderLine.FINDSET THEN BEGIN

                         RecStructOrderLine.SETFILTER("Tax/Charge Group", '%1', RecStructOrderLine."Tax/Charge Group");
                         IF RecStructOrderLine.FINDFIRST THEN BEGIN
                             REPEAT
                                 Charge += RecStructOrderLine.Amount;
                             UNTIL RecStructOrderLine.NEXT = 0;
                         END;
                     END; */


                //Here we get Rounding off amount
                RsVendor.RESET;
                IF RsVendor.GET("Sales Invoice Header"."Sell-to Customer No.") THEN BEGIN
                    RsVendorPosting.RESET;
                    RsVendorPosting.SETRANGE(RsVendorPosting.Code, RsVendor."Customer Posting Group");
                    IF RsVendorPosting.FINDFIRST THEN
                        InvoiceRoundingAcc := RsVendorPosting."Invoice Rounding Account";
                END;

                PurchaseLineTmp.RESET;
                PurchaseLineTmp.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                PurchaseLineTmp.SETRANGE(Type, PurchaseLineTmp.Type::"G/L Account");
                PurchaseLineTmp.SETRANGE("No.", InvoiceRoundingAcc);
                IF PurchaseLineTmp.FINDFIRST THEN
                    RoundOff := PurchaseLineTmp.Amount;


                AmndNo := 0;
                RecPurchHeadArchive.SETRANGE(RecPurchHeadArchive."No.", "No.");
                IF RecPurchHeadArchive.FINDLAST THEN
                    AmndNo := RecPurchHeadArchive."Version No.";

                Remarks_header := '';
                RecPurchComLine.RESET;
                RecPurchComLine.SETRANGE(RecPurchComLine."Document Line No.", 0);
                RecPurchComLine.SETRANGE(RecPurchComLine."No.", "No.");
                IF RecPurchComLine.FINDFIRST THEN
                    REPEAT
                        Remarks_header += RecPurchComLine.Comment;
                    //MESSAGE(Remarks_header);
                    UNTIL RecPurchComLine.NEXT = 0;

                //Quotation Date
                recPH.RESET;
                recPH.SETRANGE(recPH."No.", "No.");
                //recPH.SETRANGE(recPH."Document Type",recPH."Document Type"::'Quote');
                Clear(CGSTAmt);
                Clear(SGSTAmt);
                Clear(IGSTAmt);
                purchline.RESET;
                purchline.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                IF purchline.FindSet() THEN
                    REPEAT
                        TOTAL += purchline.Amount;

                        TaxTransactionValue.SetRange("Tax Record ID", purchline.RecordId);
                        TaxTransactionValue.SetRange("Tax Type", 'GST');
                        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                        TaxTransactionValue.SetRange("Value ID", 2); //For CGST
                        if TaxTransactionValue.FindFirst() then begin
                            repeat
                                //    GSTper += TaxTransactionValue.Percent;
                                TaxComponent.Get('GST', 2);
                                CGSTAmt += TaxRateComputation.RoundAmount(TaxTransactionValue.Amount, TaxComponent."Rounding Precision", TaxComponent.Direction);
                            until TaxTransactionValue.Next() = 0;
                        end;

                        //FOR SGST

                        TaxTransactionValue.SetRange("Tax Record ID", purchline.RecordId);
                        TaxTransactionValue.SetRange("Tax Type", 'GST');
                        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                        TaxTransactionValue.SetRange("Value ID", 6); //For SGST
                        if TaxTransactionValue.FindFirst() then begin
                            repeat
                                //    GSTper += TaxTransactionValue.Percent;
                                TaxComponent.Get('GST', 6);
                                SGSTAmt += TaxRateComputation.RoundAmount(TaxTransactionValue.Amount, TaxComponent."Rounding Precision", TaxComponent.Direction);
                            until TaxTransactionValue.Next() = 0;
                        end;


                        //FOR IGST

                        TaxTransactionValue.SetRange("Tax Record ID", purchline.RecordId);
                        TaxTransactionValue.SetRange("Tax Type", 'GST');
                        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                        TaxTransactionValue.SetRange("Value ID", 3); //For IGST
                        if TaxTransactionValue.FindFirst() then begin
                            repeat
                                //  GSTper += TaxTransactionValue.Percent;
                                TaxComponent.Get('GST', 3);
                                IGSTAmt += TaxRateComputation.RoundAmount(TaxTransactionValue.Amount, TaxComponent."Rounding Precision", TaxComponent.Direction);
                            until TaxTransactionValue.Next() = 0;
                        end;
                    UNTIL purchline.NEXT = 0;


                CLEAR(TotalVal);
                TotalVal := TOTAL + CGSTAmt + IGSTAmt + SGSTAmt;   //  TotalTaxAmt + AmtToVendor;
                                                                   //MESSAGE(FORMAT(TotalVal));

                // CLEAR(TotalVal1);
                // TotalVal1 := TOTAL + TotalVal;

                CheckG.InitTextVariable();
                CheckG.FormatNoText(TotalInvAmtinWords, ((TotalVal)), '');
                //MESSAGE(FORMAT(TotalInvAmtinWords[1]));
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET();
                CompanyInfo.CALCFIELDS(Picture);


                /*   RecState.SETRANGE(RecState.Code, CompanyInfo.State);      // IF State are same then VAT else CST done 28-04-2016
                   IF RecState.FINDFIRST THEN
                       CompState := RecState.Description; */
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    //trigger OnInitReport()
    ///begin
    // IF "Sales Invoice Header"."No." = '' THEN
    //   CurrReport.SKIP;
    //end;

    trigger OnPreReport()
    begin
        //MaxCntr:=23;
        SrNoCnt := 0;
        newCnt := 0;
        ExcisePer := 0;
    end;

    var
        CompanyInfo: Record "Company Information";
        RecVendor: Record Customer;
        RecContact: Record Contact;
        CurrencyCode: Code[10];
        RecGenralLedgerSetup: Record "General Ledger Setup";
        RecPurchaseHeader: Record "Sales Invoice Header";
        SRNO: Integer;
        // SOPOTerms: Record "Job Title"; //23092025
        Currency: Code[10];
        recPH: Record "Sales Invoice Header";
        NumberText: array[2] of Text[250];
        RecCheck: Report Check;
        ExciseAmt: Decimal;
        "Excise%": Decimal;
        "Cst%": Decimal;
        "Vat%": Decimal;
        CstAmount: Decimal;
        VatAmount: Decimal;
        TaxAreaCode: Code[20];
        TotCSTAmt: array[2] of Text[150];
        CSTAmt: Decimal;
        RecPayTerm: Record "Payment Terms";
        RsVendor: Record Customer;
        InvoiceRoundingAcc: Code[20];
        RoundOff: Decimal;
        RecPurchaseLine: Record "Sales Line";
        PayTerm: Text;
        TOTALAMT: Decimal;
        TotAmt: Decimal;
        RecLocation: Record Location;
        RsVendorPosting: Record "Customer Posting Group";
        PurchaseLineTmp: Record "Sales Line";
        Charge: Decimal;
        Charge1: Decimal;
        // RecStructOrderLine: Record "13795";
        GrandTot: Decimal;
        AmtToVendor: Decimal;
        RecVendorItem: Record "Item Vendor";
        VendorItemCode: Text[30];
        ItemDet: Text[50];
        RecItem: Record Item;
        SrNoCnt: Integer;
        newCnt: Integer;
        ExcisePer: Decimal;
        "RecPurch&PaySetup": Record "Sales & Receivables Setup";
        TaxCode: Code[30];
        Comment_Remarks: Text;
        RecPurchComLine: Record "Sales Comment Line";
        RecPurchHeadArchive: Record "Sales Header Archive";
        AmndNo: Integer;
        VendState: Text;
        CompState: Text;
        RecState: Record State;
        // RecExcise: Record "13711";
        RecPurchaser: Record "Salesperson/Purchaser";
        PurchaserName: Text;
        Remarks_header: Text;
        RecPurchComHead: Record "Sales Comment Line";
        DetailGDTEntryBuffer: Record "Detailed GST Entry Buffer";
        GSTper: Decimal;
        GSTAMT: Decimal;
        GSTAMT1: array[4] of Decimal;
        CGSTAmt: Decimal; // 11042024
        SGSTAmt: Decimal; // 11042024
        IGSTAmt: Decimal; //11042024
        IGSTAmtLine: Decimal; // 11042024
        CGSTAmtLine: Decimal;// 11042024
        SGSTAmtLine: Decimal;// 11042024
        HSNCOde: Code[30];
        TOTAL: Decimal;
        DetailedGSTLedgerEntry: Record "Detailed GST Entry Buffer";
        TotalTaxAmt: Decimal;
        TotalVal: Decimal;
        CheckG: Report Check;
        TotalInvAmtinWords: array[2] of Text;
        purchline: Record "Sales Line";
        TotalVal1: Decimal;
        //   strordrline: Record "13795";
        Appr_name: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxComponent: Record "Tax Component";
        TaxRateComputation: Codeunit "Tax Rate Computation";
}

