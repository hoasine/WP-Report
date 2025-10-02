table 58052 "AnP Report"
{
    Access = Internal;
    Caption = 'AnP Table';
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
        field(4; "SaleTMTY"; Decimal)
        {
            Caption = 'SaleTMTY';
            DataClassification = ToBeClassified;
        }
        field(5; "SaleTMLY"; Decimal)
        {
            Caption = 'SaleTMLY';
            DataClassification = ToBeClassified;
        }
        field(6; "SaleTYMTD"; Decimal)
        {
            Caption = 'SaleTYMTD';
            DataClassification = ToBeClassified;
        }
        field(7; "SaleLYMTD"; Decimal)
        {
            Caption = 'SaleLYMTD';
            DataClassification = ToBeClassified;
        }
        field(8; "Type"; Text[500])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Division", "Category", "Product Group", "Type")
        {
            Clustered = true;
        }
    }
}

table 58053 "AnP Payment"
{
    Access = Internal;
    Caption = 'AnP Payment';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Tender Type"; Text[500])
        {
            Caption = 'Tender Type';
            DataClassification = ToBeClassified;
        }
        field(2; "Periods"; Text[500])
        {
            Caption = 'Periods';
            DataClassification = ToBeClassified;
        }
        field(3; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(4; "Type"; Text[500])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Tender Type", "Periods", "Type")
        {
            Clustered = true;
        }
    }
}


