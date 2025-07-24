table 58044 "HourlySaleReport"
{
    Access = Internal;
    Caption = 'Hourly Sale Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Store"; Text[100])
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Division"; Text[100])
        {
            Caption = 'Division';
            DataClassification = ToBeClassified;
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Customer"; Integer)
        {
            Caption = 'Customer';
            DataClassification = ToBeClassified;
        }
        field(6; "Sale"; Decimal)
        {
            Caption = 'Customer';
            DataClassification = ToBeClassified;
        }
        field(7; "Budget"; Decimal)
        {
            Caption = 'Customer';
            DataClassification = ToBeClassified;
        }
        field(8; "Time"; Time)
        {
            Caption = 'Time';
            DataClassification = ToBeClassified;
        }
        field(9; "No. of Items"; Decimal)
        {
            Caption = 'No. of Items';
            DataClassification = ToBeClassified;
        }
        field(10; "Sales Transactions"; Decimal)
        {
            Caption = 'Sales Transactions';
            DataClassification = ToBeClassified;
        }
        field(11; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            DataClassification = ToBeClassified;
        }
        field(12; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            DataClassification = ToBeClassified;
        }
        field(13; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Store,Staff,POS';
            OptionMembers = Store,Staff,POS;
            DataClassification = CustomerContent;
        }
        field(14; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
            DataClassification = ToBeClassified;
        }
        field(15; "SaleToDay"; Decimal)
        {
            Caption = 'SaleToDay';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; Type, "Store", Time, Division)
        {
        }
    }
    // keys
    // {
    //     key(PK; "line no.")
    //     {
    //         Clustered = true;
    //     }
    // }
}

table 58045 "HourlySaleMatrixReport"
{
    Access = Internal;
    Caption = 'Hourly Sale Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Store"; Text[100])
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Division"; Text[100])
        {
            Caption = 'Division';
            DataClassification = ToBeClassified;
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Customer"; Integer)
        {
            Caption = 'Customer';
            DataClassification = ToBeClassified;
        }
        field(6; "Sale"; Decimal)
        {
            Caption = 'Customer';
            DataClassification = ToBeClassified;
        }
        field(7; "Budget"; Decimal)
        {
            Caption = 'Customer';
            DataClassification = ToBeClassified;
        }

        field(9; "No. of Items"; Decimal)
        {
            Caption = 'No. of Items';
            DataClassification = ToBeClassified;
        }
        field(10; "Sales Transactions"; Decimal)
        {
            Caption = 'Sales Transactions';
            DataClassification = ToBeClassified;
        }
        field(11; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            DataClassification = ToBeClassified;
        }
        field(12; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            DataClassification = ToBeClassified;
        }
        field(13; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Store,Staff,POS';
            OptionMembers = Store,Staff,POS;
            DataClassification = CustomerContent;
        }
        field(14; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
            DataClassification = ToBeClassified;
        }
        field(20; "SalevsBudget"; Decimal)
        {
            Caption = 'SalevsBudget';
            DataClassification = ToBeClassified;
        }
        field(8; "Time"; Text[100])
        {
            Caption = 'Time';
            DataClassification = ToBeClassified;
        }
        field(21; "SaleToDay"; Decimal)
        {
            Caption = 'SaleToDay';
            DataClassification = ToBeClassified;
        }
        field(22; "AmountCongDon"; Decimal)
        {
            Caption = 'AmountCongDon';
            DataClassification = ToBeClassified;
        }
        field(23; "BudgetTotal"; Decimal)
        {
            Caption = 'BudgetTotal';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; Type, "Store", Time, Division)
        {
        }
    }
}

table 58057 "DivHourlySale"
{
    Access = Internal;
    Caption = 'DivHourlySale';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Division"; text[100])
        {
            Caption = 'Division';
            DataClassification = ToBeClassified;
        }
        field(2; "Sale"; Decimal)
        {
            Caption = 'Sale';
            DataClassification = ToBeClassified;
        }
        field(3; "Budget"; Decimal)
        {
            Caption = 'Budget';
            DataClassification = ToBeClassified;
        }
        field(10; "SaleToDay"; Decimal)
        {
            Caption = 'SaleToDay';
            DataClassification = ToBeClassified;
        }
        field(8; "SalevsBudget"; Decimal)
        {
            Caption = 'SalevsBudget';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Division)
        {
            Clustered = true;
        }
    }
}


