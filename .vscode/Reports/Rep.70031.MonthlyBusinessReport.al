table 58055 "Monthly Business Report"
{
    Access = Internal;
    Caption = 'Monthly Business Table';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Division"; Text[500])
        {
            Caption = 'Division';
            DataClassification = ToBeClassified;
        }
        field(2; "Product Group"; Text[500])
        {
            Caption = 'Product Group';
            DataClassification = ToBeClassified;
        }
        field(3; "Category"; Text[500])
        {
            Caption = 'Divisons';
            DataClassification = ToBeClassified;
        }
        field(4; "Sale"; Decimal)
        {
            Caption = 'Sale';
            DataClassification = ToBeClassified;
        }
        field(5; "Budget"; Decimal)
        {
            Caption = 'Budget';
            DataClassification = ToBeClassified;
        }
        field(6; "SaleLY"; Decimal)
        {
            Caption = 'SaleLY';
            DataClassification = ToBeClassified;
        }
        field(7; "Profit"; Decimal)
        {
            Caption = 'Profit';
            DataClassification = ToBeClassified;
        }
        field(8; "LYProfit"; Decimal)
        {
            Caption = 'LYProfit';
            DataClassification = ToBeClassified;
        }
        field(9; "Cust"; Decimal)
        {
            Caption = 'Profit';
            DataClassification = ToBeClassified;
        }
        field(10; "CustLY"; Decimal)
        {
            Caption = 'CustLY';
            DataClassification = ToBeClassified;
        }
        field(11; "Month"; Text[100])
        {
            Caption = 'Month';
            DataClassification = ToBeClassified;
        }
        field(12; "MonthDate"; Date)
        {
            Caption = 'MonthDate';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Division", "Category", "Product Group", "Month")
        {
            Clustered = true;
        }
    }
}


