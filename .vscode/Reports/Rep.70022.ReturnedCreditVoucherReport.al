
report 70022 "Returned Credit Voucher Report"
{
    ApplicationArea = All;
    Caption = 'Returned & Credit Voucher Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = ReturnedCreditVoucherReportExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Data; "LSC Trans. Payment Entry")
        {
            RequestFilterFields = "Date", "POS Terminal No.", "Receipt No.";
            DataItemTableView = sorting(Date);
            column(Date; Date) { }
            column(POS_Terminal_No_; "POS Terminal No.") { }
            column(Receipt_No_; "Receipt No.") { }
            column(Amount; Amount) { }
            column(Amount_Tendered; "Amount Tendered") { }
            column(UsedDate; UsedDate) { }
            column(Refund; Refund) { }
            column(CreditVoucher; CreditVoucher) { }
            column(EndingBalance; EndingBalance) { }
            column(Note; '') { }

            trigger OnPreDataItem()
            begin
                Data.SetRange("Tender Type", '21');
            end;

            trigger OnAfterGetRecord()
            var
                tbTransHeader: Record "LSC Transaction Header";
                tbTransPayment: Record "LSC Trans. Payment Entry";
                tbInfoCode: Record "LSC Trans. Infocode Entry";
            begin
                clear(tbTransHeader);
                tbTransHeader.SetRange("POS Terminal No.", Data."POS Terminal No.");
                tbTransHeader.SetRange("Store No.", Data."Store No.");
                tbTransHeader.SetRange("Transaction No.", Data."Transaction No.");
                tbTransHeader.SetRange("Receipt No.", Data."Receipt No.");
                if tbTransHeader.FindFirst() then
                    Amount := tbTransHeader.Payment;

                clear(tbTransPayment);
                tbTransPayment.SetRange("POS Terminal No.", Data."POS Terminal No.");
                tbTransPayment.SetRange("Store No.", Data."Store No.");
                tbTransPayment.SetRange("Transaction No.", Data."Transaction No.");
                tbTransPayment.SetRange("Receipt No.", Data."Receipt No.");
                tbTransPayment.SetRange("Tender Type", '21');
                tbTransPayment.CalcSums("Amount Tendered");
                CreditVoucher := tbTransPayment."Amount Tendered";

                Refund := Amount - CreditVoucher;

                EndingBalance := Amount - Refund - CreditVoucher;

                UsedDate := '';
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Returned Credit Voucher Report';
        AboutText = 'AboutText Returned Credit Voucher Report';
        layout
        {
            area(Content)
            {
                group(Option)
                {

                }
            }
        }
        trigger OnOpenPage()
        begin

        end;
    }

    rendering
    {
        layout(ReturnedCreditVoucherReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70022.ReturnedCreditVoucherReportExcel.xlsx';
            Caption = 'Supplier Voucher Report';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70022.ReturnedCreditVoucherReportExcel.xlsx';
        }
    }

    trigger OnPreReport()
    begin

    end;

    var
        SerialNo: Text[100];
        UsedDate: Text[100];
        Amount: Decimal;
        Refund: Decimal;
        EndingBalance: Decimal;
        CreditVoucher: Decimal;
}