table 58058 "BudgetSale"
{
    Access = Internal;
    Caption = 'BudgetSale';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Division"; text[100])
        {
            Caption = 'Division';
            DataClassification = ToBeClassified;
        }
        field(2; "Class"; text[100])
        {
            Caption = 'Class';
            DataClassification = ToBeClassified;
        }
        field(3; "BudgetAmount"; Decimal)
        {
            Caption = 'BudgetAmount';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; Division, Class)
        {
        }
    }
}

report 70014 "HourlySaleReport"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70014.HourlySaleReport.rdl';
    ApplicationArea = All;
    Caption = 'Hourly Sale Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("tbHourlySaleMatrixReport"; "HourlySaleMatrixReport")
        {
            column(Store; "Store")
            {
            }
            column(Division; "Division")
            {
            }
            column(Date; "Date")
            {
            }
            column(Time; "Time")
            {
            }
            column(Customer; "Customer")
            {
            }
            column(Sale; "Sale")
            {
            }
            column(Budget; "Budget")
            {
            }
            column(DateFilter; "DateFilter")
            {
            }
            column(SalevsBudget; SalevsBudget)
            {
            }
            column(AmountCongDon; AmountCongDon)
            {
            }
            column(BudgetTotal; BudgetTotal)
            {
            }

            trigger OnAfterGetRecord()
            begin


            end;


            trigger OnPreDataItem()
            begin
                FillBuffer();
                CalculateView();
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
                    field(DateFilter; DateFilter)
                    {
                        Caption = 'Date Filter';
                    }
                    field(StoreFilter; StoreFilter)
                    {
                        Caption = 'Store Filter';
                        TableRelation = "LSC Store";
                    }
                }
            }
        }
    }

    internal procedure FillBuffer()
    var
        TransHeader: Record "LSC Transaction Header";
        tbTransSale: Record "LSC Trans. Sales Entry";
        querSale: Query "Querry LSC Sale Total";
        tbDivision: Record "LSC Division";

        DivisionInt: Integer;
        ClassInt: Integer;
        DateChange: Text[100];

        Window: Dialog;
        TotalTrans: Integer;
        Counter: Integer;
    begin
        IF (DateFilter = 0D) THEN
            ERROR('The report couldn’t be generated, because the Date is empty.');

        IF (StoreFilter = '') THEN
            ERROR('The report couldn’t be generated, because the Store is empty.');


        Clear(tbHourlySaleReport);
        tbHourlySaleReport.DeleteAll;
        Counter := 0;

        Window.Open(
          'Number of Transactions #1###########\' +
          'Processed              #2###########');

        //MTD
        clear(tbDivision);
        tbDivision.SetFilter(Code, '<>%1', '');
        if tbDivision.FindSet() then begin
            repeat
                Clear(DivisionInt);
                Evaluate(DivisionInt, tbDivision.Code);

                Clear(tbBudgetSale);
                tbBudgetSale.Division := Format(DivisionInt);
                tbBudgetSale.BudgetAmount := 2000000000;
                tbBudgetSale.Insert();

                Clear(divSaleDetail);
                divSaleDetail.Division := format(DivisionInt);

                //Sale to Day
                divSaleDetail.SaleToDay := 0;
                Clear(querSale);
                querSale.SetRange(TH_DateFilter, DateFilter);
                querSale.SetFilter(TSE_DivisonFilter, format(DivisionInt));
                if StoreFilter <> '' then querSale.SetFilter(TH_StoreFilter, StoreFilter);
                querSale.Open;
                while querSale.Read do begin
                    divSaleDetail.SaleToDay := querSale.TSE_Total_Amount;
                end;

                divSaleDetail.Insert();

            until tbDivision.Next() = 0;
        end;


        TransHeader.Reset;
        TransHeader.SetCurrentKey("Transaction Type", "Entry Status", Date);
        TransHeader.SetRange("Transaction Type", TransHeader."Transaction Type"::Sales);
        // TransHeader.SetFilter("Entry Status", '%1|%2', TransHeader."Entry Status"::" ", TransHeader."Entry Status"::Posted);
        TransHeader.SetRange(Date, "DateFilter");
        TransHeader.SetFilter("Store No.", "StoreFilter");
        TotalTrans := TransHeader.Count;
        Window.Update(1, TotalTrans);

        if TransHeader.FindSet() then
            repeat
                Counter += 1;
                if (Counter mod 100) = 0 then
                    Window.Update(2, Counter);

                Clear(tbTransSale);
                tbTransSale.SetRange("POS Terminal No.", TransHeader."POS Terminal No.");
                tbTransSale.SetRange("Store No.", TransHeader."Store No.");
                tbTransSale.SetRange("Transaction No.", TransHeader."Transaction No.");
                if tbTransSale.FindSet() then begin
                    repeat
                        Clear(tbHourlySaleReport);
                        tbHourlySaleReport.Init;
                        tbHourlySaleReport.Type := tbHourlySaleReport.Type::Store;
                        tbHourlySaleReport."Store" := TransHeader."Store No.";
                        tbHourlySaleReport."Date" := TransHeader."Date";
                        tbHourlySaleReport."Division" := tbTransSale."Division Code";
                        tbHourlySaleReport.Budget := 2000000000;//Cho 1 ngày

                        //divSaleDetail
                        Clear(divSaleDetail);
                        divSaleDetail.SetRange(Division, tbTransSale."Division Code");
                        if divSaleDetail.FindFirst() then begin
                            tbHourlySaleReport."SaleToDay" := divSaleDetail."SaleToDay";
                        end;

                        //Lấy bill với thời gian nhỏ hơn kỳ gần nhất
                        StatisticsTimeSetup.SetFilter("Start Time", '<=%1', TransHeader.Time);
                        if StatisticsTimeSetup.FindLast then
                            tbHourlySaleReport.Time := StatisticsTimeSetup."Start Time"
                        else
                            tbHourlySaleReport.Time := 235959T;

                        if not tbHourlySaleReport.Get(tbHourlySaleReport.Type, tbHourlySaleReport."Store", tbHourlySaleReport.Time, tbHourlySaleReport.Division) then begin
                            tbHourlySaleReport."Net Amount" := tbHourlySaleReport."Net Amount" + tbTransSale."Net Amount";
                            tbHourlySaleReport."Sale" := (tbHourlySaleReport."Sale" + tbTransSale."Total Rounded Amt.");
                            tbHourlySaleReport."Gross Amount" := tbHourlySaleReport."Gross Amount" + tbTransSale."Total Rounded Amt.";
                            tbHourlySaleReport."No. of Items" := tbHourlySaleReport."No. of Items" + 1;

                            tbHourlySaleReport."Customer" := 1;
                            tbHourlySaleReport."Sales Transactions" := 1;

                            tbHourlySaleReport.Insert();
                        end else begin
                            tbHourlySaleReport."Net Amount" := tbHourlySaleReport."Net Amount" + tbTransSale."Net Amount";
                            tbHourlySaleReport."Sale" := (tbHourlySaleReport."Sale" + tbTransSale."Total Rounded Amt.");
                            tbHourlySaleReport."Gross Amount" := tbHourlySaleReport."Gross Amount" + tbTransSale."Total Rounded Amt.";
                            tbHourlySaleReport."No. of Items" := tbHourlySaleReport."No. of Items" + 1;

                            tbHourlySaleReport."Customer" := tbHourlySaleReport."Sales Transactions" + 1;
                            tbHourlySaleReport."Sales Transactions" := tbHourlySaleReport."Sales Transactions" + 1;
                            tbHourlySaleReport.Modify;
                        end;

                    until tbTransSale.Next = 0;
                end;
            until TransHeader.Next = 0;

    end;


    internal procedure CalculateView()
    var
        amountCongDon: Decimal;
        tbDivision: Record "LSC Division";
        DivisionInt: Decimal;

        BudgetValue: Decimal;
        BudgetTotalValue: Decimal;
    begin
        Clear(tbHourlySaleMatrixReport);
        tbHourlySaleMatrixReport.DeleteAll();

        Clear(tbBudgetSale);
        tbBudgetSale.SetFilter(Division, '<>%1', '');
        tbBudgetSale.CalcSums(BudgetAmount);
        BudgetTotalValue := tbBudgetSale.BudgetAmount;

        clear(StatisticsTimeSetup);
        if (StatisticsTimeSetup.Find('-')) then
            repeat
                clear(tbDivision);
                tbDivision.SetFilter(Code, '<>%1', '');
                if tbDivision.FindSet() then begin
                    repeat
                    begin
                        //Get amount division
                        Evaluate(DivisionInt, tbDivision.Code);

                        amountCongDon := 0;

                        Clear(tbHourlySaleMatrixReport);
                        tbHourlySaleMatrixReport.SetRange(Division, Format(DivisionInt));
                        tbHourlySaleMatrixReport.SetRange("Store", StoreFilter);
                        tbHourlySaleMatrixReport.CalcSums(Sale);
                        amountCongDon := tbHourlySaleMatrixReport.Sale;

                        Clear(tbBudgetSale);
                        tbBudgetSale.SetRange(Division, Format(DivisionInt));
                        if tbBudgetSale.FindFirst() then
                            BudgetValue := tbBudgetSale.BudgetAmount;

                        tbHourlySaleReport.SetRange(Type, tbHourlySaleReport.Type::Store);
                        tbHourlySaleReport.SetRange("Store", StoreFilter);
                        tbHourlySaleReport.SetRange("Division", Format(DivisionInt));
                        tbHourlySaleReport.SetRange(Time, StatisticsTimeSetup."Start Time");
                        if tbHourlySaleReport.FindSet then begin
                            repeat
                                Clear(tbHourlySaleMatrixReport);
                                tbHourlySaleMatrixReport.Time := FORMAT(StatisticsTimeSetup."Start Time", 0, '<Hours24,2>:<Minutes,2>') + ' - '
                                + FORMAT(StatisticsTimeSetup."End Time", 0, '<Hours24,2>:<Minutes,2>');
                                tbHourlySaleMatrixReport.Date := tbHourlySaleReport.Date;
                                tbHourlySaleMatrixReport.Type := tbHourlySaleReport.Type;
                                tbHourlySaleMatrixReport.Division := tbHourlySaleReport.Division;
                                tbHourlySaleMatrixReport.Store := tbHourlySaleReport.Store;
                                tbHourlySaleMatrixReport.Customer := tbHourlySaleReport.Customer;
                                tbHourlySaleMatrixReport."Budget" := BudgetValue;
                                tbHourlySaleMatrixReport."BudgetTotal" := BudgetTotalValue;
                                tbHourlySaleMatrixReport."Net Amount" := tbHourlySaleMatrixReport."Net Amount" + tbHourlySaleReport."Net Amount";
                                tbHourlySaleMatrixReport."Sale" := -(tbHourlySaleMatrixReport."Sale" + tbHourlySaleReport."Sale");

                                tbHourlySaleMatrixReport.AmountCongDon := amountCongDon + tbHourlySaleMatrixReport."Sale";
                                if BudgetValue = 0 then begin
                                    tbHourlySaleMatrixReport."SalevsBudget" := 0
                                end else
                                    tbHourlySaleMatrixReport.SalevsBudget := tbHourlySaleMatrixReport.AmountCongDon / BudgetValue;

                                tbHourlySaleMatrixReport."Gross Amount" := tbHourlySaleMatrixReport."Gross Amount" + tbHourlySaleReport."Gross Amount";
                                tbHourlySaleMatrixReport."No. of Items" := tbHourlySaleMatrixReport."No. of Items" + tbHourlySaleReport."No. of Items";
                                tbHourlySaleMatrixReport."Sales Transactions" := tbHourlySaleMatrixReport."Sales Transactions" + tbHourlySaleReport."Sales Transactions";
                                tbHourlySaleMatrixReport."SaleToDay" := tbHourlySaleReport."SaleToDay";

                                tbHourlySaleMatrixReport.Insert();
                            until tbHourlySaleReport.Next = 0;
                        end else begin
                            Clear(tbHourlySaleMatrixReport);
                            tbHourlySaleMatrixReport.Time := FORMAT(StatisticsTimeSetup."Start Time", 0, '<Hours24,2>:<Minutes,2>') + ' - '
                               + FORMAT(StatisticsTimeSetup."End Time", 0, '<Hours24,2>:<Minutes,2>');
                            tbHourlySaleMatrixReport.Date := tbHourlySaleReport.Date;
                            tbHourlySaleMatrixReport.Type := tbHourlySaleReport.Type;
                            tbHourlySaleMatrixReport.Division := Format(DivisionInt);
                            tbHourlySaleMatrixReport.Store := tbHourlySaleReport.Store;
                            tbHourlySaleMatrixReport."BudgetTotal" := BudgetTotalValue;
                            tbHourlySaleMatrixReport.Customer := 0;
                            tbHourlySaleMatrixReport."Budget" := BudgetValue;
                            tbHourlySaleMatrixReport."Net Amount" := 0;
                            tbHourlySaleMatrixReport."Sale" := 0;
                            tbHourlySaleMatrixReport."Gross Amount" := 0;
                            tbHourlySaleMatrixReport."No. of Items" := 0;
                            tbHourlySaleMatrixReport."Sales Transactions" := 0;
                            tbHourlySaleMatrixReport."SaleToDay" := 0;

                            tbHourlySaleMatrixReport.AmountCongDon := amountCongDon + tbHourlySaleMatrixReport."Sale";
                            if BudgetValue = 0 then begin
                                tbHourlySaleMatrixReport."SalevsBudget" := 0
                            end else
                                tbHourlySaleMatrixReport.SalevsBudget := tbHourlySaleMatrixReport.AmountCongDon / BudgetValue;

                            tbHourlySaleMatrixReport.Insert();
                        end;
                    end;

                    until tbDivision.Next() = 0;
                end;
            until StatisticsTimeSetup.Next = 0;

        Clear(tbHourlySaleMatrixReport);
    end;


    procedure GetPreviousYearDate(InputDate: Date): Date
    var
        PreviousYearDate: Date;
    begin
        PreviousYearDate := DMY2Date(Date2DMY(InputDate, 1), Date2DMY(InputDate, 2), Date2DMY(InputDate, 3) - 1);
        exit(PreviousYearDate);
    end;

    procedure GetDateRangeLastText(InputDate: Date): Text
    var
        StartDate, EndDate : Date;
        PreviousYear: Integer;
    begin
        PreviousYear := Date2DMY(InputDate, 3) - 1; // Lấy năm trước
        StartDate := DMY2Date(1, 1, PreviousYear); // 01/01/năm trước
        EndDate := DMY2Date(Date2DMY(InputDate, 1), Date2DMY(InputDate, 2), PreviousYear); // ngày/tháng giữ nguyên, năm -1

        exit(Format(StartDate) + '..' + Format(EndDate));
    end;

    procedure GetDateRangeCurrentText(InputDate: Date): Text
    var
        StartDate, EndDate : Date;
        PreviousYear: Integer;
    begin
        PreviousYear := Date2DMY(InputDate, 3); // Lấy năm hiện tại
        StartDate := DMY2Date(1, 1, PreviousYear); // 01/01/năm trước
        EndDate := DMY2Date(Date2DMY(InputDate, 1), Date2DMY(InputDate, 2), PreviousYear); // ngày/tháng giữ nguyên, năm

        exit(Format(StartDate) + '..' + Format(EndDate));
    end;

    var
        tbHourlySaleReport: Record "HourlySaleReport";
        // tbMemberDup: Record "MemberDup";
        // tbMemberDup1: Record "MemberDup";
        HourlySales: Record "LSC Hourly Distr Work Table" temporary;
        StatisticsTimeSetup: Record "LSC Statistics Time Setup";
        ApplicationManagement: Codeunit "Filter Tokens";
        "DateFilter": Date;
        "StoreFilter": Text;
        divSaleDetail: Record "DivHourlySale";
        tbBudgetSale: Record "BudgetSale";
}

