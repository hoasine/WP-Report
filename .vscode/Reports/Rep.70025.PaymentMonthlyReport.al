report 70025 "Payment Monthly Report"
{
    ApplicationArea = All;
    Caption = 'Payment Monthly Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = PaymentMonthlyReportExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(DayLoop; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 365));

            dataitem(TenderLoop; "LSC Tender Type Setup")
            {
                DataItemLinkReference = DayLoop;

                column(Date; DayDate) { }
                column(TenderCode; TenderLoop."Code") { }
                column(TenderType; TenderLoop.Description) { }
                column(SalesAmount; SalesAmount) { }

                trigger OnPreDataItem()
                begin
                    TenderLoop.SetFilter("Code", '<>9');
                end;

                trigger OnAfterGetRecord()
                var
                    queryPayment: Query "QueSaleTransactionList";
                    queryCardEntry: Query "QuePosCardEntry";
                    tbPosCardEntry: Record "LSC POS Card Entry";
                    tbTenderSetup: Record "LSC Tender Type Card Setup";
                    StartDate: Date;
                    StartDateFilter: Date;
                    EndDateFilter: Date;
                begin
                    ParseDateRange(DateFilter, StartDateFilter, EndDateFilter);

                    DayDate := CalcDate('+' + Format(DayLoop.Number - 1) + 'D', StartDateFilter);
                    if (DayDate > EndDateFilter) then
                        CurrReport.Break;


                    SalesAmount := 0;


                    if (TenderLoop."Code" <> '3') then begin
                        Clear(queryPayment);
                        queryPayment.SetRange("TH_DateFilter", DayDate);
                        if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
                        if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
                        queryPayment.SetRange("TSE_TenderTypeFilter", TenderLoop."Code");
                        queryPayment.Open;
                        while queryPayment.Read do begin
                            SalesAmount := -queryPayment.SumAmountTender;
                        end;

                        Clear(queryCardEntry);
                        queryCardEntry.SetRange("TH_DateFilter", DayDate);
                        queryCardEntry.SetRange("TSE_Tender", '3');
                        queryCardEntry.SetRange("TSE_Tender_PointFilter", TenderLoop."Code");
                        if StoreFilter <> '' then queryCardEntry.SetRange("TH_StoreFilter", StoreFilter);
                        if PosTerminalFilter <> '' then queryCardEntry.SetRange("PosterminalFilter", PosTerminalFilter);
                        queryCardEntry.Open;
                        while queryCardEntry.Read do begin
                            SalesAmount += queryCardEntry.TSE_Amount_Card_Entry;
                        end;
                    end else begin
                        Clear(queryCardEntry);
                        queryCardEntry.SetRange("TH_DateFilter", DayDate);
                        queryCardEntry.SetRange("TSE_Tender", '3');
                        queryCardEntry.SetRange("TSE_Tender_PointFilter", '');
                        if StoreFilter <> '' then queryCardEntry.SetRange("TH_StoreFilter", StoreFilter);
                        if PosTerminalFilter <> '' then queryCardEntry.SetRange("PosterminalFilter", PosTerminalFilter);
                        queryCardEntry.Open;
                        while queryCardEntry.Read do begin
                            SalesAmount += queryCardEntry.TSE_Amount_Card_Entry;
                        end;

                        TenderType := 'No Name';
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin

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
                    field("Store"; StoreFilter)
                    {
                        TableRelation = "LSC Store";
                    }
                    field("Pos terminal"; PosTerminalFilter)
                    {
                        TableRelation = "LSC POS Terminal";
                    }
                }
            }
        }
    }

    rendering
    {
        layout(PaymentMonthlyReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70025.PaymentMonthlyReportExcel.xlsx';
            Caption = 'Payment Monthly Report Excel';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70025.PaymentMonthlyReportExcel.xlsx';
        }
    }

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
        SelectedYear: Integer;
        DayDate: Date;
        SalesAmount: Decimal;
        TenderType: Text[100];
        DateFilter: Text;
        StoreFilter: Text[100];
        ApplicationManagement: Codeunit "Filter Tokens";
        PosTerminalFilter: Text[100];
}