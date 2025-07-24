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
                // DataItemLink = "Default Function" = field(Number);
                DataItemTableView =
                WHERE("Default Function" = FILTER(
                    Normal
                ));
                // WHERE("Default Function" = FILTER(
                //     Normal | Card | Check | Customer | "Tender Remove/Float" | Coupons | Voucher | Member
                // ));

                column(Date; DayDate) { }
                column(TenderCode; TenderLoop.Code) { }
                column(TenderType; TenderLoop.Description) { }
                column(SalesAmount; SalesAmount) { }

                trigger OnAfterGetRecord()
                var
                    tbPayment: Record "LSC Trans. Payment Entry";
                    StartDate: Date;
                begin
                    StartDate := DMY2DATE(1, 1, SelectedYear);
                    DayDate := CalcDate('+' + Format(DayLoop.Number - 1) + 'D', StartDate);
                    SalesAmount := 0;

                    tbPayment.SetRange("Tender Type", TenderLoop.Code);
                    tbPayment.SetRange("Date", DayDate, DayDate);
                    if PosTerminalFilter <> '' then tbPayment.SetRange("POS Terminal No.", PosTerminalFilter);
                    if StoreFilter <> '' then tbPayment.SetRange("Store No.", StoreFilter);
                    if tbPayment.FindSet() then
                        repeat
                            SalesAmount += tbPayment."Amount Tendered";
                        until tbPayment.Next() = 0;
                end;
            }
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

    var
        SelectedYear: Integer;
        DayDate: Date;
        SalesAmount: Decimal;
        TenderType: Text[100];
        StoreFilter: Text[100];
        PosTerminalFilter: Text[100];
}


// theo thangs 
// report 70025 "Payment Monthly Report"
// {
//     ApplicationArea = All;
//     Caption = 'Payment Monthly Report';
//     DataAccessIntent = ReadOnly;
//     DefaultRenderingLayout = PaymentMonthlyReportExcel;
//     ExcelLayoutMultipleDataSheets = true;
//     PreviewMode = PrintLayout;
//     UsageCategory = ReportsAndAnalysis;
//     MaximumDatasetSize = 1000000;

//     dataset
//     {
//         dataitem(MonthLoop; Integer)
//         {
//             DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 12));

//             dataitem(TenderLoop; "LSC Tender Type Setup")
//             {
//                 DataItemLinkReference = MonthLoop;
//                 DataItemLink = "Default Function" = const(Normal);

//                 column(MonthName; Format(WorkDate, 0, '<Month Text>') + ' ' + Format(SelectedYear)) { }
//                 column(MonthNumber; MonthLoop.Number) { }
//                 column(TenderType; TenderLoop.Code) { }
//                 column(SalesAmount; SalesAmount) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     tbPayment: Record "LSC Trans. Payment Entry";
//                     StartDate: Date;
//                     EndDate: Date;
//                 begin
//                     StartDate := DMY2DATE(1, MonthLoop.Number, SelectedYear);
//                     EndDate := CALCDATE('<CM>', StartDate) - 1;
//                     SalesAmount := 0;

//                     tbPayment.SetRange("Tender Type", TenderLoop.Code);
//                     tbPayment.SetRange("Date", StartDate, EndDate);

//                     if tbPayment.FindSet() then
//                         repeat
//                             SalesAmount += tbPayment."Amount Tendered";
//                         until tbPayment.Next() = 0;
//                 end;
//             }
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(content)
//             {
//                 field("Selected year"; SelectedYear)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     rendering
//     {
//         layout(PaymentMonthlyReportExcel)
//         {
//             Type = Excel;
//             LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70025.PaymentMonthlyReportExcel.xlsx';
//             Caption = 'Supplier Voucher Report';
//             Summary = '.vscode/ReportLayouts/Excel/Rep.70025.PaymentMonthlyReportExcel.xlsx';
//         }
//     }

//     var
//         SelectedYear: Integer;
//         SalesAmount: Decimal;
// }
