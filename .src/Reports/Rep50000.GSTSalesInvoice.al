report 50000 "GST-Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src\Reports\GSTSalesInvoice.rdl';
    ApplicationArea = all;
    // UsageCategory = ReportsAndAnalysis;
    Caption = 'GST-Sales Invoice';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(Order_Datenew; "Order Date") { }
            column(Order_No_; "Order No.") { }
            column(LocStateDesc; LocStateDesc)
            {
            }
            column(LocCode; LocCode)
            {
            }
            column(LocAddr; LocAddr)
            {
            }
            column(LocCity; LocCity)
            {
            }
            column(LocGSTRegNo; LocGSTRegNo)
            {
            }
            column(LocName; LocName)
            {
            }
            column(LocTin; LocTin)
            {
            }
            column(LocCode1; LocCode1)
            {
            }
            column(locGSTNo; locGSTNo)
            {
            }
            column(LocCode2; LocCode2)
            {
            }
            column(CityName; CityName)
            {
            }
            column(companyInfo_Name; companyInfo.Name)
            {
            }
            column(companyInfo_Address; companyInfo.Address)
            {
            }
            column(companyInfo_City; companyInfo.City + '-' + companyInfo."Post Code")
            {
            }
            column(Purchase_Order_No_; "Order No.") //09102025
            { }
            column(Purchase_Order_data; "Order Date")//09102025
            { }
            column(Comp_State; companyInfo."State Code")
            {
            }
            column(companyInfo_State; companyInfo."State Code" + companyInfo.County)
            {
            }
            column(CompanyPicture; companyInfo.Picture)
            {
            }
            column(County; companyInfo.County)
            {
            }
            column(CompanyHomePage; companyInfo."Home Page")
            {
            }
            column(CompanyEmail; companyInfo."E-Mail")
            {
            }
            column(CompanyPhone; companyInfo."Phone No.")
            {
            }
            column(CompanyFax; companyInfo."Fax No.")
            {
            }
            column(ComGStReg; companyInfo."GST Registration No.")
            {
            }
            /*     column(CompanyTIN; companyInfo."T.I.N. No.")
                 {
                 } */ 
            column(CINNO; companyInfo."ARN No.") //09102025
            {
            }
            column(Comp_PCode; companyInfo."Post Code")
            {
            }
            column(Comp_PANno; companyInfo."P.A.N. No.")
            {
            }
            column(cust_Name; cust.Name)
            {
            }
            column(cust_Address; cust.Address)
            {
            }
            column(State_Code; cust."State Code")
            {
            }
            column(cust_GST_Registration_No; cust."GST Registration No.")
            {
            }
            /*  column(CustTinNo; cust."T.I.N. No.")
              {
              } */
            column(From_Name; From_Name)
            {
            }
            column(From_Address; From_Address)
            {
            }
            column(From_StateCode; From_StateCode)
            {
            }
            column(From_State; From_State)
            {
            }
            column(From_GSTIN; From_GSTIN)
            {
            }
            column(From_State_NO; From_State_NO)
            {
            }
            column(To_Name; To_Name)
            {
            }
            column(To_Address; To_Address)
            {
            }
            column(To_StateCode; To_StateCode)
            {
            }
            column(To_State; To_State)
            {
            }
            column(To_GSTIN; To_GSTIN)
            {
            }
            column(Cust_Sate_No; Cust_Sate_No)
            {
            }
            column(CustContactno; CustContact)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CustomerPONo; "Sales Invoice Header"."No.") //09102025
            {
            }
            column(totQty; totQty)
            {
            }
            column(FSS; FSS)
            {
            }
            column(TINNo; TINNo)
            {
            }
            column(SelToTicyName; SelToTicyName)
            {
            }
            column(Shiptocityname; Shiptocityname)
            {
            }
            column(Dispatch_Location; Dispatch_Location)
            {
            }
            column(Loc_addr; Loc_addr)
            {
            }
            column(Loc_addr_2; Loc_addr_2)
            {
            }
            column(City; City)
            {
            }
            column(Phone_no; Phone_no)
            {
            }
            column(postcode; postcode)
            {
            }
            column(Comp_state_description; Comp_state_description)
            {
            }
            column(IRNNo_SalesInvoiceHeader; "Sales Invoice Header"."No.")
            {
            } //09102025
            column(Copm_stateCode; Copm_stateCode)
            {
            }
            column(GSTIN_NO_C; GSTIN_NO_C)
            {
            }
            column(NewNumber; NewNumber)
            {
            }
            column(CustomerType_SalesInvoiceHeader; "Sales Invoice Header"."Transaction Type")
            {
            } //09102025
            column(Cust_div; Custdiv)
            {
            }
            column(QRCode_SalesInvoiceLine; '')
            {
            } //09102025
            column(CusPANno; CusPANno)
            {
            }
            column(From_Address1; From_Address1)
            {
            }
            // column(GSTCompCode; GSTCompCode) 
            // {

            // }
            column(EwayNo; EwayNo)
            {

            }
            column(EwayBy; EwayBy)
            {

            }
            column(EWayBillDate; EWayBillDate)
            {

            }
            column(EwayValidfrom; EwayValidfrom)
            {

            }
            column(EwayValidto; EwayValidto)
            {

            }
            column(EwayTransactionType; EwayTransactionType)
            {

            }
            column(EwayTransportername; EwayTransportername)
            {

            }
            column(EwayTransportdocno; EwayTransportdocno)
            {

            }
            column(EwayReasonforTransport; EwayReasonforTransport)
            {

            }
            column(ewayQR; '')
            {

            } //09102025
            column(ShowEwayDetails; ShowEwayDetails)
            {

            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(Title; Title)
                    {
                    }
                    column(Ship_to_Name; "Sales Invoice Header"."Ship-to Name")
                    {
                    }
                    column(Ship_to_Address; "Sales Invoice Header"."Ship-to Address")
                    {
                    }
                    column(State; "Sales Invoice Header".State)
                    {
                    }
                    column(invoice_no; "Sales Invoice Header"."No.")
                    {
                    }
                    column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
                    {
                    }
                    column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
                    {
                    }
                    column(AmounttoCustomer_SalesInvoiceHeader; AmountToCustomer) //"Sales Invoice Header"."Amount to Customer")
                    {
                    }
                    column(TCSAmt; TCSAmt)
                    {
                    }
                    column(TransportMethod; "Sales Invoice Header"."Mode of Transport")
                    {
                    }
                    column(VechileNo; "Sales Invoice Header"."Vehicle No.")
                    {
                    }
                    column(LRNO; "Sales Invoice Header"."No.")
                    {
                    }//09102025
                    column(LRDate; "Sales Invoice Header"."Posting Date")
                    {
                    }//09102025
                    column(TransName; "Sales Invoice Header"."Sell-to Customer Name")
                    {
                    } //09102025
                    column(Dateof_suply; "Sales Invoice Header"."Shipment Date")
                    {
                    }
                    column(placeofsupply; "Sales Invoice Header"."Ship-to City")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(posting_date; "Sales Invoice Header"."Posting Date")
                    {
                    }
                    column(Cust_code; "Sales Invoice Header"."Sell-to Customer No.")
                    {
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        column(type; "Sales Invoice Line".Type)
                        {
                        }
                        column(SrNo; "Sr.No")
                        {
                        }
                        column(QtyText; QtyText)
                        {
                        }
                        column(Description; "Sales Invoice Line".Description)
                        {
                        }
                        column(Type_SalesInvoiceLine; "Sales Invoice Line".Type)
                        {
                        }
                        column(HSN_SAC_Code; "Sales Invoice Line"."HSN/SAC Code")
                        {
                        }
                        column(Quantity; FORMAT("Sales Invoice Line".Quantity))
                        {
                        }
                        column(UnitofMeasure; "Sales Invoice Line"."Unit of Measure Code")
                        {
                        }
                        column(Unit_Price; "Sales Invoice Line"."Unit Price")
                        {
                        }
                        column(Amount; "Sales Invoice Line".Amount / CalcAmountInUSD())
                        {
                        }
                        column(Line_Discount; "Sales Invoice Line"."Line Discount %")
                        {
                        }
                        column(GST_Base_Amount; abs(SILGstBaseAmount)) // "Sales Invoice Line"."GST Base Amount")
                        {
                        }
                        column(Tcs; TCSAmt / CalcAmountInUSD()) // "Sales Invoice Line"."TDS/TCS Amount")
                        {
                        }
                        column(packsize1; packSize1)
                        {
                        }
                        column(rate1; rate1)
                        {
                        }
                        column(amt1; amt1)
                        {
                        }
                        column(rate2; rate2)
                        {
                        }
                        column(amt2; amt2)
                        {
                        }
                        column(rate3; rate3)
                        {
                        }
                        column(amt3; amt3)
                        {
                        }
                        column(amt4; amt4)
                        {
                        }
                        column(TotalGSTAmount_SalesInvoiceLine; abs(SILGstAmount))// "Sales Invoice Line"."Total GST Amount")
                        {
                        }
                        // column(AmountInWord; AmountInWord[1])
                        // {
                        // }
                        // 21022025
                        // column(TotalInvoiceAmt; TotalInvoiceAmt)
                        // {
                        // }
                        // 21022025
                        // column(GlbFrtCharge; GlbFrtCharge)
                        // {
                        // }
                        // column(GlbInsCharge; GlbInsCharge)
                        // {
                        // }
                        // column(GlbPackCharge; GlbPackCharge)
                        // {
                        // }
                        // 21022025
                        column(LineDiscount; "Sales Invoice Line"."Line Discount Amount" / CalcAmountInUSD())
                        {
                        }
                        column(NumberText; numberText[1])
                        {
                        }
                        column(PackingSize; PackSize)
                        {
                        }
                        column(UnitNo; UnitNo)
                        {
                        }
                        // column(LotNo; ItemLedgerRec."Lot No.")
                        // {
                        // }
                        // 21022025
                        column(Qty; Qty)
                        {
                        }
                        column(saleslineNo; "Sales Invoice Line"."No.")
                        {
                        }
                        column(TotGST; TotGST)
                        {
                        }
                        // column(order_date; order_date)
                        // {
                        // }
                        // column(order_no; order_no)
                        // {
                        // }
                        // column(OrderCode; OrderNo)
                        // {
                        // }
                        // column(Forder; Final_orderNo)
                        // {
                        // }
                        column(StrOrderDate; StrOrderDate)
                        {
                        }
                        column(StrOrderNo; StrOrderNo)
                        {
                        }
                        // column(NewLotStr; NewLotStr)
                        // {
                        // }
                        // 21022025
                        column(MRPPrice_SalesInvoiceLine; recitem1."Unit Price") //09102025
                        {
                        }
                        /*  column(tcsbaseamt; "Sales Invoice Line"."TDS/TCS Base Amount")
                          {
                          } */ 
                        column(LineOtherDiscountAmount_SalesInvoiceLine; "Sales Invoice Line"."Line Discount Amount" / CalcAmountInUSD())
                        {
                        }//09102025
                        column(NoOfUnits_SalesInvoiceLine; "Sales Invoice Line"."Unit Cost")
                        {
                        } //09102025
                        column(Quantity_SalesInvoiceLine; "Sales Invoice Line".Quantity)
                        {
                        }
                        column(BatchCode; BatchCode)
                        {

                        }

                        trigger OnAfterGetRecord()
                        begin
                            QtyText := '';
                            packSize1 := '';

                            QtyText := FORMAT("Sales Invoice Line".Quantity);
                            //packSize1 := '1 * ' + ''+ "Sales Invoice Line".un;
                            /*
                            //recitem1.RESET;
                            recitem1.SETRANGE(recitem1."No.","Sales Invoice Line"."No.");
                            IF recitem1.FINDFIRST THEN
                               UnitNo:= recitem1."Block Tolerance Qty"
                            ELSE
                               UnitNo:= 0;
                            */

                            recitem1.Reset();
                            recitem1.SetRange("No.", "Sales Invoice Line"."No.");
                            if recitem1.FindFirst() then;

                            packSize1 := '1*' + '' + FORMAT(UnitNo);

                            IF "Sales Invoice Line".Type = "Sales Invoice Line".Type::"G/L Account" THEN BEGIN
                                IF "Sales Invoice Line"."No." = '433220' THEN BEGIN
                                    QtyText := '';
                                    packSize1 := '';
                                    amt4 := "Sales Invoice Line"."Unit Price";
                                    "Sales Invoice Line"."Unit Price" := 0;
                                    UnitNo := 0;
                                END;
                            END;


                            //PackSize:=recitem1."Pack Size";
                          
                            BatchCode := '';

                            ValueEntryRec.RESET;
                            ItemLedgerRec.RESET;
                            ValueEntryRec.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                            ValueEntryRec.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                            ValueEntryRec.SETRANGE("Document Type", ValueEntryRec."Document Type"::"Sales Invoice");
                            ValueEntryRec.SETRANGE("Item Ledger Entry Type", ValueEntryRec."Item Ledger Entry Type"::Sale);
                            ValueEntryRec.SetRange(Adjustment, false);
                            IF ValueEntryRec.FindSet() THEN
                                repeat
                                    IF ItemLedgerRec.GET(ValueEntryRec."Item Ledger Entry No.") THEN Begin
                                        BatchCode += ItemLedgerRec."Lot No." + ',';
                                    End;
                                until ValueEntryRec.next() = 0;
                            if BatchCode <> '' then
                                BatchCode := CopyStr(BatchCode, 1, StrLen(BatchCode) - 1);
                         


                            ValueEntryRec.RESET;
                            ItemLedgerRec.RESET;
                            ValueEntryRec.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                            ValueEntryRec.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                            ValueEntryRec.SETRANGE("Document Type", ValueEntryRec."Document Type"::"Sales Invoice");
                            ValueEntryRec.SETRANGE("Item Ledger Entry Type", ValueEntryRec."Item Ledger Entry Type"::Sale);
                            IF ValueEntryRec.FINDFIRST THEN BEGIN
                                IF ItemLedgerRec.GET(ValueEntryRec."Item Ledger Entry No.") THEN
                                    IF ItemLedgerRec."Lot No." <> '' THEN
                                        NosLines += 1;

                            END;

                           
                            //IF "Sales Invoice Line".Type <> "Sales Invoice Line".Type::" " THEN
                            IF "Sales Invoice Line"."No." <> '' THEN
                                "Sr.No" := "Sr.No" + 1;


                            if "Sr.No" > 1 then Begin 
                                // Clear(EwayDeatils1);
                                // CLear(RecEinvoice); //09102025
                                Clear(companyInfo);
                            end;

                          
                            //   CLEAR(TCSAmt);
                            // SalesInvLineRec1.RESET;
                            // SalesInvLineRec1.SETRANGE("Document No.", "Document No.");
                            // IF SalesInvLineRec1.FINDFIRST THEN BEGIN
                            //     REPEAT
                            //        TCSAmt += SalesInvLineRec1."TDS/TCS Amount";
                            //     UNTIL SalesInvLineRec1.NEXT = 0;
                            // END;
                           

                            SILGstAmount := 0;
                            SILGSTBaseAmount := 0;
                            GSTDetailLeger.RESET;
                            GSTDetailLeger.SETRANGE(GSTDetailLeger."Document No.", "Sales Invoice Line"."Document No.");
                            GSTDetailLeger.SETRANGE(GSTDetailLeger."Document Line No.", "Sales Invoice Line"."Line No.");
                            IF GSTDetailLeger.FINDSET THEN BEGIN
                                repeat
                                    SILGstAmount += GSTDetailLeger."GST Amount" / CalcAmountInUSD();

                                    SILGSTBaseAmount := GSTDetailLeger."GST Base Amount" / CalcAmountInUSD()

                                until GSTDetailLeger.Next() = 0
                            end;
                           


                         
                            GSTDetailLeger.RESET;
                            //GSTDetailLeger.SETFILTER("Document Type",'%1',GSTDetailLeger."Document Type"::Invoice);
                            //GSTDetailLeger.SETRANGE(GSTDetailLeger."Document Type",GSTDetailLeger."Document Type"::Invoice);
                            GSTDetailLeger.SETRANGE(GSTDetailLeger."Document No.", "Sales Invoice Line"."Document No.");
                            //GSTDetailLeger.SETRANGE(GSTDetailLeger."No.","Sales Invoice Line"."No.");
                            GSTDetailLeger.SETRANGE(GSTDetailLeger."Document Line No.", "Sales Invoice Line"."Line No.");
                            IF GSTDetailLeger.FINDSET THEN BEGIN
                                REPEAT
                                    IF GSTDetailLeger."GST Component Code" = 'CGST' THEN BEGIN
                                        CLEAR(rate1);
                                        CLEAR(amt1);
                                        rate1 := GSTDetailLeger."GST %";
                                        amt1 := GSTDetailLeger."GST Amount" / CalcAmountInUSD();
                                    END ELSE
                                        IF GSTDetailLeger."GST Component Code" = 'SGST' THEN BEGIN
                                            CLEAR(rate2);
                                            CLEAR(amt2);
                                            rate2 := GSTDetailLeger."GST %";
                                            amt2 := GSTDetailLeger."GST Amount" / CalcAmountInUSD();
                                        END ELSE
                                            IF GSTDetailLeger."GST Component Code" = 'IGST' THEN BEGIN
                                                CLEAR(rate3);
                                                CLEAR(amt3);
                                                rate3 := GSTDetailLeger."GST %";
                                                amt3 := GSTDetailLeger."GST Amount" / CalcAmountInUSD();

                                            END
                                            ELSE BEGIN
                                                CLEAR(rate1);
                                                CLEAR(amt1);
                                                CLEAR(rate2);
                                                CLEAR(amt2);
                                                CLEAR(rate3);
                                                CLEAR(amt3);
                                            END;
                                UNTIL GSTDetailLeger.NEXT = 0;
                            END ELSE BEGIN
                                CLEAR(rate1);
                                CLEAR(amt1);
                                CLEAR(rate2);
                                CLEAR(amt2);
                                CLEAR(rate3);
                                CLEAR(amt3);
                            END;



                            CLEAR(order_date);
                            //CLEAR( order_no);
                            OrderNo := '';
                            Rec_SaleShipHeader.RESET;
                            Rec_SaleShipHeader.SETRANGE(Rec_SaleShipHeader."No.", "Sales Invoice Line"."Shipment No.");
                            Rec_SaleShipHeader.SETFILTER(Rec_SaleShipHeader."Order No.", '<>%1', '');
                            // IF Rec_SaleShipHeader."Order No."<> '' THEN
                            IF Rec_SaleShipHeader.FIND('-') THEN
                                IF PrevDoc <> "Sales Invoice Line"."Shipment No." THEN
                                    REPEAT
                                        OrderNo := Rec_SaleShipHeader."Order No." + ',';
                                        OrderDate := Rec_SaleShipHeader."Order Date";
                                        //MESSAGE(OrderNo);
                                        PrevDoc := "Sales Invoice Line"."Shipment No.";
                                        // UNTIL Rec_SaleShipHeader.NEXT=0;
                                        //END //ELSE
                                        //IF OrderNo<>order_no THEN
                                        Rec_SaleShipHeader1.RESET;
                                        Rec_SaleShipHeader1.SETRANGE("No.", "Sales Invoice Line"."Shipment No.");
                                        Rec_SaleShipHeader1.SETFILTER("Order No.", '<>%1', '');
                                        IF Rec_SaleShipHeader1.FINDFIRST THEN
                                            //IF PrevDoc<> "Sales Invoice Line"."Shipment No." THEN
                                            REPEAT
                                                order_no := Rec_SaleShipHeader1."Order No." + ',';
                                                //PrevDoc:="Sales Invoice Line"."Shipment No.";
                                                Final_orderNo += (order_no);
                                                Final_OrderDate += FORMAT(OrderDate) + ',';
                                            //MESSAGE(Final_OrderDate);
                                            UNTIL Rec_SaleShipHeader1.NEXT = 0;
                                    UNTIL Rec_SaleShipHeader.NEXT = 0;

                            StrOrderDate := DELCHR(Final_OrderDate, '>', ',');
                            StrOrderNo := DELCHR(Final_orderNo, '>', ',');
                            //END;




                            //For Annexure 
                            CLEAR(rec_ILE_No);
                            CLEAR(rec_LOtno);

                            // ValueEntryRec.RESET;
                            // ItemLedgerRec.RESET;
                            // //IF ValueEntryRec."Document No." <> '' THEN REPEAT
                            // ValueEntryRec.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                            // ValueEntryRec.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                            // //ValueEntryRec.SETFILTER("Item Ledger Entry Quantity",'<%1',0);
                            // ValueEntryRec.SETFILTER(ValueEntryRec.Adjustment, '%1', FALSE);
                            // IF ValueEntryRec.FINDSET THEN
                            //     REPEAT
                            //         ItemLedgerRec.RESET;
                            //         //rec_ILE_No:= ValueEntryRec."Item Ledger Entry No.";
                            //         //ItemLedgerRec.SETRANGE("Entry No.",rec_ILE_No);
                            //         ItemLedgerRec.SETRANGE("Entry No.", ValueEntryRec."Item Ledger Entry No.");
                            //         IF ItemLedgerRec.FINDSET THEN
                            //             REPEAT
                            //                 //rec_LOtno+=ItemLedgerRec."Lot No." +','; 
                            //                 rec_LOtno1 := COPYSTR(ItemLedgerRec."Lot No." + '|' + rec_LOtno1, 1, 250);
                            //                                                                                            //NewLotStr:=DELCHR(rec_LOtno,'>',',');
                            //             UNTIL ItemLedgerRec.NEXT = 0;
                            //     UNTIL ValueEntryRec.NEXT = 0;
                            // //For Annexure 
                          

                        end;

                        trigger OnPreDataItem()
                        begin
                            //CLEAR(amt4);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := Text16502;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;


            
                    IF OutputNo = 1 THEN BEGIN
                        Title := Text1;
                        "Sr.No" := 0;
                        CLEAR(Final_OrderDate);
                        CLEAR(Final_orderNo);
                        GlbFrtCharge := 0;
                        GlbInsCharge := 0;
                        GlbPackCharge := 0;
                    END;

                    IF OutputNo = 2 THEN BEGIN
                        Title := Text2;
                        "Sr.No" := 0;
                        CLEAR(Final_OrderDate);
                        CLEAR(Final_orderNo);
                        GlbFrtCharge := 0;
                        GlbInsCharge := 0;
                        GlbPackCharge := 0;
                    END;

                    IF OutputNo = 3 THEN BEGIN
                        Title := Text3;
                        "Sr.No" := 0;
                        CLEAR(Final_OrderDate);
                        CLEAR(Final_orderNo);
                        GlbFrtCharge := 0;
                        GlbInsCharge := 0;
                        GlbPackCharge := 0;
                    END;
                    /*
                    IF OutputNo=4 THEN  BEGIN
                     Title:=Text4;
                     "Sr.No":=0;
                     GlbFrtCharge:=0;GlbInsCharge:=0;GlbPackCharge:=0;
                    END;
                    */

                end;

                trigger OnPostDataItem()
                begin
                    /*IF NOT CurrReport.PREVIEW THEN
                      SalesInvCountPrinted.RUN("Sales Invoice Header");
                      */

                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies);//;+ cust."Invoice Copies";
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                GSTLedEntry: Record "GST Ledger Entry"; 

                Vendor: Record Vendor;
            begin
               
                // Clear(GSTCompCode);
                // GSTLedEntry.Reset();
                // GSTLedEntry.Setrange("Document No.", "Sales Invoice Header"."No.");
                // GSTLedEntry.SetRange("GST Component Code", 'IGST');
                // if GSTLedEntry.FindSet() Then
                //     GSTCompCode := 'IGST'
                // else
                //     GSTCompCode := 'CGST';
             

            
                /*  if "Sr.No" = 0 then Begin
                     EwayDeatils1.Reset();
                     EwayDeatils1.SetLoadFields("Transaction Type", "Document No.", "E-Way Bill No.", "QR Code");
                     EwayDeatils1.SetRange("Transaction Type", EwayDeatils1."Transaction Type"::"Sales Invoice");
                     EwayDeatils1.SetRange("Document No.", "Sales Invoice Header"."No.");
                     EwayDeatils1.SetFilter("E-Way Bill No.", '<>%1', 0);
                     EwayDeatils1.SetAutoCalcFields("QR Code");
                     if EwayDeatils1.FindFirst() then;
                 End; */ //09102025
                        


                /*  Clear(EwayNo);
                 Clear(EWayBillDate);
                 Clear(EwayValidfrom);
                 Clear(EwayValidto);
                 Clear(EwayTransactionType);
                 Clear(EwayTransportername);
                 Clear(EwayTransportdocno);
                 ShowEwayDetails := false;
                 EwayDeatils.Reset();
                 EwayDeatils.SetLoadFields("Transaction Type", "Document No.", "E-Way Bill No.", "QR Code", "E-Way Bill Date", "E-Way Valid Upto");
                 EwayDeatils.SetRange("Transaction Type", EwayDeatils."Transaction Type"::"Sales Invoice");
                 EwayDeatils.SetRange("Document No.", "Sales Invoice Header"."No.");
                 EwayDeatils.SetFilter("E-Way Bill No.", '<>%1', 0);
                 EwayDeatils.SetAutoCalcFields("QR Code");
                 if EwayDeatils.FindFirst() Then Begin
                     ShowEwayDetails := true;
                     EwayNo := Format(EwayDeatils."E-Way Bill No.");
                     EWayBillDate := EwayDeatils."E-Way Bill Date";
                     EwayValidfrom := EwayDeatils."E-Way Bill Date";
                     EwayValidto := EwayDeatils."E-Way Valid Upto";
                     EwayTransactionType := "Sales Invoice Header"."Transport Method";
                     IF Vendor.GET("Sales Invoice Header".Transporter) THEN
                         //  IF Vendor."GST Registration No." <> '' THEN BEGIN
                         IF Vendor."GST Registration No." <> '' THEN
                             EwayTransportdocno := Vendor."GST Registration No."
                         ELSE
                             EwayTransportdocno := Vendor."Trans GST Registration No.";
                     EwayTransportername := "Sales Invoice Header"."LR/RR No." + ' - ' + Vendor.Name + Vendor."Name 2";
                 End; */ //09102025

              

                CLEAR(Custdiv);
                /*   IF custdivdes.GET("Sales Invoice Header"."Customer Type") THEN;
                  Custdiv := custdivdes.Description; */ //09102025

                recLocation.Reset();
                recLocation.SetRange(Code, "Sales Invoice Header"."Location Code");
                IF recLocation.FindFirst() then begin
                    EwayBy := recLocation."GST Registration No." + ' - ' + companyInfo.Name; 
                   
                    RecState.RESET;
                    RecState.SETRANGE(Code, recLocation."State Code");
                    IF RecState.FINDFIRST THEN BEGIN
                        Copm_stateCode := RecState."State Code (GST Reg. No.)";
                        Comp_state_description := RecState.Description;
                    END;
               
                end;

                //  "Sales Invoice Header".CALCFIELDS("Sales Invoice Header"."Amount to Customer");

                /*  RecCity.RESET;
                 RecCity.SETRANGE("Job Title Code", "Sales Invoice Header"."Sell-to City");
                 IF RecCity.FINDFIRST THEN
                     SelToTicyName := RecCity."Job Description";

                 RecCity.RESET;
                 RecCity.SETRANGE("Job Title Code", "Sales Invoice Header"."Ship-to City");
                 IF RecCity.FINDFIRST THEN
                     Shiptocityname := RecCity."Job Description"; */ //09102025

                /*   recLocation.RESET;
                  recLocation.SETRANGE(recLocation.Code, "Sales Invoice Header"."Location Code");
                  IF recLocation.FINDFIRST THEN BEGIN
                      RecCity.RESET;
                      RecCity.SETRANGE(RecCity."Job Title Code", recLocation.City);
                      IF RecCity.FINDFIRST THEN
                          CityName := RecCity."Job Description";
                  END; */ //09102025
                totQty := 0;
                recSIL.RESET;
                recSIL.SETRANGE("Document No.", "No.");
                recSIL.SETFILTER(recSIL."No.", '<>%1', '433220');
                IF recSIL.FINDFIRST THEN
                    REPEAT
                        totQty += recSIL.Quantity;
                    UNTIL recSIL.NEXT = 0;

                totQty := 0;
                recSIL.RESET;
                recSIL.SETRANGE("Document No.", "No.");
                recSIL.SETRANGE(recSIL.Type, recSIL.Type::Item);
                IF recSIL.FINDFIRST THEN BEGIN
                    REPEAT
                        totQty += recSIL.Quantity;
                    UNTIL recSIL.NEXT = 0;
                END;
                Fromcust.RESET;
                Fromcust.SETRANGE(Fromcust."No.", "Sales Invoice Header"."Sell-to Customer No.");
                IF Fromcust.FINDFIRST THEN BEGIN
                    From_Name := Fromcust.Name;
                    // From_Address := Fromcust.Address +' '+  Fromcust."Address 2" + ' ' +  Fromcust.City  + ' ' +  Fromcust."Post Code";
                    From_StateCode := Fromcust."State Code";
                    From_GSTIN := Fromcust."GST Registration No.";
                END;

                Shipaddress.RESET;
                Shipaddress.SETRANGE(Shipaddress."Customer No.", "Sales Invoice Header"."Sell-to Customer No.");
                IF Shipaddress.FINDFIRST THEN BEGIN
                    From_Address := Shipaddress.Address + ' ' + Shipaddress."Address 2";
                    From_Address1 := Shipaddress.City + ' ' + Shipaddress."Post Code";
                END;

                StateRec.RESET;
                StateRec.SETRANGE(StateRec.Code, From_StateCode);
                IF StateRec.FINDFIRST THEN
                    From_State := StateRec.Description;
                From_State_NO := StateRec."State Code (GST Reg. No.)";

                ToCust.RESET;
                ToCust.SETRANGE(ToCust."No.", "Sales Invoice Header"."Bill-to Customer No.");
                IF ToCust.FINDFIRST THEN BEGIN
                    To_Name := ToCust.Name;
                    To_Address := ToCust.Address + '  ' + ToCust."Address 2" + '  ' + ToCust.City + '  ' + ToCust."Post Code";
                    To_StateCode := ToCust."State Code";
                    To_GSTIN := ToCust."GST Registration No.";
                    //  TINNo := ToCust."T.I.N. No.";
                    CustContact := ToCust."Phone No.";
                    CusPANno := ToCust."P.A.N. No.";
                END;

                StateRec.RESET;
                StateRec.SETRANGE(StateRec.Code, To_StateCode);
                IF StateRec.FINDFIRST THEN
                    To_State := StateRec.Description;
                Cust_Sate_No := StateRec."State Code (GST Reg. No.)";



                RecLoc.RESET;
                RecLoc.SETRANGE(RecLoc.Code, "Sales Invoice Header"."Location Code");
                IF RecLoc.FINDFIRST THEN BEGIN
                    LocName := RecLoc.Name;
                    LocAddr := RecLoc.Address + ' ' + RecLoc."Address 2";
                    LocCity := RecLoc.City;
                    LocState := RecLoc."State Code";
                    LocGSTRegNo := RecLoc."GST Registration No.";
                    // LocTin := RecLoc."T.I.N. No.";
                    locGSTNo := RecLoc."GST Registration No.";
                    //FSS := RecLoc."FSSAI No."; //09102025

                END;

                StateRec.RESET;
                StateRec.SETRANGE(StateRec.Code, LocState);
                IF StateRec.FINDFIRST THEN BEGIN
                    LocStateDesc := StateRec.Description;
                    //  LocCode := StateRec."State Code for TIN";
                END;
                // StateRec1.RESET;
                // StateRec1.SETRANGE(StateRec1.Code, From_StateCode);
                // IF StateRec1.FINDFIRST THEN BEGIN
                //     //LocStateDesc:=StateRec.Description;
                //     //   LocCode1 := StateRec1."State Code for TIN";
                // END;
                // StateRec2.RESET;
                // StateRec2.SETRANGE(StateRec2.Code, To_StateCode);
                // IF StateRec2.FINDFIRST THEN BEGIN
                //     //LocStateDesc:=StateRec.Description;
                //     //  LocCode2 := StateRec2."State Code for TIN";
                // END;
               
                /*decAmount :=0;
                recSalesInvLine.RESET;
                recSalesInvLine.SETRANGE("Document No.","Document No.");
                IF recSalesInvLine.FIND('-') THEN
                  REPEAT
                    decAmount += recSalesInvLine.Amount;
                  UNTIL recSalesInvLine.NEXT=0;*/

                /*   TCSAmt := 0;
                  TCSEntry.Reset();
                  TCSEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
                  if TCSEntry.FindFirst() then
                      TCSEntry.CalcSums(TCSEntry."TCS Amount");
                  TCSAmt := TCSEntry."TCS Amount"; */ //09102025

                //IN0090.end
                AmountToCustomer := 0;
                CustLedEntryGST.Reset();
                CustLedEntryGST.SetRange("Document No.", "Sales Invoice Header"."No.");
                if CustLedEntryGST.FindFirst() then begin
                    CustLedEntryGST.CalcFields(Amount);
                    AmountToCustomer := CustLedEntryGST.Amount / CalcAmountInUSD();
                end;


                //  Check.InitTextVariable; //09102025
                //Check.FormatNoText(numberText,"Amount to Customer",''); //Commented 
                //Check.FormatNoText(numberText,decAmount,"Sales Invoice Header"."Currency Code"); //Commented 
                //Check.FormatNoText(numberText,ROUND("Sales Invoice Header"."Amount to Customer",1,'='),"Sales Invoice Header"."Currency Code");
                //09102025  //Check.FormatNoText(numberText, AmountToCustomer /*"Sales Invoice Header"."Amount to Customer"*/, "Sales Invoice Header"."Currency Code");
                //ReportCheck.InitTextVariable;
                //ReportCheck.FormatNoText(AmountInWord,"Sales Invoice Header"."Amount to Customer",' ');
                //For Dispatch Location 
                RecLoc.RESET;
                RecLoc.SETRANGE(Code, "Sales Invoice Header"."Location Code");
                IF RecLoc.FINDFIRST THEN BEGIN
                    Dispatch_Location := RecLoc.Name;
                    Loc_addr := RecLoc.Address;
                    Loc_addr_2 := RecLoc."Address 2";
                    City := RecLoc.City;
                    postcode := RecLoc."Post Code";
                    Phone_no := RecLoc."Phone No.";
                    GSTIN_NO_C := RecLoc."GST Registration No.";
                END;
                //For Dispatch Location 
                //For Round off Amnt To Cust 
                /*DecimalToRound:="Sales Invoice Header"."Amount to Customer";
                Direction:='=';
                Precision:=100;
                NewNumber:=ROUND(DecimalToRound,Precision,Direction);*/
                NewNumber := ROUND(/* "Sales Invoice Header"."Amount to Customer"*/ AmountToCustomer, 1, '>');
                //For Round off Amnt To cust 

                //    IF CURRENTCLIENTTYPE <> CLIENTTYPE::Web THEN BEGIN
                //QR++
                //    IF "Sales Invoice Header"."Acknowledgement No." <> '' THEN BEGIN

                /*  if "Sr.No" = 0 then begin 
                     RecEinvoice.RESET;
                     RecEinvoice.SETRANGE("Document No.", "No.");
                     RecEinvoice.SETRANGE("Inv Transaction", RecEinvoice."Inv Transaction"::"Generate IRN");
                     IF RecEinvoice.FindLast() THEN;
                     RecEinvoice.CALCFIELDS("QR Code Print");
                 end; */ //09102025


                // RecEinvoice.RESET;
                // RecEinvoice.SETRANGE("Document No.", "No.");

                // //RecEinvoice.SETRANGE("Inv Transaction",RecEinvoice."Inv Transaction"::"Generate IRN");
                // IF RecEinvoice.FindLast() THEN BEGIN

                //     IF RecEinvoice."Inv Transaction" = RecEinvoice."Inv Transaction"::"Generate IRN" THEN BEGIN
                //         RecEinvoice.CALCFIELDS("Signed QR Code");

                //        
                //         If RecEinvoice."Signed QR Code".Length < 1500 then begin

                //             IF RecEinvoice."Signed QR Code".HASVALUE THEN BEGIN
                //                 RecEinvoice."Signed QR Code".CREATEINSTREAM(Streamin);
                //                 Streamin.READTEXT(qrtest);
                //                 qrtest := DELCHR(qrtest, '=', '"');
                //                 QRCodeInput := qrtest;
                //                 QRCodeFileName := GetQRCode(QRCodeInput);
                //                   QRCodeFileName := MoveToMagicPath(QRCodeFileName);
                //                   CLEAR(TempBlobnew);

                //                 ThreeTierMgt.BLOBImport(TempBlobnew, QRCodeFileName);
                //                  QRCode.GenerateQRCodeImage(UpperCase(QRCodeInput), TempBlobnew);
                //                   IF RecEinvoice."Signed QR Code".HASVALUE THEN;


                //                 // Load the image from file into the BLOB field
                //                 CLEAR(TempBlobnew);
                //               BC230   FileManagement.BLOBImportFromServerFile(TempBlobnew, QRCodeFileName);

                //                 IF TempBlobnew.HasValue() THEN BEGIN
                //                     RecRef.GetTable(RecEinvoice);
                //                     FieldRef := RecRef.Field(RecEinvoice.FieldNo("QR Code Print"));
                //                     TempBlobnew.ToRecordRef(RecRef, RecEinvoice.FieldNo("QR Code Print"));
                //                     RecRef.Modify();

                //                 END;
                //                 RecEinvoice.CALCFIELDS("QR Code Print");

                //                  Erase the temporary file
                //                 IF NOT ISSERVICETIER THEN
                //                    IF EXISTS(QRCodeFileName) THEN
                //                      ERASE(QRCodeFileName);


                //             END;
                //         end; 
                //     END;
                // END;
                

            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                Qty := 0;
                CLEAR(order_no);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the value of the No. of Copies field.';
                        ApplicationArea = All;
                    }
                    field("USD Print"; USDPrint)
                    {
                        Caption = 'Print in USD';
                        ToolTip = 'Enable this option to enter a USD exchange rate.';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if USDPrint then
                                EnableUSDExchangeRate := true
                            else begin
                                EnableUSDExchangeRate := false;
                                USDExchangeRate := 0;
                            end;
                        end;
                    }
                    field("USD Exchange Rate"; USDExchangeRate)
                    {
                        ToolTip = 'Specifies the value of the USD Exchange Rate.';
                        Enabled = EnableUSDExchangeRate;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if USDPrint and (USDExchangeRate = 0) then
            Error('USD Exchange Rate must have a value when "Print in USD" is enabled.');

        companyInfo.GET();
        companyInfo.CALCFIELDS(Picture);
     
        /*  RecState.RESET;
          RecState.SETRANGE(Code, companyInfo."State Code");
          IF RecState.FINDFIRST THEN BEGIN
              Copm_stateCode := RecState."State Code (GST Reg. No.)";
              Comp_state_description := RecState.Description;
          END;*/
  

        "Sr.No" := 0;
    end;

    var
        SILGstAmount: Decimal; 
        SILGSTBaseAmount: Decimal; 
        AmountToCustomer: Decimal;
        CustLedEntryGST: Record "Cust. Ledger Entry"; 
        GSTDetailLeger: Record "Detailed GST Ledger Entry";
        rate1: Decimal;
        amt1: Decimal;
        rate2: Decimal;
        amt2: Decimal;
        rate3: Decimal;
        amt3: Decimal;
        "Sr.No": Integer;
        companyInfo: Record "Company Information";
        cust: Record "Customer";
        StateRec: Record "State";
        From_Name: Text[50];
        From_Address: Text;
        From_Address1: Text;
        From_StateCode: Code[20];
        From_State: Text;
        From_GSTIN: Code[20];
        To_Name: Text[50];
        To_Address: Text;
        To_StateCode: Code[20];
        To_State: Text;
        To_GSTIN: Code[20];
        Fromcust: Record "Customer";
        ToCust: Record "Customer";
        //  TotalInvoiceAmt: Decimal;
        // Check: Report "Posted Voucher"; //09102025
        // AmountInWord: array[2] of Text;
        //[SecurityFiltering(SecurityFilter::Ignored)]
        recSalesInvoiceLine: Record "Sales Invoice Line";
        // [SecurityFiltering(SecurityFilter::Ignored)]
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        // TotalInvoiceAmt1: Decimal;
        ChargesAmount: Decimal;
        GlbInsCharge: Decimal;
        GlbOtherCharge: Decimal;
        GlbFrtCharge: Decimal;
        //  StructureLineDetails: Record "Posted Str Order Line Details";
        //  ServTaxEntry_L: Record "Service Tax Entry";
        GlbPackCharge: Integer;
        RecLoc: Record "Location";
        LocName: Text;
        LocAddr: Text;
        LocState: Text;
        LocCity: Text;
        LocGSTRegNo: Text;
        LocStateDesc: Text;
        decAmount: Decimal;
        [SecurityFiltering(SecurityFilter::Ignored)]
        recSalesInvLine: Record "Sales Invoice Line";
        numberText: array[2] of Text[250];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        PageGroupNo: Integer;
        recItem: Record "Item";
        BatchNo: Text[10];
        PackSize: Text[10];
        ValueEntryRec: Record "Value Entry";
        ItemLedgerRec: Record "Item Ledger Entry";
        NosLines: Integer;
        LocTin: Code[20];
        recitem1: Record "Item";
        UnitNo: Integer;
        locGSTNo: Code[20];
        [SecurityFiltering(SecurityFilter::Ignored)]
        recSIL: Record "Sales Invoice Line";
        totQty: Decimal;
        LocCode: Code[20];
        StateRec1: Record "State";
        StateRec2: Record "State";
        LocCode1: Code[20];
        LocCode2: Code[20];
        [SecurityFiltering(SecurityFilter::Ignored)]
        recSIL1: Record "Sales Invoice Line";
        Qty: Decimal;
        amt4: Decimal;
        QtyText: Text;
        packSize1: Text;
        FSS: Code[50];
        TINNo: Code[20];
        // RecCity: Record "Job Title"; //09102025
        CityName: Text[50];
        recLocation: Record "Location";
        INVType: Text[100];
        SelToTicyName: Text[80];
        Shiptocityname: Text[80];
        TaxableValue: Decimal;
        TotalAmount: Decimal;
        TotGST: Decimal;
        Dispatch_Location: Text[50];
        Loc_addr: Text[50];
        Loc_addr_2: Text[50];
        City: Text[50];
        Phone_no: Text[30];
        postcode: Code[20];
        Comp_state_description: Text[50];
        Copm_stateCode: Code[20];
        State_description: Text;
        RecState: Record "State";
        Cust_Sate_No: Code[10];
        From_State_NO: Code[10];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        Title: Text[50];
        i: Integer;
        Text16502: Label 'COPY';
        Text1: Label 'ORIGINAL FOR RECIPIENT ';
        Text2: Label 'DUPLICATE FOR TRANSPORTER';
        Text3: Label 'TRIPLICATE FOR SUPPLIER';
        GSTIN_NO_C: Code[20];
        [SecurityFiltering(SecurityFilter::Ignored)]
        Rec_SaleShipHeader: Record "Sales Shipment Header";
        order_no: Text[250];
        order_date: Date;
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecSalesHeader: Record "Sales Header";
        NewNumber: Decimal;
        Precision: Decimal;
        //  Direction: Text;
        DecimalToRound: Decimal;
        PrevDoc: Code[20];
        [SecurityFiltering(SecurityFilter::Ignored)]
        RSIL: Record "Sales Invoice Line";
        OrderNo: Text;
        [SecurityFiltering(SecurityFilter::Ignored)]
        Rec_SaleShipHeader1: Record "Sales Shipment Header";
        Final_orderNo: Text;
        OrderDate: Date;
        Final_OrderDate: Text;
        StrOrderNo: Text;
        StrOrderDate: Text;
        CustContact: Code[50];
        Custdiv: Text[50];
        // custdivdes: Record "Customer Type Master"; //09102025
        rec_ILE_No: Integer;
        rec_LOtno: Code[250];
        //  NewLotStr: Text;
        rec_LOtno1: Code[250];
        TCSAmt: Decimal;
        [SecurityFiltering(SecurityFilter::Ignored)]
        SalesInvLineRec1: Record "Sales Invoice Line";
        //  RecEinvoice: Record "E-Invoice Log"; //09102025
        Streamin: InStream;
        qrtest: Text;
        QRBLOB: BigText;
        ThreeTierMgt: Codeunit "File Management";
        // TempBlob: Record "TempBlob";
        // QRCodeInput: Text;
        // QRCodeFileName: Text;
        web: Boolean;
        CusPANno: Code[10];
        [SecurityFiltering(SecurityFilter::Ignored)]
        Shipaddress: Record "Ship-to Address";
        SalesInvLine: Record "Sales Invoice Line";
        TotalInvoiceValue: Decimal;
        // tcsEntry: Record "TCS Entry"; //09102025
        // QRCode: Codeunit "QR Generator"; //09102025
        TempBlobnew: Codeunit "Temp Blob";
        //    TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxComponent: Record "Tax Component";
        TaxRateComputation: Codeunit "Tax Rate Computation";
       
        BatchCode: Text[100];
        //GSTCompCode: Text[5];
        EwayNo: Text[20];
        EwayBy: Text[150];
        EWayBillDate: DateTime;
        EwayValidfrom: DateTime;
        EwayValidto: DateTime;
        EwayTransactionType: Text[10];
        EwayReasonforTransport: Text[50];
        EwayTransportername: Text[100];
        EwayTransportdocno: Text[100];
        // EwayDeatils: Record "E-Way Billing Entry"; 
        // EwayDeatils1: Record "E-Way Billing Entry"; 
        ShowEwayDetails: Boolean;
        Rep322: Report "Aged Accounts Payable";
        USDRate: Decimal;
        USDExchangeRate: Decimal;
        USDPrint: Boolean;
        EnableUSDExchangeRate: Boolean;

    

    local procedure CalcAmountInUSD(): Decimal
    begin
        if USDPrint then
            USDRate := USDExchangeRate
        else
            USDRate := 1;

        exit(USDRate);
    end;

    local procedure GETGSTAmount()
    begin
      
        CLEAR(TotGST);
        CLEAR(rate3);
        CLEAR(amt3);
        GSTDetailLeger.RESET;
        //GSTDetailLeger.SETFILTER("Document Type",'%1',GSTDetailLeger."Document Type"::Invoice);
        //GSTDetailLeger.SETRANGE(GSTDetailLeger."Document Type",GSTDetailLeger."Document Type"::Invoice);
        GSTDetailLeger.SETRANGE(GSTDetailLeger."Document No.", "Sales Invoice Line"."Document No.");
        //GSTDetailLeger.SETRANGE(GSTDetailLeger."No.","Sales Invoice Line"."No.");
        GSTDetailLeger.SETRANGE(GSTDetailLeger."Document Line No.", "Sales Invoice Line"."Line No.");
        IF GSTDetailLeger.FINDSET THEN BEGIN
            REPEAT
                //CLEAR(amt3);
                IF GSTDetailLeger."GST Component Code" = 'CGST' THEN BEGIN
                    CLEAR(rate1);
                    CLEAR(amt1);
                    rate1 := GSTDetailLeger."GST %";
                    amt1 := GSTDetailLeger."GST Amount";
                END ELSE
                    IF GSTDetailLeger."GST Component Code" = 'SGST' THEN BEGIN
                        CLEAR(rate2);
                        CLEAR(amt2);
                        rate2 := GSTDetailLeger."GST %";
                        amt2 := GSTDetailLeger."GST Amount";
                    END ELSE
                        IF GSTDetailLeger."GST Component Code" = 'IGST' THEN BEGIN
                            //CLEAR(rate3);
                            //CLEAR(amt3);
                            rate3 := GSTDetailLeger."GST %";
                            amt3 := GSTDetailLeger."GST Amount";
                            TotGST += amt3;
                        END;
            UNTIL GSTDetailLeger.NEXT = 0;
        END ELSE BEGIN
            CLEAR(rate1);
            CLEAR(amt1);
            CLEAR(rate2);
            CLEAR(amt2);
            CLEAR(rate3);
            CLEAR(amt3);
        END;
    end;

    local procedure GETNONGSTAmount()
    begin
        CLEAR(rate1);
        CLEAR(amt1);
        rate1 := 0;
        amt1 := "Sales Invoice Line"."Line Amount";
    end;

    // procedure GetQRCode(QRCodeInput: Text[1024]) QRCodefileName: Text[1024];
    // var
    // IBarCodeProvider: DotNet IBarCodeProviderDV;
    // begin
    //     GetBarCodeProvider(IBarCodeProvider);
    //     QRCodefileName := IBarCodeProvider.GetBarcode(QRCodeInput);
    // end;
    

    /*   BC230 procedure GetBarCodeProvider(var IBarCodeProvider: DotNet IBarCodeProviderDV);
     var
         QBarCodeProvider: DotNet QRCodeProviderDV;
     begin
         // BC230 QBarCodeProvider := QBarCodeProvider.QRCodeProvider;
         // BC230 IBarCodeProvider := QBarCodeProvider;
     end;*/

    // procedure MoveToMagicPath(SourceFileName: Text[1024]) DestinationFileName: Text[1024];
    // var
    // //FileSystemObject: Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{0D43FE01-F093-11CF-8940-00A0C9054228}:'Windows Script Host Object Model'.FileSystemObject";
    // begin
    //     // BC230  DestinationFileName := FileManagement.ClientTempFileName('');

    //     //IF ISCLEAR(FileSystemObject) THEN
    //     //File.CREATE(FileSystemObject, TRUE, TRUE);
    //     //FileSystemObject.MoveFile(SourceFileName, DestinationFileName);
    //     // BC230  File.Copy(SourceFileName, DestinationFileName)
    // end;
    


    // local procedure CreateQRCodeInput1(Line: Code[10]; TMLPONo: Code[20]) QRCodeInput: Text
    // begin
    //     QRCodeInput := TMLPONo + Line;
    // end;
    
}

