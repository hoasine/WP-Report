report 70030 "DailySaleReportforMgt"
{
    ApplicationArea = All;
    Caption = 'Daily Sale Report for Mgt';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = DailySaleReportforMgtExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(DayLoop; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 365));

            column(Date; DayDate) { }
            column(Actual; -SalesAmount) { }
            column(Budget; Budget) { }
            column(variance; variance) { }
            column(VsBudget; VsBudget) { }
            column(customers; customers) { }
            column(cus; cus) { }
            column(Promotion; Promotion) { }
            column(DayInt; DayInt) { }
            column(DayText; DayText) { }
            column(Year; SelectedYear) { }
            column(MonthText; MonthText) { }

            trigger OnAfterGetRecord()
            var
                // quDailySaleReportMgt: Query "Daily Sale Report for Mgt";// không dùng
                quDailySaleReportMgt: Query "QueDailySaleReport";
                // quDailyMgtCustomer: Query "Daily Sale Mgt Customer";
                quDailyMgtCustomer: Query "QueCustumerReportCount";
                tbBudget: Record "wp Import Budget. Data";
                StartDate: Date;

                LastReceipt: text;
            begin
                clear(Budget);
                clear(variance);
                clear(VsBudget);
                clear(customers);
                clear(cus);
                clear(Promotion);

                StartDate := DMY2DATE(1, 1, SelectedYear);
                DayDate := CalcDate('+' + Format(DayLoop.Number - 1) + 'D', StartDate);
                SalesAmount := 0;

                Clear(quDailySaleReportMgt);
                quDailySaleReportMgt.SetRange(TH_DateFilter, DayDate);
                if StoreFilter <> '' then quDailySaleReportMgt.SetFilter(TH_StoreFilter, StoreFilter);
                quDailySaleReportMgt.Open;
                while quDailySaleReportMgt.Read do begin
                    SalesAmount := -quDailySaleReportMgt."TSE_Total_Amount";
                end;

                DayInt := Format(DayDate, 0, '<Day,2>');
                DayText := GetDayName(Date2DWY(DayDate, 1));
                MonthText := FORMAT(DayDate, 0, '<Month Text>');

                customers := 0;
                LastReceipt := '';
                Clear(quDailyMgtCustomer);
                quDailyMgtCustomer.SetRange(TH_DateFilter, DayDate);
                if StoreFilter <> '' then quDailyMgtCustomer.SetFilter(TH_StoreFilter, StoreFilter);
                quDailyMgtCustomer.Open;
                while quDailyMgtCustomer.Read do begin
                    if (quDailyMgtCustomer.Receipt_No_ <> LastReceipt) then begin
                        customers += 1;
                        LastReceipt := quDailyMgtCustomer.Receipt_No_;
                    end;
                end;

                Clear(tbBudget);
                tbBudget.SetRange(Date, DayDate);
                if StoreFilter <> '' then
                    tbBudget.SetFilter("StoreNo", StoreFilter);
                tbBudget.CalcSums(TotalSales);
                Budget := tbBudget.TotalSales;

                variance := abs(SalesAmount) - Budget;

                if Budget <> 0 then
                    VsBudget := (abs(SalesAmount) / Budget) - 1
                else
                    VsBudget := 0;

                if customers <> 0 then
                    cus := abs(SalesAmount) / customers
                else
                    cus := 0;

                Promotion := '';
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
                    field("Selected year"; SelectedYear)
                    {
                        ApplicationArea = All;
                    }
                    field("Store"; StoreFilter)
                    {
                        TableRelation = "LSC Store";
                    }
                }
            }
        }
    }

    rendering
    {
        layout(DailySaleReportforMgtExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70030.DailySaleReportforMgt.xlsx';
            Caption = 'Daily Sale Report for Mgt Excel';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70030.DailySaleReportforMgt.xlsx';
        }
    }

    local procedure GetDayName(DayOfWeek: Integer): Text
    begin
        case DayOfWeek of
            1:
                exit('Mon');
            2:
                exit('Tue');
            3:
                exit('Wed');
            4:
                exit('Thu');
            5:
                exit('Fri');
            6:
                exit('Sat');
            7:
                exit('Sun');
            else
                exit('Non');
        end;
    end;

    var
        SelectedYear: Integer;
        DayDate: Date;
        SalesAmount: Decimal;
        TenderType: Text[100];
        StoreFilter: Text[100];
        PosTerminalFilter: Text[100];
        Budget: Decimal;
        variance: Decimal;
        VsBudget: Decimal;
        customers: Decimal;
        cus: Decimal;
        Promotion: Text[100];
        DayInt: Text[100];
        DayText: Text[100];
        MonthText: Text[100];

}