report 70028 "AnP Report"
{
    ApplicationArea = All;
    Caption = 'AnP Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = AnPReportExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Data; "AnP Report")
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
            column(SaleTMTY; SaleTMTY) { }
            column(SaleTMLY; SaleTMLY) { }
            column(SaleTYMTD; SaleTYMTD) { }
            column(SaleLYMTD; SaleLYMTD) { }
            column(Type; Type) { }

            trigger OnAfterGetRecord()

            begin


            end;

            trigger OnPreDataItem()

            var
                quTotalSaleMember: Query "LSC Sale With Member";
                tbDivision: Record "LSC Division";
                tbItemCate: Record "Item Category";
                tbProuctGroup: Record "LSC Retail Product Group";
                tbTransHeader: Record "LSC Transaction Header";
                tbTransSale: Record "LSC Trans. Sales Entry";

                InputYear: Integer;
                StartDate: date;
                EndDate: date;

                InputYearDate: Date;
                StartDateText: Text;
                thangnamtruocText: text[100];
            begin
                IF (DateFilter = '') THEN
                    ERROR('The report couldn’t be generated, because the DateFilter is empty.');

                clear(tbDivision);
                tbDivision.SetFilter(Code, '<>%1&<>%2', '04', '');
                if DivisionFilter <> '' then tbDivision.SetRange(Code, DivisionFilter);
                if tbDivision.FindSet() then begin
                    repeat
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

                                        //-------------MEMBER-------------------------
                                        Clear(Data);
                                        Data.Type := 'Total Member Sale';
                                        Data."Division" := tbDivision.Code + ' - ' + tbDivision.Description;
                                        Data."Category" := tbItemCate.Code + ' - ' + tbItemCate.Description;
                                        Data."Product Group" := tbProuctGroup.Code + ' - ' + tbProuctGroup.Description;

                                        //Lay trong thanhg
                                        Clear(quTotalSaleMember);
                                        quTotalSaleMember.SetFilter(TH_DateFilter, DateFilter);//01/08/2025 - 31/08/2025
                                        quTotalSaleMember.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '<>%1', '');
                                        quTotalSaleMember.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quTotalSaleMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                                        quTotalSaleMember.Open;
                                        while quTotalSaleMember.Read do begin
                                            Data.SaleTMTY := quTotalSaleMember.TSE_Total_Amount;
                                        end;
                                        //Lay trong thanhg

                                        //Lay trong thang năm truoc
                                        thangnamtruocText := GetLastYearDateRange(DateFilter);//01/08/2024 - 31/08/2024

                                        Clear(quTotalSaleMember);
                                        quTotalSaleMember.SetFilter(TH_DateFilter, thangnamtruocText);
                                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '<>%1', '');
                                        quTotalSaleMember.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quTotalSaleMember.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quTotalSaleMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                                        quTotalSaleMember.Open;
                                        while quTotalSaleMember.Read do begin
                                            Data.SaleTMLY := quTotalSaleMember.TSE_Total_Amount;
                                        end;
                                        //Lay trong thang năm truoc

                                        //Lay last nam
                                        thangnamtruocText := GetYearStartToGivenEndDate(DateFilter);//01/01/2025 - 31/08/2025

                                        Clear(quTotalSaleMember);
                                        quTotalSaleMember.SetFilter(TH_DateFilter, thangnamtruocText);
                                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '<>%1', '');
                                        quTotalSaleMember.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quTotalSaleMember.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quTotalSaleMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                                        quTotalSaleMember.Open;
                                        while quTotalSaleMember.Read do begin
                                            Data.SaleTYMTD := quTotalSaleMember.TSE_Total_Amount;
                                        end;
                                        //Lay last nam

                                        //Lay last nam ngoái
                                        thangnamtruocText := GetLastYearDateRangeYear(thangnamtruocText);//01/01/2024 - 31/08/2024

                                        Clear(quTotalSaleMember);
                                        quTotalSaleMember.SetFilter(TH_DateFilter, thangnamtruocText);
                                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '<>%1', '');
                                        quTotalSaleMember.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quTotalSaleMember.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quTotalSaleMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                                        quTotalSaleMember.Open;
                                        while quTotalSaleMember.Read do begin
                                            Data.SaleLYMTD := quTotalSaleMember.TSE_Total_Amount;
                                        end;
                                        //Lay last nam ngoái

                                        Data.Insert(true);
                                        //-------------MEMBER-------------------------

                                        //-------------NON MEMBER-------------------------
                                        Clear(Data);
                                        Data.Type := 'Total Non-Member Sale';
                                        Data."Division" := tbDivision.Code + ' - ' + tbDivision.Description;
                                        Data."Category" := tbItemCate.Code + ' - ' + tbItemCate.Description;
                                        Data."Product Group" := tbProuctGroup.Code + ' - ' + tbProuctGroup.Description;

                                        //Lay trong thanhg
                                        Clear(quTotalSaleMember);
                                        quTotalSaleMember.SetFilter(TH_DateFilter, DateFilter);
                                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '=%1', '');
                                        quTotalSaleMember.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quTotalSaleMember.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quTotalSaleMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                                        quTotalSaleMember.Open;
                                        while quTotalSaleMember.Read do begin
                                            Data.SaleTMTY := quTotalSaleMember.TSE_Total_Amount;
                                        end;
                                        //Lay trong thanhg

                                        //Lay trong thang năm truoc
                                        thangnamtruocText := GetLastYearDateRange(DateFilter);

                                        Clear(quTotalSaleMember);
                                        quTotalSaleMember.SetFilter(TH_DateFilter, thangnamtruocText);
                                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '=%1', '');
                                        quTotalSaleMember.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quTotalSaleMember.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quTotalSaleMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                                        quTotalSaleMember.Open;
                                        while quTotalSaleMember.Read do begin
                                            Data.SaleTMLY := quTotalSaleMember.TSE_Total_Amount;
                                        end;
                                        //Lay trong thang năm truoc

                                        //Lay last nam
                                        thangnamtruocText := GetYearStartToGivenEndDate(DateFilter);

                                        Clear(quTotalSaleMember);
                                        quTotalSaleMember.SetFilter(TH_DateFilter, thangnamtruocText);
                                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '=%1', '');
                                        quTotalSaleMember.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quTotalSaleMember.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quTotalSaleMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                                        quTotalSaleMember.Open;
                                        while quTotalSaleMember.Read do begin
                                            Data.SaleTYMTD := quTotalSaleMember.TSE_Total_Amount;
                                        end;
                                        //Lay last nam

                                        //Lay last nam ngoái
                                        thangnamtruocText := GetLastYearDateRangeYear(thangnamtruocText);

                                        Clear(quTotalSaleMember);
                                        quTotalSaleMember.SetFilter(TH_DateFilter, thangnamtruocText);
                                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '=%1', '');
                                        quTotalSaleMember.SetFilter(TSE_DivisonFilter, format(tbDivision.Code));
                                        quTotalSaleMember.SetFilter(TSE_CateagoryFilter, format(tbItemCate.Code));
                                        quTotalSaleMember.SetFilter(TSE_ProductGroupFilter, format(tbProuctGroup.Code));
                                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                                        quTotalSaleMember.Open;
                                        while quTotalSaleMember.Read do begin
                                            Data.SaleLYMTD := quTotalSaleMember.TSE_Total_Amount;
                                        end;
                                        //Lay last nam ngoái

                                        Data.Insert(true);
                                    //------------- NON MEMBER-------------------------

                                    until tbProuctGroup.Next() = 0;
                                end;
                            until tbItemCate.Next() = 0;
                        end;
                    until tbDivision.Next() = 0;
                end;
            end;
        }

        dataitem(Detail; "AnP Payment")
        {
            column(TenderType; "Tender Type") { }
            column(Periods; Periods) { }
            column(Amount; "Amount") { }
            column(TypeDetail; Type) { }

            trigger OnAfterGetRecord()
            begin


            end;

            trigger OnPreDataItem()
            var
                queryCardEntry: Query "QuePosCardEntry";
                tbTender: Record "LSC Tender Type Setup";
                quTotalSaleMember: Query "CalSaleWithTenderTypeMember";
                timeChange: Text[100];
            begin
                clear(tbTender);
                tbTender.SetFilter(Code, '<>%1', '');

                if tbTender.FindSet() then begin
                    repeat
                        //-----------------------MEMBER
                        //TMTY
                        Clear(Detail);
                        Detail."Tender Type" := tbTender.Description;
                        Detail."Type" := 'Member Type';
                        Detail."Periods" := '1. TMTY';

                        if (tbTender."Code" <> '3') then begin
                            Clear(quTotalSaleMember);
                            quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '<>%1', '');
                            quTotalSaleMember.SetFilter(TH_DateFilter, DateFilter);
                            quTotalSaleMember.SetFilter(TenderFilter, tbTender.Code);
                            if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));
                            quTotalSaleMember.Open;
                            while quTotalSaleMember.Read do begin
                                Detail.Amount := -quTotalSaleMember.TSE_Total_Amount;
                            end;

                            Clear(queryCardEntry);
                            queryCardEntry.SetFilter("TH_DateFilter", DateFilter);
                            queryCardEntry.SetRange("TSE_Tender", '3');
                            queryCardEntry.SetRange("TSE_Tender_PointFilter", tbTender."Code");
                            if StoreFilter <> '' then queryCardEntry.SetRange("TH_StoreFilter", StoreFilter);
                            queryCardEntry.Open;
                            while queryCardEntry.Read do begin
                                Detail.Amount += queryCardEntry.TSE_Amount_Card_Entry;
                            end;
                        end else begin
                            Clear(queryCardEntry);
                            queryCardEntry.SetFilter("TH_DateFilter", DateFilter);
                            queryCardEntry.SetRange("TSE_Tender", '3');
                            queryCardEntry.SetRange("TSE_Tender_PointFilter", '');
                            if StoreFilter <> '' then queryCardEntry.SetRange("TH_StoreFilter", StoreFilter);
                            queryCardEntry.Open;
                            while queryCardEntry.Read do begin
                                Detail.Amount += queryCardEntry.TSE_Amount_Card_Entry;
                            end;

                            Detail."Tender Type" := 'No Name';
                        end;

                        Detail.Insert();
                        //TMTY

                        //TMTY
                        timeChange := GetLastYearDateRange(DateFilter);

                        Clear(Detail);
                        Detail."Tender Type" := tbTender.Description;
                        Detail."Type" := 'Member Type';
                        Detail."Periods" := '2. TMLY';

                        if (tbTender."Code" <> '3') then begin
                            Clear(quTotalSaleMember);
                            quTotalSaleMember.SetFilter(TH_DateFilter, timeChange);
                            quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '<>%1', '');
                            quTotalSaleMember.SetFilter(TenderFilter, tbTender.Code);
                            if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                            quTotalSaleMember.Open;
                            while quTotalSaleMember.Read do begin
                                Detail.Amount := quTotalSaleMember.TSE_Total_Amount;
                            end;

                            Clear(queryCardEntry);
                            queryCardEntry.SetFilter("TH_DateFilter", timeChange);
                            queryCardEntry.SetRange("TSE_Tender", '3');
                            queryCardEntry.SetRange("TSE_Tender_PointFilter", tbTender."Code");
                            if StoreFilter <> '' then queryCardEntry.SetRange("TH_StoreFilter", StoreFilter);
                            queryCardEntry.Open;
                            while queryCardEntry.Read do begin
                                Detail.Amount += queryCardEntry.TSE_Amount_Card_Entry;
                            end;
                        end else begin
                            Clear(queryCardEntry);
                            queryCardEntry.SetFilter("TH_DateFilter", timeChange);
                            queryCardEntry.SetRange("TSE_Tender", '3');
                            queryCardEntry.SetRange("TSE_Tender_PointFilter", '');
                            if StoreFilter <> '' then queryCardEntry.SetRange("TH_StoreFilter", StoreFilter);
                            queryCardEntry.Open;
                            while queryCardEntry.Read do begin
                                Detail.Amount += queryCardEntry.TSE_Amount_Card_Entry;
                            end;

                            Detail."Tender Type" := 'No Name';
                        end;

                        Detail.Insert();
                        //TMTY

                        //TYMTD
                        timeChange := GetYearStartToGivenEndDate(DateFilter);

                        Clear(Detail);
                        Detail."Tender Type" := tbTender.Description;
                        Detail."Type" := 'Member Type';
                        Detail."Periods" := '3. TYMTD';

                        Clear(quTotalSaleMember);
                        quTotalSaleMember.SetFilter(TH_DateFilter, timeChange);
                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '<>%1', '');
                        quTotalSaleMember.SetFilter(TenderFilter, tbTender.Code);
                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                        quTotalSaleMember.Open;
                        while quTotalSaleMember.Read do begin
                            Detail.Amount := -quTotalSaleMember.TSE_Total_Amount;
                        end;

                        Detail.Insert();
                        //TYMTD

                        //LYMTD 
                        timeChange := GetLastYearDateRangeYear(timeChange);

                        Clear(Detail);
                        Detail."Tender Type" := tbTender.Description;
                        Detail."Periods" := '4. LYMTD';
                        Detail."Type" := 'Member Type';

                        Clear(quTotalSaleMember);
                        quTotalSaleMember.SetFilter(TH_DateFilter, timeChange);
                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '<>%1', '');
                        quTotalSaleMember.SetFilter(TenderFilter, tbTender.Code);
                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                        quTotalSaleMember.Open;
                        while quTotalSaleMember.Read do begin
                            Detail.Amount := -quTotalSaleMember.TSE_Total_Amount;
                        end;

                        Detail.Insert();
                        //LYMTD 
                        //-----------------------MEMBER

                        //-----------------------NOn MEMBER
                        //TMTY
                        Clear(Detail);
                        Detail."Tender Type" := tbTender.Description;
                        Detail."Type" := 'Non Member Type';
                        Detail."Periods" := '1. TMTY';

                        Clear(quTotalSaleMember);
                        quTotalSaleMember.SetFilter(TH_DateFilter, DateFilter);
                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '=%1', '');
                        quTotalSaleMember.SetFilter(TenderFilter, tbTender.Code);
                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                        quTotalSaleMember.Open;
                        while quTotalSaleMember.Read do begin
                            Detail.Amount := -quTotalSaleMember.TSE_Total_Amount;
                        end;

                        Detail.Insert();
                        //TMTY

                        //TMTY
                        timeChange := GetLastYearDateRange(DateFilter);

                        Clear(Detail);
                        Detail."Tender Type" := tbTender.Description;
                        Detail."Type" := 'Non Member Type';
                        Detail."Periods" := '2. TMLY';

                        Clear(quTotalSaleMember);
                        quTotalSaleMember.SetFilter(TH_DateFilter, timeChange);
                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '=%1', '');
                        quTotalSaleMember.SetFilter(TenderFilter, tbTender.Code);
                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                        quTotalSaleMember.Open;
                        while quTotalSaleMember.Read do begin
                            Detail.Amount := -quTotalSaleMember.TSE_Total_Amount;
                        end;

                        Detail.Insert();
                        //TMTY

                        //TYMTD
                        timeChange := GetYearStartToGivenEndDate(DateFilter);

                        Clear(Detail);
                        Detail."Tender Type" := tbTender.Description;
                        Detail."Type" := 'Non Member Type';
                        Detail."Periods" := '3. TYMTD';

                        Clear(quTotalSaleMember);
                        quTotalSaleMember.SetFilter(TH_DateFilter, timeChange);
                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '=%1', '');
                        quTotalSaleMember.SetFilter(TenderFilter, tbTender.Code);
                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                        quTotalSaleMember.Open;
                        while quTotalSaleMember.Read do begin
                            Detail.Amount := -quTotalSaleMember.TSE_Total_Amount;
                        end;

                        Detail.Insert();
                        //TYMTD

                        //LYMTD 
                        timeChange := GetLastYearDateRangeYear(timeChange);

                        Clear(Detail);
                        Detail."Tender Type" := tbTender.Description;
                        Detail."Periods" := '4. LYMTD';
                        Detail."Type" := 'Non Member Type';

                        Clear(quTotalSaleMember);
                        quTotalSaleMember.SetFilter(TH_DateFilter, timeChange);
                        quTotalSaleMember.SetFilter(TH_Member_Card_No_Filter, '=%1', '');
                        quTotalSaleMember.SetFilter(TenderFilter, tbTender.Code);
                        if StoreFilter <> '' then quTotalSaleMember.SetFilter(TH_StoreFilter, format(StoreFilter));

                        quTotalSaleMember.Open;
                        while quTotalSaleMember.Read do begin
                            Detail.Amount := -quTotalSaleMember.TSE_Total_Amount;
                        end;

                        Detail.Insert();
                    //LYMTD 
                    //-----------------------MEMBER

                    until tbTender.Next() = 0;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'AnP Report Excel';
        AboutText = 'AboutText AnP Report Excel';
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
        layout(AnPReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70028.AnPReportExcel.xlsx';
            Caption = 'AnP Report Excel';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70028.AnPReportExcel.xlsx';
        }
    }

    trigger OnPreReport()
    begin

    end;

    //DDooir sang nawm truoc do
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

        SaleTMTY: Decimal;
        SaleTMLY: Decimal;
        SaleTYMTD: Decimal;
        SaleLYMTD: Decimal;
        StoreFilter: text[100];
}