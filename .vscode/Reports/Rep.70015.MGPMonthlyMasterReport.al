table 58040 "Cons Billing Entries Report"
{
    Caption = 'Consignment Billing Entries';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Sales Entries Line No."; Integer)
        {
            Caption = 'Sales Entries Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Billing Type"; Option)
        {
            Caption = 'Billing Type';
            DataClassification = ToBeClassified;
            OptionMembers = "Sales","Purchase";
            OptionCaption = 'Sales,Purchase';
        }
        field(5; "Store No."; Code[20])
        {
            Caption = 'Store No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
        }
        field(7; "Product Group"; Code[20])
        {
            Caption = 'Product Group';
            DataClassification = ToBeClassified;
        }
        field(8; "Special Group"; Code[20])
        {
            Caption = 'Special Group';
            DataClassification = ToBeClassified;
        }
        field(9; "Consignment %"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Caption = 'Profit Margin %';
            DataClassification = ToBeClassified;
        }
        field(10; "VAT Code"; Code[20])
        {
            Caption = 'VAT Code';
            DataClassification = ToBeClassified;
        }
        field(11; "Total Excl Tax"; Decimal)
        {
            Caption = 'Total Excl Tax';
            DataClassification = ToBeClassified;
        }
        field(12; "Total Incl Tax"; Decimal)
        {
            Caption = 'Total Incl Tax';
            DataClassification = ToBeClassified;
        }
        field(13; "Total Tax"; Decimal)
        {
            Caption = 'Total Tax';
            DataClassification = ToBeClassified;
        }
        field(14; Cost; Decimal)
        {
            Caption = 'Cost';
            DataClassification = ToBeClassified;
        }
        field(15; Profit; Decimal)
        {
            Caption = 'Profit';
            DataClassification = ToBeClassified;
        }
        field(16; "Product Group Description"; Text[100])
        {
            Caption = 'Product Group Description';
            FieldClass = FlowField;
            CalcFormula = lookup("LSC Retail Product Group".Description where(Code = field("Product Group")));
            Editable = false;
        }
        field(17; "Special Group Description"; text[30])
        {
            Caption = 'Special Group Description';
            DataClassification = ToBeClassified;
        }
        field(18; "Special Group 2"; Code[20])
        {
            Caption = 'Special Group 2 (Prefix C)';
            DataClassification = ToBeClassified;
        }
        field(19; "Special Group 2 Description"; text[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("LSC Item Special Groups".Description where("Code" = field("Special Group 2")));
            Editable = false;
        }
        field(20; "Sales Date"; Date)
        {
            Caption = 'Sales Date';
            DataClassification = ToBeClassified;
        }
        field(21; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(22; "Cost Incl Tax"; Decimal)
        {
            Caption = 'Cost Incl Tax'; //UAT-025 Add Cost WITH TAX
        }
        field(23; "Contract ID"; Text[30])
        {
            Caption = 'Contract ID';
        }
        field(50100; "MDR Rate"; Decimal) { DecimalPlaces = 0 : 3; }
        field(50101; "MDR Weight"; Decimal) { DecimalPlaces = 0 : 3; }
        field(50102; "MDR Amount"; Decimal) { }
        field(50103; "Expected Gross Profit"; Decimal) { DecimalPlaces = 0 : 3; }
        field(50104; "Area"; Decimal) { DecimalPlaces = 0 : 3; }
        field(50105; "Division"; Text[100]) { }
        field(50106; "Vendor Name."; Code[100])
        {
            Caption = 'Vendor Name.';
            DataClassification = ToBeClassified;
        }
        field(50107; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "Open","Released","Posted";
            OptionCaption = 'Open,Released,Posted';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50108; "Document No."; Code[100])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(50109; "GPMAmount"; decimal)
        {
            Caption = 'GPMAmount';
            DataClassification = ToBeClassified;
        }
        field(50110; "StatusTemp"; Text[50])
        {
            Caption = 'StatusTemp';
            DataClassification = ToBeClassified;
        }
        field(50111; "TransNo"; Integer)
        {
            Caption = 'TransNo';
            DataClassification = ToBeClassified;
        }
        field(50112; "ItemNo"; Text[100])
        {
            Caption = 'ItemNo';
            DataClassification = ToBeClassified;
        }
        field(50113; "Ratio"; Decimal)
        {
            Caption = 'Ratio';
            DataClassification = ToBeClassified;
        }
        field(50114; "ContractName"; Text[100])
        {
            Caption = 'Ratio';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "line no.")
        {
            Clustered = true;
        }
    }
}

report 70015 "MGP Monthly Master Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70015.MGPMonthlyMasterReport.rdl';


    ApplicationArea = All;
    Caption = 'Monthly Report For Expected Profit';
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

            column(StartDate; "StartDate")
            {

            }

            column(EndDate; "EndDate")
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

            column("GPMAmount"; "GPMAmount")
            {

            }

            column("headerlb"; "headerlb")
            {

            }

            column("StatusTemp"; "StatusTemp")
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

                    field("Date"; DateFilter)
                    {
                        trigger OnValidate()
                        begin
                            ApplicationManagement.MakeDateFilter(DateFilter);
                        end;
                    }
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
                    field("Division"; DivisionFilter)
                    {
                        TableRelation = "LSC Division"."Code";
                    }
                    field("Class"; ProductGroupFilter)
                    {
                        TableRelation = "LSC Retail Product Group"."Code";
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
        ConsContract: Record "WP Consignment Contracts";
        nextlineno: Integer;

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
                        // be.Setrange("Product Group", ce."Product Group");
                        // be.setrange("Special Group", ce."Special Group");
                        // be.setrange("Special Group 2", ce."Special Group 2");
                        // be.setrange("TransNo", ce."Transaction No.");
                        // be.setrange("Consignment %", ce."Consignment %");
                        // be.setrange("VAT Code", ce."VAT Code");
                        be.setrange("Contract ID", ce."Contract ID");
                        if not be.FindFirst() then begin

                            //do insert
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

                            headerlb := 'MONTHLY REPORT FOR EXPECTED PROFIT IN ' + FORMAT(EndDate, 0, '<Month Text>').ToUpper() + '.' + FORMAT(EndDate, 0, '<Year4>');

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

                            be.Ratio := (be.Profit / be."Total Excl Tax") * 100;

                            CountGMP := be."Expected Gross Profit" - be.Profit;
                            if CountGMP > 0 then begin
                                be.GPMAmount := round(CountGMP);
                                be.StatusTemp := 'Yes';
                            end else begin
                                be.GPMAmount := 0;
                                be.StatusTemp := 'No';
                            end;

                            be."Product Group Description" := ce."Product Group Description";
                            be."MDR Amount" := ce."MDR Amount";
                            be."MDR Rate" := ce."MDR Rate";
                            be."MDR Weight" := ce."MDR Weight";
                            be."Sales Date" := ce.Date;
                            be.Quantity := ce.Quantity;
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
                            if be."Total Excl Tax" <> 0 then begin
                                be.Ratio := (be.Profit / be."Total Excl Tax") * 100;
                            end else
                                be.Ratio := 0;

                            CountGMP := be."Expected Gross Profit" - be.Profit;
                            if CountGMP > 0 then begin
                                be.GPMAmount := round(CountGMP);
                                be.StatusTemp := 'Yes';
                            end else begin
                                be.GPMAmount := 0;
                                be.StatusTemp := 'No';
                            end;

                            be."MDR Amount" += ce."MDR Amount";
                            be.Quantity += ce.Quantity;
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

                        be."Contract ID" := CEHeader."Contract ID";

                        Clear(ConsContract);
                        ConsContract.SetRange(ID, CEHeader."Contract ID");
                        if ConsContract.FindSet() then
                            be.ContractName := ConsContract.Description;

                        //Get Expected Gross Profit again: maximun value
                        Clear(RecMPG);
                        RecMPG.SETCURRENTKEY("Expected Gross Profit");
                        RecMPG.SetRange("Vendor No.", CEHeader."Vendor No.");
                        RecMPG.SetRange("Contract ID", CEHeader."Contract ID");
                        if RecMPG.FindLast() then
                            be."Expected Gross Profit" := RecMPG."Expected Gross Profit"
                        else
                            be."Expected Gross Profit" := ce."Expected Gross Profit";

                        headerlb := 'MONTHLY REPORT FOR EXPECTED PROFIT IN ' + FORMAT(EndDate, 0, '<Month Text>').ToUpper() + '.' + FORMAT(EndDate, 0, '<Year4>');

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
            until CEHeader.next = 0;
        end;
    end;

    var
        DocumentNoFilter: Text;
        DivisionFilter: Text;
        ProductGroupFilter: Text;

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
        CountGMP: Decimal;
        StartDate: Date;
        EndDate: Date;
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
        headerlb: Text[100];
        Memo1Filter: enum "Payment Type";
        PaymentDate: Date;
        TotalingPeriod: Text[100];
        FromDate: Date;
        ToDate: Date;
        ApplicationManagement: Codeunit "Filter Tokens";

        DateFilter: Text;

}

