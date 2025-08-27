
report 70013 "MGP Monthly Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70013.MGPMonthlyReport.rdl';


    ApplicationArea = All;
    Caption = 'MGP Monthly Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("ConsignmentBilling"; "Cons Billing Entries Report")
        {
            DataItemTableView = SORTING("Line No.");
            // RequestFilterFields = "Document No.", "Vendor No.", "Product Group";

            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Contract_ID; "Contract ID")
            {

            }
            column(VendorNo; "Vendor No.")
            {

            }
            column(VendorName; "Vendor Name.")
            {

            }
            column(ProductGroupDescription; "Product Group Description")
            {

            }

            column(TotalExclTax; "Total Excl Tax")
            {

            }
            column(Profit; "Profit")
            {

            }
            column(TransNo; "TransNo")
            {

            }

            column(Month; "Month")
            {

            }
            column(Cost; "Cost")
            {

            }
            column(Division; "Division")
            {

            }
            column("Area"; "Area")
            {

            }

            column("ProfitMargin"; "Consignment %")
            {

            }

            column("ExpectedGrossProfit"; "Expected Gross Profit")
            {

            }

            column("Status"; "Status")
            {

            }

            column("SpecialGroupDescription"; "Special Group Description")
            {

            }
            column("ItemNo"; "ItemNo")
            {

            }


            column("Ratio"; "Ratio")
            {

            }

            column("ContractName"; "ContractName")
            {

            }

            trigger OnAfterGetRecord()
            begin

            end;


            trigger OnPreDataItem()
            begin
                CreateBillingEntries();

                if StatusFilter <> 0 then begin
                    Clear(ConsignmentBilling);
                    case StatusFilter of
                        StatusFilter::Yes:
                            ConsignmentBilling.SETFILTER("StatusTemp", 'Yes');
                        StatusFilter::No:
                            ConsignmentBilling.SETFILTER("StatusTemp", 'No');
                    end;
                end;
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    // field(Memo1Filter; Memo1Filter)
                    // {
                    //     ApplicationArea = Basic;
                    //     Caption = 'Memo 1 Filter';

                    // }
                    // field(PaymentDate; PaymentDate)
                    // {
                    //     ApplicationArea = Basic;
                    //     Caption = 'Payment Date';
                    //     NotBlank = true;
                    //     trigger OnValidate()
                    //     var
                    //         lRec_DateMaster: record "Date Master";
                    //     begin
                    //         TotalingPeriod := '';
                    //         FromDate := 0D;
                    //         ToDate := 0D;

                    //         lRec_DateMaster.RESET;
                    //         lRec_DateMaster.SETRANGE("Payment Type", Memo1Filter);
                    //         lRec_DateMaster.SETRANGE("Payment Date", PaymentDate);
                    //         lRec_DateMaster.FindLast();
                    //         ToDate := lRec_DateMaster."Closing Date";
                    //         lRec_DateMaster.RESET;
                    //         lRec_DateMaster.SETRANGE("Payment Type", Memo1Filter);
                    //         lRec_DateMaster.SETFilter("Payment Date", '<%1', PaymentDate);
                    //         lRec_DateMaster.FindLast();
                    //         FromDate := lRec_DateMaster."Closing Date" + 1;

                    //         TotalingPeriod := FORMAT(FromDate) + '..' + FORMAT(ToDate);

                    //     end;

                    // }
                    // field(TotalingPeriod; TotalingPeriod)
                    // {
                    //     ApplicationArea = Basic;
                    //     Caption = 'Totaling Period';
                    //     Editable = false;
                    // }

                    field("Date"; DateFilter)
                    {
                        trigger OnValidate()
                        begin
                            ApplicationManagement.MakeDateFilter(DateFilter);
                        end;
                    }
                    field("Division"; DivisionFilter)
                    {
                        TableRelation = "LSC Division"."Code";
                    }
                    field("Class"; ProductGroupFilter)
                    {
                        TableRelation = "LSC Retail Product Group"."Code";
                    }
                    field("Status MGP"; StatusFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = '';
                    }

                }
            }
        }
    }

    labels
    {

    }

    procedure CreateBillingEntries()
    var
        CEHeader: Record "Consignment Header";
        CE: Record "Consignment Entries";
        BE: Record "Cons Billing Entries Report";
        BE2: Record "Cons Billing Entries Report";
        nextlineno: Integer;
        ConsContract: Record "WP Consignment Contracts";
        StartDate: Date;
        EndDate: Date;
        LRecVendor: Record "Vendor";
        memoFilter: Text;

        Window: Dialog;
        TotalTrans: Integer;
        Counter: Integer;
    begin
        clear(be);
        be.DeleteAll();

        IF (DateFilter = '') THEN
            ERROR('The report couldn’t be generated, because it was empty. Input data for the Period field.');

        ParseDateRange(DateFilter, StartDate, EndDate);

        Window.Open(
              'Number of Transactions #1###########\' +
              'Processed              #2###########');

        Clear(CEHeader);
        CEHeader.SetRange("Status", CEHeader.Status::Posted);
        CEHeader.SetFilter("Start Date", '>=%1', StartDate);
        CEHeader.SetFilter("End Date", '<=%1', EndDate);
        if CEHeader.FindSet() then begin
            repeat
                // //Check Memo
                // clear(lrecvendor);
                // if LRecVendor.get(ce."Vendor No.") then begin
                //     IF (Memo1Filter = Memo1Filter::"1.One Time") then
                //         memoFilter := '1';
                //     IF (Memo1Filter = Memo1Filter::"2.Two Times") then
                //         memoFilter := '2';
                // end;

                if lrecvendor."Memo 1" = memoFilter then begin
                    clear(ce);
                    ce.SetRange("Document No.", CEHeader."Document No.");
                    ce.SetRange("Billing Period ID", CEHeader."Billing Period ID");
                    if ProductGroupFilter <> '' then ce.SetRange("Product Group", ProductGroupFilter);
                    if DivisionFilter <> '' then ce.SetRange("Division", DivisionFilter);
                    Window.Update(1, ce.Count);
                    Counter := 0;
                    if ce.FindSet() then begin
                        repeat
                            Counter += 1;
                            if (Counter mod 100) = 0 then
                                Window.Update(2, Counter);

                            cleaR(be);
                            be.setrange("Store No.", ce."Store No.");
                            be.SetRange("Vendor No.", ce."Vendor No.");
                            be.Setrange("Product Group", ce."Product Group");
                            be.setrange("Special Group", ce."Special Group");
                            be.setrange("Special Group 2", ce."Special Group 2");
                            be.setrange("ItemNo", ce."Item No.");
                            be.setrange("Consignment %", ce."Consignment %");
                            be.setrange("VAT Code", ce."VAT Code");
                            be.setrange("Contract ID", ce."Contract ID");

                            if (not be.FindFirst()) or (ce."Consignment Amount" < 0) then begin
                                clear(be2);
                                if be2.FindLast() then
                                    nextlineno := be2."Line No." + 100
                                else
                                    nextlineno := 100;

                                Clear(ConsContract);
                                ConsContract.SetRange(ID, ce."Contract ID");
                                if ConsContract.FindSet() then
                                    be.ContractName := ConsContract.Description;

                                be."Contract ID" := ce."Contract ID";

                                //Get Expected Gross Profit again: maximun value
                                Clear(RecMPG);
                                RecMPG.SETCURRENTKEY("Expected Gross Profit");
                                RecMPG.SetRange("Vendor No.", CEHeader."Vendor No.");
                                RecMPG.SetRange("Contract ID", CEHeader."Contract ID");
                                if RecMPG.FindLast() then
                                    be."Expected Gross Profit" := RecMPG."Expected Gross Profit"
                                else
                                    be."Expected Gross Profit" := ce."Expected Gross Profit";

                                Clear(RecPeriods);
                                RecPeriods.SetRange("ID", ce."Billing Period ID");
                                if RecPeriods.FindFirst() then
                                    Month := RecPeriods."End Date";

                                Clear(RecAre);
                                RecAre.SetRange("Store No.", ce."Store No.");
                                RecAre.SetRange("Vendor No.", ce."Vendor No.");
                                RecAre.SetRange("Contract ID", CEHeader."Contract ID");
                                if RecAre.FindFirst() then
                                    be."Area" := RecAre."Area";

                                Clear(RecVendor);
                                RecVendor.SetRange("No.", ce."Vendor No.");
                                if RecVendor.FindFirst() then
                                    be."Vendor Name." := RecVendor."Name";

                                Clear(RecSpecialGroupItem);
                                RecSpecialGroupItem.SetRange("Code", ce."Special Group");
                                if RecSpecialGroupItem.FindFirst() then
                                    be."Special Group Description" := RecSpecialGroupItem."Description";

                                be."Line No." := nextlineno;
                                be."ItemNo" := ce."Item No.";
                                be."Billing Type" := be."Billing Type"::Sales;
                                be."Store No." := ce."Store No.";
                                be."Vendor No." := ce."Vendor No.";
                                be."Product Group" := ce."Product Group";
                                be."Special Group" := ce."Special Group";
                                be."Special Group 2" := ce."Special Group 2";
                                be."Consignment %" := ce."Consignment %";
                                be."VAT Code" := ce."VAT Code";
                                be."Total Excl Tax" := ce."Total Excl Tax";
                                be."Cost Incl Tax" := ce."Cost Incl Tax";
                                be."Total Incl Tax" := ce."Total Incl Tax";

                                be."Total Tax" := be."Total Incl Tax" - be."Total Excl Tax";
                                //Get data
                                be.Profit := CE."Consignment Amount";// - 'Profit Excl Tax'
                                be.Cost := CE."Cost";// - 'Profit Excl Tax'
                                                     // be.Profit := round(be."Total Excl Tax" * (be."Consignment %" * 0.01));
                                                     // be.Cost := round(be."Total Excl Tax" - be.Profit);
                                if be."Profit" <> 0 then begin
                                    be.Ratio := (be.Cost / ABS(be."Profit")) * 10;
                                end else begin
                                    be.Ratio := 0;
                                end;

                                be."Product Group Description" := ce."Product Group Description";
                                be."MDR Amount" := ce."MDR Amount";
                                be."MDR Rate" := ce."MDR Rate";
                                be."MDR Weight" := ce."MDR Weight";
                                be."Sales Date" := ce.Date;
                                be.Quantity := ce.Quantity;

                                CountGMP := be."Expected Gross Profit" - be.Profit;
                                if CountGMP > 0 then begin
                                    be.GPMAmount := round(CountGMP);
                                    be.StatusTemp := 'Yes';
                                end else begin
                                    be.GPMAmount := 0;
                                    be.StatusTemp := 'No';
                                end;

                                be.insert(true);
                            end else begin
                                //do modify
                                be."Total Excl Tax" += ce."Total Excl Tax";
                                be."Total Incl Tax" += ce."Total Incl Tax";
                                be."Cost Incl Tax" += ce."Cost Incl Tax"; //uat-025

                                be."Total Tax" := be."Total Incl Tax" - be."Total Excl Tax";
                                be.Profit += CE."Consignment Amount";// - 'Profit Excl Tax'
                                be.Cost += CE."Cost";// - 'Profit Excl Tax'
                                                     // be.Profit := Round(be."Total Excl Tax" * (be."Consignment %" * 0.01));
                                                     // be.Cost := Round(be."Total Excl Tax" - be.Profit);

                                if be."Total Excl Tax" <> 0 then
                                    be.Ratio := (be.Profit / be."Total Excl Tax") * 100
                                else
                                    be.Ratio := 0;

                                be."MDR Amount" += ce."MDR Amount";
                                be.Quantity += ce.Quantity;

                                CountGMP := be."Expected Gross Profit" - be.Profit;
                                if CountGMP > 0 then begin
                                    be.GPMAmount := round(CountGMP);
                                    be.StatusTemp := 'Yes';
                                end else begin
                                    be.GPMAmount := 0;
                                    be.StatusTemp := 'No';
                                end;

                                be.modify(true);
                            end;

                        until ce.next = 0;
                    end else begin

                        cleaR(be);

                        be.setrange("Store No.", ce."Store No.");
                        be.SetRange("Vendor No.", CEHeader."Vendor No.");
                        be.Setrange("Product Group", ce."Product Group");
                        be.setrange("Special Group", ce."Special Group");
                        be.setrange("Special Group 2", ce."Special Group 2");
                        be.setrange("ItemNo", ce."Item No.");
                        be.setrange("Consignment %", ce."Consignment %");
                        be.setrange("VAT Code", ce."VAT Code");
                        be.setrange("Contract ID", CEHeader."Contract ID");
                        if not be.FindFirst() then begin

                            clear(be2);
                            if be2.FindLast() then
                                nextlineno := be2."Line No." + 100
                            else
                                nextlineno := 100;

                            Clear(ConsContract);
                            ConsContract.SetRange(ID, CEHeader."Contract ID");
                            if ConsContract.FindSet() then
                                be.ContractName := ConsContract.Description;

                            be."Contract ID" := CEHeader."Contract ID";

                            Clear(RecMPG);
                            RecMPG.SETCURRENTKEY("Expected Gross Profit");
                            RecMPG.SetRange("Vendor No.", CEHeader."Vendor No.");
                            RecMPG.SetRange("Contract ID", CEHeader."Contract ID");
                            if RecMPG.FindLast() then
                                be."Expected Gross Profit" := RecMPG."Expected Gross Profit"
                            else
                                be."Expected Gross Profit" := ce."Expected Gross Profit";

                            Clear(RecPeriods);
                            RecPeriods.SetRange("ID", CEHeader."Billing Period ID");
                            if RecPeriods.FindFirst() then begin
                                Month := RecPeriods."End Date";
                            end;

                            Clear(RecAre);
                            RecAre.SetRange("Vendor No.", CEHeader."Vendor No.");
                            RecAre.SetRange("Contract ID", CEHeader."Contract ID");
                            if RecAre.FindFirst() then
                                be."Area" := RecAre."Area";

                            Clear(RecVendor);
                            RecVendor.SetRange("No.", CEHeader."Vendor No.");
                            if RecVendor.FindFirst() then
                                be."Vendor Name." := RecVendor."Name";

                            be."Line No." := nextlineno;
                            be."Special Group Description" := '';
                            be."Billing Type" := be."Billing Type"::Sales;
                            be."Store No." := '';
                            be."Vendor No." := CEHeader."Vendor No.";
                            be."Product Group" := '';
                            be."Special Group" := '';
                            be."Special Group 2" := '';
                            be."Consignment %" := 0;
                            be."VAT Code" := '';
                            be."Total Excl Tax" := 0;
                            be."Cost Incl Tax" := 0;
                            be."Total Incl Tax" := 0;

                            be."Total Tax" := be."Total Incl Tax" - be."Total Excl Tax";
                            //Get data
                            be.Profit := 0;// - 'Profit Excl Tax'
                            be.Cost := 0;// - 'Profit Excl Tax'
                                         // be.Profit := round(be."Total Excl Tax" * (be."Consignment %" * 0.01));
                                         // be.Cost := round(be."Total Excl Tax" - be.Profit);

                            be.Ratio := 0;


                            CountGMP := be."Expected Gross Profit" - be.Profit;
                            if CountGMP > 0 then begin
                                be.GPMAmount := round(CountGMP);
                                be.StatusTemp := 'Yes';
                            end else begin
                                be.GPMAmount := 0;
                                be.StatusTemp := 'No';
                            end;

                            be."Product Group Description" := '';
                            be."MDR Amount" := 0;
                            be."MDR Rate" := 0;
                            be."MDR Weight" := 0;
                            be."Sales Date" := ce.Date;
                            be.Quantity := 0;
                            be.insert(true);
                        end;
                    end;
                end;
            until CEHeader.next = 0;
        end;

    end;

    procedure ParseDateRange(DateRange: Text; var StartDate: Date; var EndDate: Date)
    var
        StartStr: Text[20];
        EndStr: Text[20];
        SeparatorPos: Integer;
    begin
        // Tìm vị trí dấu ".."
        SeparatorPos := StrPos(DateRange, '..');
        if SeparatorPos > 0 then begin
            StartStr := CopyStr(DateRange, 1, SeparatorPos - 1);
            EndStr := CopyStr(DateRange, SeparatorPos + 2);

            // Chuyển đổi chuỗi thành ngày
            Evaluate(StartDate, StartStr);
            Evaluate(EndDate, EndStr);
        end else
            Error('Định dạng không hợp lệ. Phải có dạng dd/MM/yy..dd/MM/yy');
    end;


    var
        DocumentNoFilter: Text;
        DivisionFilter: Text;
        ProductGroupFilter: Text;

    var
        CountGMP: Decimal;
        Month: Date;
        RecPeriods: Record "WP B.Inc Billing Periods";
        RecSpecialGroup: Record "LSC Item/Special Group Link";
        RecSpecialGroupItem: Record "LSC Item Special Groups";
        RecAre: Record "WP Counter Area";
        RecMPG: Record "WP MPG Setup";
        RecConsMS: Record "WP Consignment Margin Setup";
        ConsignmentDoc: Record "Consignment Header";
        RecConsEntri: Record "Consignment Entries";
        RecDivision: Record "LSC Division";
        RecContract: Record "WP Consignment Contracts";
        RecVendor: Record "Vendor";
        ContractIDTemp: Text[40];
        POS_Terminal_SalesCaptionLbl: Label 'POS Terminal Sales';

        Memo1Filter: enum "Payment Type";
        PaymentDate: Date;
        TotalingPeriod: Text[100];
        FromDate: Date;
        ToDate: Date;
        DateFilter: Text;
        ApplicationManagement: Codeunit "Filter Tokens";
        StatusFilter: Option " ",Yes,No;

}

