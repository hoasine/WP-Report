table 58050 "Daily Sale Report"
{
    Access = Internal;
    Caption = 'Daily Sale Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Divison"; Text[500])
        {
            Caption = 'Divison';
            DataClassification = ToBeClassified;
        }
        field(2; "TypeTemp"; Text[500])
        {
            Caption = 'TypeTemp';
            DataClassification = ToBeClassified;
        }
        field(3; "Monthly Targe"; Decimal)
        {
            Caption = 'MonthlyTarge';
            DataClassification = ToBeClassified;
        }
        field(4; "Daily Target Total"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Daily Target Total';
        }
        field(5; "Sales Total"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Total';
        }
        field(6; "Balance(Sale-Target)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Balance(Sale-Target)';
        }
        field(7; "Acv Daily Target Total"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Acv Daily Target Total';
        }
        field(8; "Daily Target"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'DailyTarget';
        }
        field(9; "Daily Sales"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'DailyTarget';
        }
        field(10; "Last Year Sales"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Last Year Sales';
        }
    }
    keys
    {
        key(PK; "Divison", "TypeTemp")
        {
            Clustered = true;
        }
    }
}

report 70026 "Daily Sale Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70026.DailySaleReport.rdl';
    ApplicationArea = All;
    Caption = 'Daily Sale Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Data"; "Daily Sale Report")
        {

            // DataItemTableView = SORTING("");
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

            column(Date; DateFilter)
            {

            }
            column(StoreNo; StoreFilter)
            {

            }


            column(Division; "Divison")
            {

            }

            column(TypeTemp; TypeTemp)
            {

            }

            column(AcvDailyTargetTotal_Data; "Acv Daily Target Total")
            {
            }
            column(BalanceSaleTarget_Data; "Balance(Sale-Target)")
            {
            }
            column(DailySales_Data; "Daily Sales")
            {
            }
            column(DailyTarget_Data; "Daily Target")
            {
            }
            column(DailyTargetTotal_Data; "Daily Target Total")
            {
            }
            column(LastYearSales_Data; "Last Year Sales")
            {
            }
            column(MonthlyTarge_Data; "Monthly Targe")
            {
            }
            column(SalesTotal_Data; "Sales Total")
            {
            }

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                CreateData();
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
                        // trigger OnValidate()
                        // begin
                        //     ApplicationManagement.MakeDateFilter(DateFilter);
                        // end;
                    }
                    field("Store"; StoreFilter)
                    {
                        TableRelation = "LSC Store";
                    }
                    field("Pos terminal"; PosTerminalFilter)
                    {
                        TableRelation = "LSC POS Terminal";
                    }
                    field("Division"; DivisionFilter)
                    {
                        TableRelation = "LSC Division";
                    }
                    field("Brand"; SpecialGroupFilter)
                    {
                        TableRelation = "LSC Item Special Groups";
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
    procedure CreateData()
    var
        tbDivision: Record "LSC Division";
        querry: Query "QueDailySaleReport";
        querryCustomer: Query "QueCustumerReportCount";
        tbTransHeader: Record "LSC Transaction Header";
        tbBudget: Record "wp Import Budget. Data";
        DateChange: Text[100];

        Window: Dialog;
        TotalTrans: Integer;
        Counter: Integer;

        BillCount: Integer;
        LastReceipt: text;
    begin
        IF (DateFilter = 0D) THEN
            ERROR('The report couldn’t be generated, because the Date is empty.');

        Clear(Data);
        Data.DeleteAll;
        Counter := 0;

        Window.Open(
          'Number of Transactions #1###########\' +
          'Processed              #2###########');

        clear(tbDivision);
        tbDivision.SetFilter(Code, '<>%1&<>%2', '04', '');
        if DivisionFilter <> '' then tbDivision.SetRange(Code, DivisionFilter);
        TotalTrans := tbDivision.Count;
        Window.Update(1, TotalTrans);
        if tbDivision.FindSet() then begin
            repeat
                Counter += 1;
                if (Counter mod 100) = 0 then
                    Window.Update(2, Counter);

                //Quantity-------------------------------------------------------------------------------------------------------
                Clear(Data);
                Data."Divison" := tbDivision.Description;
                Data."TypeTemp" := 'Quantity';
                data."Acv Daily Target Total" := 0;
                Data."Monthly Targe" := 0;
                Data."Daily Target Total" := 0;
                Data."Daily Target" := 0;

                //Month Sale and Budget 
                DateChange := GetFirstDateToDatFilterRange(DateFilter);
                Clear(querry);
                querry.SetFilter(TH_DateFilter, DateChange);
                if StoreFilter <> '' then
                    querry.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then
                    querry.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if tbDivision.Code <> '' then
                    querry.SetFilter(TSE_DivisonFilter, tbDivision.Code);
                if ProductGroupFilter <> '' then
                    querry.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then
                    querry.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querry.Open;
                while querry.Read do begin
                    Data."Sales Total" := querry.TSE_Quantity_Amount;
                end;
                //Month Sale and Budget 

                Data."Balance(Sale-Target)" := Data."Sales Total" - Data."Daily Target Total";

                //Daily Sale & Target
                Clear(querry);
                querry.SetRange(TH_DateFilter, DateFilter);
                querry.SetFilter(TSE_DivisonFilter, tbDivision.Code);
                if StoreFilter <> '' then querry.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then querry.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if ProductGroupFilter <> '' then querry.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then querry.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querry.Open;
                while querry.Read do begin
                    Data."Daily Sales" := querry.TSE_Quantity_Amount;
                end;
                //Daily Sale & Target

                //Last year Sale
                DateChange := GetLastYearDateRange(DateFilter);
                Clear(querry);
                querry.SetFilter(TSE_DivisonFilter, tbDivision.Code);
                querry.SetFilter(TH_DateFilter, DateChange);
                if StoreFilter <> '' then querry.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then querry.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if ProductGroupFilter <> '' then querry.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then querry.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querry.Open;
                while querry.Read do begin
                    Data."Last Year Sales" := querry.TSE_Quantity_Amount;
                end;
                //Last year Sale

                Data.Insert();
                //Quantity-------------------------------------------------------------------------------------------------------

                //Amount---------------------------------------------------------------------------------------------------------
                Clear(Data);
                Data."Divison" := tbDivision.Description;
                Data."TypeTemp" := 'Amount';

                //Target This Month 1 -> 31
                DateChange := GetMonthRangeAsText(DateFilter);
                Clear(tbBudget);
                tbBudget.SetFilter(Date, DateChange);
                if ProductGroupFilter <> '' then
                    tbBudget.SetFilter("ClassCode", ProductGroupFilter);
                if tbDivision.Code <> '' then
                    tbBudget.SetFilter("DivisionCode", tbDivision.Code);
                if StoreFilter <> '' then
                    tbBudget.SetFilter("StoreNo", StoreFilter);
                tbBudget.CalcSums(TotalSales);

                Data."Monthly Targe" := tbBudget.TotalSales;
                //Target This Month

                //Month Sale total
                DateChange := GetFirstDateToDatFilterRange(DateFilter);
                Clear(querry);
                querry.SetFilter(TSE_DivisonFilter, tbDivision.Code);
                querry.SetFilter(TH_DateFilter, DateChange);
                if StoreFilter <> '' then querry.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then querry.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if ProductGroupFilter <> '' then querry.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then querry.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querry.Open;
                while querry.Read do begin
                    Data."Sales Total" := querry.TSE_Total_Amount;
                end;

                Clear(tbBudget);
                tbBudget.SetFilter(Date, DateChange);
                if ProductGroupFilter <> '' then
                    tbBudget.SetFilter("ClassCode", ProductGroupFilter);
                if tbDivision.Code <> '' then
                    tbBudget.SetFilter("DivisionCode", tbDivision.Code);
                if StoreFilter <> '' then
                    tbBudget.SetFilter("StoreNo", StoreFilter);
                tbBudget.CalcSums(TotalSales);

                Data."Daily Target Total" := tbBudget.TotalSales;
                //Month Sale total

                Data."Balance(Sale-Target)" := Data."Sales Total" - Data."Daily Target Total";

                //Daily Sale
                Clear(querry);
                querry.SetFilter(TSE_DivisonFilter, tbDivision.Code);
                querry.SetRange(TH_DateFilter, DateFilter);
                if StoreFilter <> '' then querry.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then querry.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if ProductGroupFilter <> '' then querry.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then querry.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querry.Open;
                while querry.Read do begin
                    Data."Daily Sales" := querry.TSE_Total_Amount;
                end;

                Clear(tbBudget);
                tbBudget.SetRange(Date, DateFilter);
                if ProductGroupFilter <> '' then
                    tbBudget.SetFilter("ClassCode", ProductGroupFilter);
                if tbDivision.Code <> '' then
                    tbBudget.SetFilter("DivisionCode", tbDivision.Code);
                if StoreFilter <> '' then
                    tbBudget.SetFilter("StoreNo", StoreFilter);
                tbBudget.CalcSums(TotalSales);

                Data."Daily Target" := tbBudget.TotalSales;
                //Daily Sale

                //Last year Sale
                DateChange := GetLastYearDateRange(DateFilter);
                Clear(querry);
                querry.SetFilter(TSE_DivisonFilter, tbDivision.Code);
                querry.SetFilter(TH_DateFilter, DateChange);
                if StoreFilter <> '' then querry.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then querry.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if ProductGroupFilter <> '' then querry.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then querry.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querry.Open;
                while querry.Read do begin
                    Data."Last Year Sales" := querry.TSE_Total_Amount;
                end;
                //Last year Sale

                if data."Daily Target" <> 0 then
                    data."Acv Daily Target Total" := (data."Daily Sales" / data."Daily Target") * 100;

                Data.Insert();
                //Amount-----------------------------------------------------------------------------------------------------------------------------

                //Custumer--------------------------------------------------------------------------------------------------------------------------
                Clear(Data);
                Data."Divison" := tbDivision.Description;
                Data."TypeTemp" := 'Customer';
                Data."Monthly Targe" := 0;
                Data."Daily Target Total" := 0;
                Data."Balance(Sale-Target)" := Data."Daily Target Total" - Data."Sales Total";
                data."Acv Daily Target Total" := 0;
                data."Daily Target" := 0;

                //Sale total
                DateChange := GetFirstDateToDatFilterRange(DateFilter);

                Data."Sales Total" := 0;
                LastReceipt := '';
                Clear(querryCustomer);
                querryCustomer.SetFilter(TSE_DivisionFilter, tbDivision.Code);
                querryCustomer.SetFilter(TH_DateFilter, DateChange);
                if StoreFilter <> '' then querryCustomer.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then querryCustomer.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if ProductGroupFilter <> '' then querryCustomer.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then querryCustomer.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querryCustomer.Open;
                while querryCustomer.Read do begin
                    if querryCustomer.Receipt_No_ <> LastReceipt then begin
                        Data."Sales Total" += 1;
                        LastReceipt := querryCustomer.Receipt_No_;
                    end;
                end;

                Data."Balance(Sale-Target)" := Data."Sales Total" - Data."Daily Target Total";

                //Daily Sale
                Data."Daily Sales" := 0;
                LastReceipt := '';
                Clear(querryCustomer);
                querryCustomer.SetFilter(TSE_DivisionFilter, tbDivision.Code);
                querryCustomer.SetRange(TH_DateFilter, DateFilter);
                if StoreFilter <> '' then querryCustomer.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then querryCustomer.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if ProductGroupFilter <> '' then querryCustomer.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then querryCustomer.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querryCustomer.Open;
                while querryCustomer.Read do begin
                    if querryCustomer.Receipt_No_ <> LastReceipt then begin
                        Data."Daily Sales" += 1;
                        LastReceipt := querryCustomer.Receipt_No_;
                    end;
                end;

                //Last year Sale
                DateChange := GetLastYearDateRange(DateFilter);
                Data."Last Year Sales" := 0;
                LastReceipt := '';
                Clear(querryCustomer);
                querryCustomer.SetFilter(TSE_DivisionFilter, tbDivision.Code);
                querryCustomer.SetFilter(TH_DateFilter, DateChange);
                if StoreFilter <> '' then querryCustomer.SetFilter(TH_StoreFilter, StoreFilter);
                if SpecialGroupFilter <> '' then querryCustomer.SetFilter(TSE_SpecialGroupFilter, SpecialGroupFilter);
                if ProductGroupFilter <> '' then querryCustomer.SetFilter(TSE_ProductGroupFilter, ProductGroupFilter);
                if PosTerminalFilter <> '' then querryCustomer.SetFilter(PosTerminalFilter, PosTerminalFilter);
                querryCustomer.Open;
                while querryCustomer.Read do begin
                    if querryCustomer.Receipt_No_ <> LastReceipt then begin
                        Data."Last Year Sales" += 1;
                        LastReceipt := querryCustomer.Receipt_No_;
                    end;
                end;

                Data.Insert();
            //Custumer--------------------------------------------------------------------------------------------------------------------------
            until tbDivision.Next() = 0;
        end;
    end;

    trigger OnInitReport()
    begin

    end;

    procedure GetFirstDateToDatFilterRange(InputDate: Date): Text
    var
        StartDate: Date;
        EndDate: Date;
        MonthOfInput: Integer;
        YearOfInput: Integer;
    begin
        // Lấy tháng và năm từ ngày được nhập
        MonthOfInput := DATE2DMY(InputDate, 2); // part 2 = tháng
        YearOfInput := DATE2DMY(InputDate, 3);  // part 3 = năm

        // Ngày bắt đầu là 01/tháng/năm
        StartDate := DMY2DATE(1, MonthOfInput, YearOfInput);

        // Ngày kết thúc là ngày nhập
        EndDate := InputDate;

        // Trả về chuỗi định dạng "01/04/25..22/04/25"
        exit(Format(StartDate) + '..' + Format(EndDate));
    end;

    procedure GetLastYearDateRange(InputDate: Date): Text
    var
        LastYear: Integer;
        StartDate: Date;
        EndDate: Date;
    begin
        // Lấy năm từ ngày nhập vào, sau đó trừ 1 để ra năm trước
        LastYear := DATE2DMY(InputDate, 3) - 1;

        // Tạo ngày đầu năm và cuối năm của năm trước
        StartDate := DMY2DATE(1, 1, LastYear);       // 01/01/LastYear
        EndDate := DMY2DATE(31, 12, LastYear);       // 31/12/LastYear

        // Trả về chuỗi định dạng "01/01/24..31/12/24"
        exit(Format(StartDate) + '..' + Format(EndDate));
    end;

    procedure GetMonthRangeAsText(InputDate: Date): Text
    var
        StartDate: Date;
        EndDate: Date;
    begin
        GetMonthStartAndEndDate(InputDate, StartDate, EndDate);
        exit(Format(StartDate) + '..' + Format(EndDate));
    end;

    procedure GetMonthStartAndEndDate(InputDate: Date; var StartDate: Date; var EndDate: Date)
    begin
        StartDate := DMY2Date(1, Date2DMY(InputDate, 2), Date2DMY(InputDate, 3));
        EndDate := CalcDate('<CM>', StartDate);
    end;

    var
        StatementNoFilter: Text;
        DateFilter: Date;
        StoreFilter: Text;
        PosTerminalFilter: Text;
        DivisionFilter: Text;
        SpecialGroupFilter: Text;
        ProductGroupFilter: Text;
        ApplicationManagement: Codeunit "Filter Tokens";
}
