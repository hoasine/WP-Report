report 70020 "Staff Allowance HR Report"
{
    ApplicationArea = All;
    DefaultRenderingLayout = "StaffAllowanceHRReportExcel";
    DataAccessIntent = ReadOnly;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;
    Caption = 'Staff Allowance HR Report';

    dataset
    {
        dataitem(Data; "LSC Trans. Sales Entry")
        {
            RequestFilterFields = "Date";

            column(USERID; UserId) { }
            column(COMPANYNAME; CompanyName) { }
            column(PrintDate; DatePrint) { }
            column(TargetDate; TargetDate) { }
            column(StaffCode; StaffCode) { }
            column(Name; Name) { }
            column(Position; Position) { }
            column(Status; Status) { }
            column(YearlyBudget; Budget) { }
            column(UsedBudget; UsedBudget) { }
            column(YearlySpending; -"Total Rounded Amt.") { }
            column(YearlyAllowance; "wp Staff Disc. Amount") { }
            column(MemberCode; MemberCode) { }
            column(MemberName; MemberName) { }
            column(Date; "Date") { }
            column(POS_Terminal_No_; "POS Terminal No.") { }
            column(Transaction_No_; "Transaction No.") { }
            column(Brand; Brand) { }

            trigger OnPreDataItem()
            begin
                Data.SetFilter("wp Staff Card No.", '<>%1', '');
            end;

            trigger OnAfterGetRecord()
            var
                staff: Record "LSC Staff";
                staffRole: Record "wpStaffAllowanceRoles";
                tbTransactionHeader: Record "LSC Transaction Header";
                tbProductGroup: Record "LSC Retail Product Group";
                tbMemberShipcard: Record "LSC Membership Card";
                tbMemberContact: Record "LSC Member Contact";
                tbMSR: Record "LSC MSR Card Link Setup";
                tbstaffBudget: Record "wpStaffAllowanceRoleLines";
                queryStaff: Query "QueStaffAllowanceHRReport";

                AmountSale: Decimal;
            begin
                TargetDate := ParseDateRangeOfFilter(Data.GetFilter(Date));
                DatePrint := FORMAT(Today(), 0, '<Day,2>/<Month,2>/<Year4>');


                clear(MemberName);
                clear(StaffCode);
                clear(Brand);
                clear(MemberCode);
                clear(Status);
                clear(Name);


                Clear(tbMSR);
                tbMSR.SetRange("Card Number", "wp Staff Card No.");
                if tbMSR.FindFirst() then begin
                    Clear(staff);
                    staff.SetRange(ID, tbMSR."Link No.");
                    if staff.FindFirst() then begin
                        Name := staff."Name on Receipt";
                        StaffCode := staff.ID;

                        Clear(staffRole);
                        staffRole.SetRange(ID, staff."wp Staff Role");
                        if staffRole.FindFirst() then begin
                            Position := staffRole."Description"
                        end;
                    end;
                end;

                Clear(tbTransactionHeader);
                tbTransactionHeader.SetRange("Store No.", Data."Store No.");
                tbTransactionHeader.SetRange("POS Terminal No.", Data."POS Terminal No.");
                tbTransactionHeader.SetRange("Transaction No.", Data."Transaction No.");
                if tbTransactionHeader.FindFirst() then begin
                    Clear(tbMemberShipcard);
                    tbMemberShipcard.SetRange("Card No.", tbTransactionHeader."Member Card No.");
                    if tbMemberShipcard.FindFirst() then begin
                        Clear(tbMemberContact);
                        tbMemberContact.SetRange("Account No.", tbMemberShipcard."Account No.");
                        if tbMemberContact.FindFirst() then begin
                            MemberName := tbMemberContact."Name";
                        end;
                    end;

                    MemberCode := tbTransactionHeader."Member Card No."
                end;

                Clear(tbstaffBudget);
                tbstaffBudget.SetRange("Role ID", "wp Staff Role");
                if tbstaffBudget.FindFirst() then
                    Budget := tbstaffBudget."Purchase Amount";

                Clear(queryStaff);
                queryStaff.SetFilter(DateFilter, Data.GetFilter(Date));
                queryStaff.SetRange(staffFilter, "wp Staff Card No.");
                queryStaff.Open;
                while queryStaff.Read do begin
                    AmountSale := queryStaff.TSE_Total_Amount;
                end;

                UsedBudget := Budget - AmountSale;

                Clear(tbProductGroup);
                tbProductGroup.SetRange("Code", Data."Retail Product Code");
                if tbProductGroup.FindFirst() then begin
                    Brand := tbProductGroup."Description"
                end;
            end;
        }
    }

    rendering
    {
        layout(StaffAllowanceHRReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70020.StaffAllowanceHRReportExcel.xlsx';
            Caption = 'Staff Allowance HR Report';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70020.StaffAllowanceHRReportExcel.xlsx';
        }
    }

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
        PrintDate: Text[100];
        TargetDate: Text[100];
        Name: Text[100];
        Position: Text[100];
        Status: Text[100];
        MemberCode: Text[100];
        Brand: Text[100];
        MemberName: Text[100];
        Budget: Decimal;
        UsedBudget: Decimal;

        StaffCode: Text[100];
        DatePrint: Text[100];

}