report 70031 "Monthly Business Report"
{
    ApplicationArea = All;
    Caption = 'Monthly Business Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = MonthlyBusinessReportExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Data; "Monthly Business Report")
        {
            // DataItemTableView = sorting("Line No.");
            // RequestFilterFields = dateFilter;
            // PrintOnlyIfDetail = true;
            column(USERID; UserId)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(DatePrint; DatePrint)
            {
            }
            column(StartDateFilter; StartDateFilter) { }
            column(EndDateFilter; EndDateFilter) { }
            column(MonthFilter; lbTime) { }
            column(Month; Month) { }
            column(MonthDate; MonthDate) { }
            column(Division; "Division") { }
            column(Class; "Product Group") { }
            column(Department; "Category") { }
            column(Sale; Sale) { }
            column(Budget; Budget) { }
            column(SaleLY; SaleLY) { }
            column(Profit; Profit) { }
            column(LYProfit; LYProfit) { }
            column(Cust; Cust) { }
            column(CustLY; CustLY) { }

            trigger OnAfterGetRecord()

            begin


            end;

            trigger OnPreDataItem()

            var
                quSaleTotal: Query "QueDailySaleReport";
                quTotalMember: Query "QueCustumerReportCount";
                tbDivision: Record "LSC Division";
                tbItemCate: Record "Item Category";
                tbProuctGroup: Record "LSC Retail Product Group";
                tbTransHeader: Record "LSC Transaction Header";
                tbBudget: Record "wp Import Budget. Data";


                // DivisionInt: Integer;
                // ProductGroupInt: Integer;
                // CategoryInt: Integer;

                InputYear: Integer;
                StartDate: date;
                EndDate: date;

                InputYearDate: Date;
                StartDateText: Text;
                thangnamtruocText: text[100];
                CurrentDate: Date;

                FirstDayOfMonth: Date;
                LastDayOfMonth: Date;
                NextMonthDate: Date;
                FromDateText: Text;
                ToDateText: Text;
                RangeText: Text;

                NumberMonth: Decimal;

                Window: Dialog;
                Counter: Integer;

                BillCount: Integer;
                LastReceipt: text;
            begin
                IF (DateFilter = '') THEN
                    ERROR('The report couldn’t be generated, because the DateFilter is empty.');

                NumberMonth := 0;
                Counter := 0;
                Window.Open(
                'Number of #1###########\' +
                'Processed              #2###########');

                clear(tbDivision);
                tbDivision.SetFilter(Code, '<>%1', '');
                if DivisionFilter <> '' then tbDivision.SetRange(Code, DivisionFilter);
                if tbDivision.FindSet() then begin
                    repeat
                        clear(tbItemCate);
                        tbItemCate.SetRange("LSC Division Code", tbDivision.Code);
                        if tbItemCate.FindSet() then begin
                            repeat
                                clear(tbProuctGroup);
                                tbProuctGroup.SetRange("Item Category Code", tbItemCate.Code);
                                Window.Update(1, tbProuctGroup.Description);
                                if tbProuctGroup.FindSet() then begin
                                    repeat
                                        ParseDateRange(DateFilter, StartDate, EndDate);

                                        StartDateFilter := ParseDateRangeOfFilter(DateFilter);
                                        EndDateFilter := FORMAT(EndDate, 0, '<Day,2>/<Month,2>/<Year4>');
                                        DatePrint := FORMAT(Today(), 0, '<Day,2>/<Month,2>/<Year4>');

                                        CurrentDate := StartDate;
                                        while CurrentDate <= EndDate do begin
                                            Counter += 1;
                                            if (Counter mod 100) = 0 then
                                                Window.Update(2, Counter);

                                            FirstDayOfMonth := DMY2Date(1, Date2DMY(CurrentDate, 2), Date2DMY(CurrentDate, 3));
                                            NextMonthDate := CalcDate('<1M>', FirstDayOfMonth);
                                            LastDayOfMonth := NextMonthDate - 1;
                                            FromDateText := Format(FirstDayOfMonth, 0, '<Day,2>/<Month,2>/<Year,2>');
                                            ToDateText := Format(LastDayOfMonth, 0, '<Day,2>/<Month,2>/<Year,2>');

                                            //Kết quả
                                            RangeText := FromDateText + '..' + ToDateText;

                                            Clear(Data);
                                            Data.MonthDate := FirstDayOfMonth;
                                            Data.Month := FORMAT(FirstDayOfMonth, 0, '<Month,2>') + '. ' + FORMAT(FirstDayOfMonth, 0, '<Month Text>').ToUpper() + '.' + format(Date2DMY(CurrentDate, 3));
                                            Data."Division" := tbDivision.Code + ' - ' + tbDivision.Description;
                                            Data."Category" := tbItemCate.Code + ' - ' + tbItemCate.Description;
                                            Data."Product Group" := tbProuctGroup.Code + ' - ' + tbProuctGroup.Description;

                                            //Lay trong thang
                                            Clear(quSaleTotal);
                                            quSaleTotal.SetFilter(TH_DateFilter, RangeText);
                                            quSaleTotal.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                            quSaleTotal.SetFilter(TSE_CategoryFilter, format(tbItemCate.Code));
                                            quSaleTotal.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                            if StoreFilter <> '' then quSaleTotal.SetFilter(TH_StoreFilter, StoreFilter);
                                            quSaleTotal.Open;
                                            while quSaleTotal.Read do begin
                                                Data.Sale := quSaleTotal.TSE_Total_Amount;
                                            end;

                                            //Target This Month 1 -> 31
                                            Clear(tbBudget);
                                            tbBudget.SetFilter(Date, RangeText);
                                            if tbDivision.Code <> '' then
                                                tbBudget.SetFilter("DivisionCode", tbDivision.Code);
                                            if tbProuctGroup.Code <> '' then
                                                tbBudget.SetFilter("ClassCode", tbProuctGroup.Code);
                                            if StoreFilter <> '' then
                                                tbBudget.SetFilter("StoreNo", StoreFilter);
                                            tbBudget.CalcSums(TotalSales);
                                            Data.Budget := tbBudget.TotalSales;

                                            //quTotalMember
                                            Data.Cust := 0;
                                            LastReceipt := '';
                                            Clear(quTotalMember);
                                            quTotalMember.SetFilter(TH_DateFilter, RangeText);
                                            quTotalMember.SetFilter(TSE_DivisionFilter, format(tbDivision.Code));
                                            quTotalMember.SetFilter(TSE_CategoryFilter, format(tbItemCate.Code));
                                            quTotalMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                            if StoreFilter <> '' then quTotalMember.SetFilter(TH_StoreFilter, StoreFilter);
                                            quTotalMember.Open;
                                            while quTotalMember.Read do begin
                                                if quTotalMember.Receipt_No_ <> LastReceipt then begin
                                                    Data.Cust += 1;
                                                    LastReceipt := quTotalMember.Receipt_No_;
                                                end;
                                            end;

                                            //Lay Last year
                                            RangeText := GetPreviousYearDateRange(RangeText);
                                            Clear(quSaleTotal);
                                            quSaleTotal.SetFilter(TH_DateFilter, RangeText);
                                            quSaleTotal.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                            quSaleTotal.SetFilter(TSE_CategoryFilter, format(tbItemCate.Code));
                                            quSaleTotal.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                            if StoreFilter <> '' then quSaleTotal.SetFilter(TH_StoreFilter, StoreFilter);
                                            quSaleTotal.Open;
                                            while quSaleTotal.Read do begin
                                                Data.SaleLY := quSaleTotal.TSE_Total_Amount;
                                            end;

                                            Data.Profit := 0;
                                            Data.LYProfit := 0;
                                            Data.CustLY := 0;

                                            Data.Insert(true);

                                            // Tăng sang tháng tiếp theo
                                            CurrentDate := NextMonthDate;
                                        end;
                                    until tbProuctGroup.Next() = 0;
                                end;
                            until tbItemCate.Next() = 0;
                        end;
                    until tbDivision.Next() = 0;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Monthly Business Report Excel';
        AboutText = 'AboutText Monthly Business Report Excel';
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
                    field("Store"; StoreFilter)
                    {
                        TableRelation = "LSC Store";
                    }
                    field("Division"; DivisionFilter)
                    {
                        TableRelation = "LSC Division";
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin

        end;
    }

    rendering
    {
        layout(MonthlyBusinessReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70031.MonthlyBusinessReportExcel.xlsx';
            Caption = 'Monthly Business Report Excel';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70031.MonthlyBusinessReportExcel.xlsx';
        }
    }

    trigger OnPreReport()
    begin

    end;

    procedure GetPreviousYearDateRange(CurrentRange: Text): Text
    var
        FromText, ToText : Text;
        FromDate, ToDate : Date;
        NewFromDate, NewToDate : Date;
        NewFromText, NewToText : Text;
        SeparatorPos: Integer;
    begin
        // Tách chuỗi theo dấu ..
        SeparatorPos := StrPos(CurrentRange, '..');
        if SeparatorPos = 0 then
            Error('Chuỗi không đúng định dạng');

        FromText := CopyStr(CurrentRange, 1, SeparatorPos - 1);
        ToText := CopyStr(CurrentRange, SeparatorPos + 2);

        // Chuyển từ text sang date
        Evaluate(FromDate, FromText);
        Evaluate(ToDate, ToText);

        // Trừ 1 năm
        NewFromDate := CalcDate('-1Y', FromDate);
        NewToDate := CalcDate('-1Y', ToDate);

        // Định dạng lại ngày
        NewFromText := Format(NewFromDate, 0, '<Day,2>/<Month,2>/<Year,2>');
        NewToText := Format(NewToDate, 0, '<Day,2>/<Month,2>/<Year,2>');

        // Ghép lại thành chuỗi mới
        exit(NewFromText + '..' + NewToText);
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

    procedure ParseDateRangeOfFilter(DateRange: Text): Text
    var
        StartStr: Text[20];
        EndStr: Text[20];
        StartDate: Date;
        EndDate: Date;
        SeparatorPos: Integer;
        ResultText: Text;
    begin
        SeparatorPos := StrPos(DateRange, '..');

        if SeparatorPos > 0 then begin
            // Có khoảng ngày
            StartStr := CopyStr(DateRange, 1, SeparatorPos - 1);
            EndStr := CopyStr(DateRange, SeparatorPos + 2);

            Evaluate(StartDate, StartStr); // chuyển sang kiểu Date
            Evaluate(EndDate, EndStr);

            ResultText := Format(StartDate, 0, '<Day,2>/<Month,2>/<Year4>')
                + '-' +
                Format(EndDate, 0, '<Day,2>/<Month,2>/<Year4>');
        end else begin
            // Chỉ có 1 ngày
            Evaluate(StartDate, DateRange);
            ResultText := Format(StartDate, 0, '<Day,2>/<Month,2>/<Year4>');
        end;

        exit(ResultText);
    end;

    var
        StartDateFilter: Text[100];
        EndDateFilter: Text[100];
        DivisionFilter: Text[100];
        DateFilter: Text;
        ApplicationManagement: Codeunit "Filter Tokens";
        lbText: text[100];
        lbTime: text[100];
        DateFilterText: text[100];
        DatePrint: text[100];
        StoreFilter: text[100];
}
