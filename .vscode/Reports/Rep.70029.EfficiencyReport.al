table 58054 "Efficiency Report"
{
    Access = Internal;
    Caption = 'Stock Take Report';
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
        field(4; "AREASIZE"; Decimal)
        {
            Caption = 'AREASIZE';
            DataClassification = ToBeClassified;
        }
        field(5; "PROFIT"; Decimal)
        {
            Caption = 'PROFIT';
            DataClassification = ToBeClassified;
        }
        field(6; "SALE"; Decimal)
        {
            Caption = 'SALE';
            DataClassification = ToBeClassified;
        }
        field(7; "Periods"; Text[100])
        {
            Caption = 'Periods';
            DataClassification = ToBeClassified;
        }
        field(9; "Brand"; Text[100])
        {
            Caption = 'Brand';
            DataClassification = ToBeClassified;
        }
        field(10; "MGP"; Decimal)
        {
            Caption = 'MGP';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Division", "Category", "Product Group", Periods, Brand)
        {
            Clustered = true;
        }
    }
}

report 70029 "Efficiency Report"
{
    ApplicationArea = All;
    Caption = 'Efficiency Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = EfficiencyReportExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Data; "Efficiency Report")
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
            column(Division; "Division") { }
            column(Class; "Product Group") { }
            column(Department; "Category") { }
            column(Brand; "Brand") { }
            column(AREASIZE; AREASIZE) { }
            column(SALE; SALE) { }
            column(PROFIT; PROFIT) { }
            column(Periods; Periods) { }
            column(MGP; MGP) { }

            trigger OnAfterGetRecord()

            begin


            end;

            trigger OnPreDataItem()

            var
                quEfficiency: Query "QueEfficiency";
                quEfficiencyLY: Query "QueEfficiency";
                tbDivision: Record "LSC Division";
                tbItemCate: Record "Item Category";
                tbProuctGroup: Record "LSC Retail Product Group";
                tbSpecialGroup: Record "LSC Item/Special Group Link";
                tbTransHeader: Record "LSC Transaction Header";
                tbTransSale: Record "Consignment Entries";

                // DivisionInt: Integer;
                // ProductGroupInt: Integer;
                // CategoryInt: Integer;

                InputYear: Integer;
                StartDate: date;
                EndDate: date;

                InputYearDate: Date;
                StartDateText: Text;
                thangnamtruocText: text[100];

                HasData: Boolean;
                Window: Dialog;
                TotalTrans: Integer;
                Counter: Integer;
            begin
                IF (DateFilter = '') THEN
                    ERROR('The report couldn’t be generated, because the DateFilter is empty.');

                Window.Open(
                    'Number of Transactions #1###########\' +
                    'Processed              #2###########');

                clear(tbDivision);
                tbDivision.SetFilter(Code, '<>%1', '');
                if DivisionFilter <> '' then tbDivision.SetRange(Code, DivisionFilter);
                if tbDivision.FindSet() then begin
                    repeat
                        Counter += 1;
                        if (Counter mod 100) = 0 then
                            Window.Update(2, Counter);


                        clear(tbItemCate);
                        tbItemCate.SetRange("LSC Division Code", tbDivision.Code);
                        if tbItemCate.FindSet() then begin
                            repeat
                                clear(tbProuctGroup);
                                tbProuctGroup.SetRange("Item Category Code", tbItemCate.Code);
                                if tbProuctGroup.FindSet() then begin
                                    repeat
                                        ParseDateRange(DateFilter, StartDate, EndDate);
                                        StartDateFilter := FORMAT(StartDate, 0, '<Day,2>/<Month,2>/<Year4>');
                                        EndDateFilter := FORMAT(EndDate, 0, '<Day,2>/<Month,2>/<Year4>');
                                        DatePrint := FORMAT(Today(), 0, '<Day,2>/<Month,2>/<Year4>');

                                        // Evaluate(DivisionInt, tbDivision.Code);
                                        // Evaluate(CategoryInt, tbItemCate.Code);
                                        // Evaluate(ProductGroupInt, tbProuctGroup.Code);

                                        //Lay trong thanhg
                                        Clear(quEfficiency);
                                        quEfficiency.SetFilter(TH_DateFilter, DateFilter);
                                        quEfficiency.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quEfficiency.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quEfficiency.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        quEfficiency.Open;

                                        HasData := false;
                                        while quEfficiency.Read do begin
                                            HasData := true;
                                            Clear(Data);
                                            Data.Periods := ConvertDateToMonthYearFormat(StartDateFilter);
                                            Data."Division" := tbDivision.Code + ' - ' + tbDivision.Description;
                                            Data."Category" := tbItemCate.Code + ' - ' + tbItemCate.Description;
                                            Data."Product Group" := tbProuctGroup.Code + ' - ' + tbProuctGroup.Description;
                                            Data.AREASIZE := quEfficiency.TSE_Area;
                                            Data.PROFIT := quEfficiency.TSE_Profit;
                                            Data.SALE := quEfficiency.TSE_Total_Sale;
                                            Data.Brand := quEfficiency.Brand;
                                            Data.MGP := quEfficiency.SumMGP;
                                            Data.Insert(true);

                                            //Lay trong thang năm truoc
                                            thangnamtruocText := GetLastYearDateRange(DateFilter);
                                            Clear(quEfficiencyLY);
                                            quEfficiencyLY.SetFilter(TH_DateFilter, thangnamtruocText);
                                            quEfficiencyLY.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                            quEfficiencyLY.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                            quEfficiencyLY.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                            quEfficiencyLY.SetFilter(TSE_BrandFilter, quEfficiency.Brand);
                                            quEfficiencyLY.Open;

                                            HasData := false;
                                            while quEfficiencyLY.Read do begin
                                                if quEfficiencyLY.Brand = quEfficiency.Brand then begin
                                                    HasData := true;
                                                    Clear(Data);
                                                    Data.Periods := ConvertToPreviousYearMonthYearFormat(StartDateFilter);
                                                    Data."Division" := tbDivision.Code + ' - ' + tbDivision.Description;
                                                    Data."Category" := tbItemCate.Code + ' - ' + tbItemCate.Description;
                                                    Data."Product Group" := tbProuctGroup.Code + ' - ' + tbProuctGroup.Description;
                                                    Data.AREASIZE := quEfficiencyLY.TSE_Area;
                                                    Data.PROFIT := quEfficiencyLY.TSE_Profit;
                                                    Data.SALE := quEfficiencyLY.TSE_Total_Sale;
                                                    Data.MGP := quEfficiencyLY.SumMGP;
                                                    Data.Brand := quEfficiencyLY.Brand;
                                                    Data.Insert(true);
                                                end;
                                            End;

                                            if not HasData then begin
                                                Clear(Data);
                                                Data.Periods := ConvertToPreviousYearMonthYearFormat(StartDateFilter);
                                                Data."Division" := tbDivision.Code + ' - ' + tbDivision.Description;
                                                Data."Category" := tbItemCate.Code + ' - ' + tbItemCate.Description;
                                                Data."Product Group" := tbProuctGroup.Code + ' - ' + tbProuctGroup.Description;
                                                Data.Brand := quEfficiency.Brand;
                                                Data.AREASIZE := 0;
                                                Data.PROFIT := 0;
                                                Data.SALE := 0;
                                                Data.MGP := 0;
                                                Data.Insert(true);
                                            End;
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
        AboutTitle = 'Efficiency Report Excel';
        AboutText = 'AboutText Efficiency Report Excel';
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
        layout(EfficiencyReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70029.EfficiencyReportExcel.xlsx';
            Caption = 'Efficiency Report Excel';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70029.EfficiencyReportExcel.xlsx';
        }
    }

    trigger OnPreReport()
    begin

    end;

    procedure GetLastYearDateRange(InputRange: Text): Text
    var
        FromDate: Date;
        ToDate: Date;
        LastYearFromDate: Date;
        LastYearToDate: Date;
        FromDateText: Text[8];
        ToDateText: Text[8];
        Result: Text;
    begin
        // Cắt ngày bắt đầu và ngày kết thúc từ chuỗi: "01/04/25..26/04/25"
        FromDateText := CopyStr(InputRange, 1, 8); // "01/04/25"
        ToDateText := CopyStr(InputRange, StrLen(InputRange) - 7, 8); // "26/04/25"

        // Chuyển chuỗi thành kiểu Date
        Evaluate(FromDate, FromDateText, 0); // Format dd/MM/yy
        Evaluate(ToDate, ToDateText, 0);

        // Lùi 1 năm
        LastYearFromDate := CalcDate('-1Y', FromDate);
        LastYearToDate := CalcDate('-1Y', ToDate);

        // Định dạng lại ngày thành chuỗi dd/MM/yy
        Result := Format(LastYearFromDate, 0, '<Day,2>/<Month,2>/<Year,2>') + '..' +
                  Format(LastYearToDate, 0, '<Day,2>/<Month,2>/<Year,2>');

        exit(Result);
    end;

    //đổi tháng thành đầu năm hiện tại tới ngày cuối nhập vào
    procedure GetYearStartToGivenEndDate(InputRange: Text): Text
    var
        ToDate: Date;
        ToDateText: Text[8];
        YearStartDate: Date;
        YearStartDateText: Text;
        Result: Text;
    begin
        // Cắt ngày kết thúc từ chuỗi: 26/04/25
        ToDateText := CopyStr(InputRange, StrLen(InputRange) - 7, 8);

        // Chuyển đổi ngày kết thúc
        Evaluate(ToDate, ToDateText, 0); // Format dd/MM/yy

        // Tạo ngày bắt đầu của năm hiện tại
        YearStartDate := DMY2Date(1, 1, Date2DMY(ToDate, 3)); // 1/1 của cùng năm

        // Format lại
        YearStartDateText := Format(YearStartDate, 0, '<Day,2>/<Month,2>/<Year,2>');

        // Ghép chuỗi kết quả
        Result := YearStartDateText + '..' + ToDateText;

        exit(Result);
    end;

    procedure GetLastYearDateRangeYear(InputRange: Text): Text
    var
        FromDate: Date;
        ToDate: Date;
        LastYearFromDate: Date;
        LastYearToDate: Date;
        FromDateText: Text[8];
        ToDateText: Text[8];
        Result: Text;
    begin
        // Cắt ngày đầu và ngày cuối từ chuỗi
        FromDateText := CopyStr(InputRange, 1, 8); // "01/01/25"
        ToDateText := CopyStr(InputRange, StrLen(InputRange) - 7, 8); // "26/04/25"

        // Convert chuỗi sang ngày
        Evaluate(FromDate, FromDateText, 0); // Format dd/MM/yy
        Evaluate(ToDate, ToDateText, 0);

        // Lùi 1 năm
        LastYearFromDate := CalcDate('-1Y', FromDate);
        LastYearToDate := CalcDate('-1Y', ToDate);

        // Format lại thành chuỗi dd/MM/yy
        Result := Format(LastYearFromDate, 0, '<Day,2>/<Month,2>/<Year,2>') + '..' +
                  Format(LastYearToDate, 0, '<Day,2>/<Month,2>/<Year,2>');

        exit(Result);
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


    procedure ConvertDateToMonthYearFormat(DateString: Text): Text
    var
        MyDate: Date;
        MonthName: Text;
        YearText: Text;
        DateFormat: TextConst ENU = 'dd/MM/yy';
    begin
        Evaluate(MyDate, DateString, 0); // Format 0 thường là hệ thống tự nhận
        MonthName := Format(MyDate, 0, '<Month Text>'); // "<Month Text>" cho tên tháng tiếng Anh
        YearText := Format(MyDate, 0, '<Year4>'); // "<Year4>" cho 4 chữ số năm
        exit(MonthName + '.' + YearText);
    end;

    procedure ConvertToPreviousYearMonthYearFormat(DateString: Text): Text
    var
        MyDate: Date;
        AdjustedDate: Date;
        MonthName: Text;
        YearText: Text;
    begin
        Evaluate(MyDate, DateString, 0);
        AdjustedDate := CalcDate('-1Y', MyDate); // Giảm 1 năm
        MonthName := Format(AdjustedDate, 0, '<Month Text>');
        YearText := Format(AdjustedDate, 0, '<Year4>');
        exit(MonthName + '.' + YearText);
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

        AREASIZE: Decimal;
        SALE: Decimal;
        PROFIT: Decimal;
}
