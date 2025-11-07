table 58056 "Store KPI"
{
    Access = Internal;
    Caption = 'Store KPI';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "STT"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'STT';
        }
        field(2; "Time"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Time';
        }
        field(3; "Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(4; "TypeDetail"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'TypeDetail';
        }
        field(5; "Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Value';
        }
    }
    keys
    {
        key(PK; "STT")
        {
            Clustered = true;
        }
    }
}



report 70034 "Store KPI Report"
{
    ApplicationArea = All;
    Caption = 'Store KPI Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = StoreKPIReportExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Data; "Store KPI")
        {
            column(USERID; UserId) { }
            column(COMPANYNAME; CompanyName) { }
            column(DatePrint; DatePrint) { }
            column(DateFilter; DateFilter) { }
            column(Time; Time) { }
            column(Type; Type) { }
            column(TypeDetail; TypeDetail) { }
            column(Value; Value) { }
            column(STT; STT) { }

            trigger OnAfterGetRecord()
            begin
            end;

            trigger OnPreDataItem()
            var
                MonthRanges: List of [Text];
                RangeText: Text;
                MonthStart, MonthEnd : Date;
                MonthStartFull, MonthEndFull : Date;
                MonthStartFullLY, MonthEndFullLY : Date;
                MonthStartPreviousYear, MonthEndPreviousYear : Date;
                RecNo: Integer;
                querSaleTotal: Query "QueOnlySaleHeaderOutRice";
                LastReceipt: text;
                quTotalMember: Query "QueCustumerReportCount";
                QueDiscountTransSale: Query "QueDiscountTransSale";
                QueProfitDirect: Query "QueryProfitDirect";

                totalNetMount: Decimal;
                countingTrans: Decimal;
                totalQty: Decimal;
                monthText: Text;
            begin
                Clear(RecNo);
                Clear(Data);
                DateFilter := 'From ' + Format(FromDateFilter) + ' To ' + Format(ToDateFilter);
                DatePrint := Format(CurrentDateTime());

                MonthRanges := GenerateMonthlyRanges(FromDateFilter, ToDateFilter);

                // Lặp qua từng khoảng
                foreach RangeText in MonthRanges do begin
                    Evaluate(MonthStart, CopyStr(RangeText, 1, StrPos(RangeText, '..') - 1));
                    Evaluate(MonthEnd, CopyStr(RangeText, StrPos(RangeText, '..') + 2));
                    GetPreviousYearRange(MonthStart, MonthEnd, MonthStartPreviousYear, MonthEndPreviousYear);
                    GetFullYearRange(FromDateFilter, ToDateFilter, MonthStartFull, MonthEndFull);
                    GetFullYearRange(MonthStartPreviousYear, MonthEndPreviousYear, MonthStartFullLY, MonthEndFullLY);
                    monthText := GetMonthYearText(MonthStart);

                    //-- FULL PRICE TY --- 
                    RecNo += 1;//VALUE
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '1. FULL PRICE TY';
                    Data."TypeDetail" := '1. VALUE';
                    Clear(querSaleTotal);
                    querSaleTotal.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    if StoreFilter <> '' then querSaleTotal.SetRange("TH_StoreFilter", StoreFilter);
                    querSaleTotal.Open;
                    while querSaleTotal.Read do begin
                        Data.Value := querSaleTotal.SumGrossAmount;
                    end;
                    Data.Insert();

                    RecNo += 1;//QTY
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '1. FULL PRICE TY';
                    Data."TypeDetail" := '2. QTY';
                    Clear(querSaleTotal);
                    querSaleTotal.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    if StoreFilter <> '' then querSaleTotal.SetRange("TH_StoreFilter", StoreFilter);
                    querSaleTotal.Open;
                    while querSaleTotal.Read do begin
                        Data.Value := querSaleTotal.SumSaleItem;
                    end;
                    Data.Insert();

                    RecNo += 1;//UAP
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '1. FULL PRICE TY';
                    Data."TypeDetail" := '3. UAP';
                    Clear(querSaleTotal);
                    querSaleTotal.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    if StoreFilter <> '' then querSaleTotal.SetRange("TH_StoreFilter", StoreFilter);
                    querSaleTotal.Open;
                    while querSaleTotal.Read do begin
                        if querSaleTotal.SumSaleItem <> 0 then
                            Data.Value := querSaleTotal.SumGrossAmount / querSaleTotal.SumSaleItem
                        else
                            Data.Value := 0;
                    end;
                    Data.Insert();

                    //-- SALE TY --- 
                    RecNo += 1;//VALUE
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '2. SALE TY';
                    Data."TypeDetail" := '1. VALUE';
                    Clear(QueProfitDirect);
                    QueProfitDirect.SetFilter("TH_DateFilter", '%1..%2', MonthStart, MonthEnd);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        Data.Value := QueProfitDirect.TSE_Net_Amount;
                        totalNetMount := Data.Value;
                    end;
                    Data.Insert();

                    RecNo += 1;//QTY
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '2. SALE TY';
                    Data."TypeDetail" := '2. QTY';
                    Clear(QueProfitDirect);
                    QueProfitDirect.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        Data.Value := QueProfitDirect.TSE_Quantity_Amount;
                        totalQty := Data.Value;
                    end;
                    Data.Insert();

                    RecNo += 1;//TRANS
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '2. SALE TY';
                    Data."TypeDetail" := '3.TRANS';
                    Data.Value := 0;
                    LastReceipt := '';
                    Clear(querSaleTotal);
                    querSaleTotal.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    if StoreFilter <> '' then querSaleTotal.SetFilter(TH_StoreFilter, StoreFilter);
                    querSaleTotal.Open;
                    while querSaleTotal.Read do begin
                        if querSaleTotal.Receipt_No_ <> LastReceipt then begin
                            Data.Value += 1;
                            LastReceipt := querSaleTotal.Receipt_No_;
                        end;
                    end;
                    countingTrans := Data.Value;
                    Data.Insert();

                    RecNo += 1;//% to TTL
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '2. SALE TY';
                    Data."TypeDetail" := '4. % to TTL';

                    Clear(QueProfitDirect);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    QueProfitDirect.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        Data.Value := QueProfitDirect.TSE_Net_Amount;
                    end;

                    Clear(QueProfitDirect);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    QueProfitDirect.SetRange("TH_DateFilter", MonthStartFull, MonthEndFull);
                    if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        if QueProfitDirect.TSE_Net_Amount <> 0 then
                            Data.Value := Data.Value / QueProfitDirect.TSE_Net_Amount
                        else
                            Data.Value := 0;
                    end;

                    Data.Insert();

                    RecNo += 1;//COST
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '2. SALE TY';
                    Data."TypeDetail" := '5. COST';
                    Clear(QueProfitDirect);
                    QueProfitDirect.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    if StoreFilter <> '' then QueProfitDirect.SetFilter(TH_StoreFilter, StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        if QueProfitDirect.TSE_Cost_Amount <> 0 then
                            Data.Value := QueProfitDirect.TSE_Cost_Amount
                        else
                            Data.Value := 0;
                    End;
                    Data.Insert();

                    RecNo += 1;//PROFIT
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '2. SALE TY';
                    Data."TypeDetail" := '6. PROFIT';
                    Clear(QueProfitDirect);
                    QueProfitDirect.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    if StoreFilter <> '' then QueProfitDirect.SetFilter(TH_StoreFilter, StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        Data.Value := QueProfitDirect.TSE_Net_Amount - QueProfitDirect.TSE_Cost_Amount
                    End;
                    Data.Insert();

                    RecNo += 1;//MARGIN
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '2. SALE TY';
                    Data."TypeDetail" := '7. MARGIN';
                    Clear(QueProfitDirect);
                    QueProfitDirect.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    if StoreFilter <> '' then QueProfitDirect.SetFilter(TH_StoreFilter, StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        Data.Value := (QueProfitDirect.TSE_Net_Amount - QueProfitDirect.TSE_Cost_Amount) / QueProfitDirect.TSE_Net_Amount;
                    End;
                    Data.Insert();

                    RecNo += 1;//TY/LY
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '2. SALE TY';
                    Data."TypeDetail" := '8. TY/LY';

                    Clear(QueProfitDirect);
                    QueProfitDirect.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        Data.Value := QueProfitDirect.TSE_Net_Amount;
                    end;

                    Clear(QueProfitDirect);
                    QueProfitDirect.SetRange("TH_DateFilter", MonthStartPreviousYear, MonthEndPreviousYear);
                    QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                    if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                    QueProfitDirect.Open;
                    while QueProfitDirect.Read do begin
                        if QueProfitDirect.TSE_Net_Amount <> 0 then
                            Data.Value := Data.Value / QueProfitDirect.TSE_Net_Amount
                        else
                            Data.Value := 0;
                    end;
                    Data.Insert();

                    //-- DISCOUNT TY --- 
                    RecNo += 1;//VALUE
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '3. DISCOUNT TY';
                    Data."TypeDetail" := '1. VALUE';
                    Clear(QueDiscountTransSale);
                    QueDiscountTransSale.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    QueDiscountTransSale.SetFilter("DiscountAmountFilter", '<>0');
                    if StoreFilter <> '' then QueDiscountTransSale.SetRange("TH_StoreFilter", StoreFilter);
                    QueDiscountTransSale.Open;
                    while QueDiscountTransSale.Read do begin
                        Data.Value := Abs(QueDiscountTransSale.SumDiscountAmount);
                    end;
                    Data.Insert();

                    RecNo += 1;//QTY
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '3. DISCOUNT TY';
                    Data."TypeDetail" := '2. QTY';
                    Clear(QueDiscountTransSale);
                    QueDiscountTransSale.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    QueDiscountTransSale.SetFilter("DiscountAmountFilter", '<>0');
                    if StoreFilter <> '' then QueDiscountTransSale.SetRange("TH_StoreFilter", StoreFilter);
                    QueDiscountTransSale.Open;
                    while QueDiscountTransSale.Read do begin
                        Data.Value := QueDiscountTransSale.SumSaleItem;
                    end;
                    Data.Insert();

                    RecNo += 1;//UAP
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '3. DISCOUNT TY';
                    Data."TypeDetail" := '3. UAP';
                    Clear(QueDiscountTransSale);
                    QueDiscountTransSale.SetRange("TH_DateFilter", MonthStart, MonthEnd);
                    QueDiscountTransSale.SetFilter("DiscountAmountFilter", '<>0');
                    if StoreFilter <> '' then QueDiscountTransSale.SetRange("TH_StoreFilter", StoreFilter);
                    QueDiscountTransSale.Open;
                    while QueDiscountTransSale.Read do begin
                        if QueDiscountTransSale.SumDiscountAmount <> 0 then
                            Data.Value := ABS(QueDiscountTransSale.SumDiscountAmount / QueDiscountTransSale.SumDiscountAmount)
                        else
                            Data.Value := 0;
                    end;
                    Data.Insert();

                    //-- STORE KPI --- 
                    RecNo += 1;//ADT
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '4. STORE KPI';
                    Data."TypeDetail" := '1. ADT';
                    if countingTrans <> 0 then
                        Data.Value := totalNetMount / countingTrans
                    else
                        Data.Value := 0;
                    Data.Insert();

                    RecNo += 1;//AUP
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '4. STORE KPI';
                    Data."TypeDetail" := '2. AUP';
                    if totalQty <> 0 then
                        Data.Value := totalNetMount / totalQty
                    else
                        Data.Value := 0;
                    Data.Insert();

                    RecNo += 1;//UPT
                    Data.Init();
                    Data."STT" := RecNo;
                    Data."Time" := monthText;
                    Data."Type" := '4. STORE KPI';
                    Data."TypeDetail" := '3. UPT';
                    if countingTrans <> 0 then
                        Data.Value := totalQty / countingTrans
                    else
                        Data.Value := 0;
                    Data.Insert();
                end;

                //-- SALE LY --- 
                RecNo += 1;//VALUE
                Data.Init();
                Data."STT" := RecNo;
                Data."Time" := monthText;
                Data."Type" := '5. SALE LY';
                Data."TypeDetail" := '1. VALUE';
                Clear(QueProfitDirect);
                QueProfitDirect.SetRange("TH_DateFilter", MonthStartPreviousYear, MonthEndPreviousYear);
                QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                QueProfitDirect.Open;
                while QueProfitDirect.Read do begin
                    Data.Value := QueProfitDirect.TSE_Net_Amount;
                end;
                Data.Insert();

                RecNo += 1;//VALUE
                Data.Init();
                Data."STT" := RecNo;
                Data."Time" := monthText;
                Data."Type" := '5. SALE LY';
                Data."TypeDetail" := '2. QTY';
                Clear(QueProfitDirect);
                QueProfitDirect.SetRange("TH_DateFilter", MonthStartPreviousYear, MonthEndPreviousYear);
                QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                QueProfitDirect.Open;
                while QueProfitDirect.Read do begin
                    Data.Value := QueProfitDirect.TSE_Net_Amount;
                end;
                Data.Insert();

                RecNo += 1;//UAP
                Data.Init();
                Data."STT" := RecNo;
                Data."Time" := monthText;
                Data."Type" := '5. SALE LY';
                Data."TypeDetail" := '3. UAP';
                Clear(QueProfitDirect);
                QueProfitDirect.SetRange("TH_DateFilter", MonthStartPreviousYear, MonthEndPreviousYear);
                QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                QueProfitDirect.Open;
                while QueProfitDirect.Read do begin
                    if QueProfitDirect.TSE_Net_Amount <> 0 then
                        Data.Value := QueProfitDirect.TSE_Net_Amount / QueProfitDirect.TSE_Quantity_Amount
                    else
                        Data.Value := 0;
                end;
                Data.Insert();

                RecNo += 1;//% to TTL
                Data.Init();
                Data."STT" := RecNo;
                Data."Time" := monthText;
                Data."Type" := '5. SALE LY';
                Data."TypeDetail" := '4. % to TTL';

                Clear(QueProfitDirect);
                QueProfitDirect.SetRange("TH_DateFilter", MonthStartPreviousYear, MonthEndPreviousYear);
                QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                QueProfitDirect.Open;
                while QueProfitDirect.Read do begin
                    Data.Value := QueProfitDirect.TSE_Net_Amount;
                end;

                Clear(QueProfitDirect);
                QueProfitDirect.SetRange("TH_DateFilter", MonthStartFullLY, MonthEndFullLY);
                QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                if StoreFilter <> '' then QueProfitDirect.SetRange("TH_StoreFilter", StoreFilter);
                QueProfitDirect.Open;
                while QueProfitDirect.Read do begin
                    if QueProfitDirect.TSE_Net_Amount <> 0 then
                        Data.Value := Data.Value / QueProfitDirect.TSE_Net_Amount
                    else
                        Data.Value := 0;
                end;
                Data.Insert();
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
                    field("FromDate"; FromDateFilter)
                    {
                    }
                    field("ToDate"; ToDateFilter)
                    {
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
        layout(StoreKPIReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70034.StoreKPIReportExcel.xlsx';
            Caption = 'Store KPI Report Excel';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70034.StoreKPIReportExcel.xlsx';
        }
    }

    procedure GetMonthYearText(InputDate: Date): Text
    var
        MonthName: Text;
        YearText: Text;
    begin
        // Lấy tên tháng theo ngôn ngữ hệ thống (ví dụ: October)
        MonthName := FORMAT(InputDate, 0, '<Month Text>');

        // Lấy năm
        YearText := Format(DATE2DMY(InputDate, 3));

        exit(StrSubstNo('%1 %2', MonthName, YearText)); // Kết quả: October 2025
    end;

    trigger OnPreReport()
    begin

    end;

    procedure GenerateMonthlyRanges(FromDate: Date; ToDate: Date): List of [Text]
    var
        FirstOfMonth, LastOfMonth : Date;
        MonthStart, MonthEnd : Date;
        MonthText: Text;
        Ranges: List of [Text];
    begin
        if (FromDate = 0D) or (ToDate = 0D) then
            exit(Ranges); // Trả về rỗng nếu thiếu tham số

        // Lấy ngày đầu tháng của FromDate
        FirstOfMonth := DMY2Date(1, Date2DMY(FromDate, 2), Date2DMY(FromDate, 3));
        // Lấy ngày cuối tháng của ToDate
        LastOfMonth := CalcDate('<CM>', ToDate);

        MonthStart := FirstOfMonth;
        repeat
            // Ngày cuối của tháng hiện tại
            MonthEnd := CalcDate('<CM>', MonthStart);

            // Nếu vượt quá ToDate thì chỉnh lại cho khớp cuối khoảng
            if MonthEnd > ToDate then
                MonthEnd := ToDate;

            // Format thành chuỗi “dd/MM/yyyy..dd/MM/yyyy”
            MonthText :=
                Format(MonthStart, 0, '<Day,2>/<Month,2>/<Year4>') + '..' +
                Format(MonthEnd, 0, '<Day,2>/<Month,2>/<Year4>');

            Ranges.Add(MonthText);

            // Sang tháng tiếp theo
            MonthStart := CalcDate('+1M', MonthStart);
        until MonthStart > LastOfMonth;

        exit(Ranges);
    end;


    procedure GetPreviousYearRange(CurrentFromDate: Date; CurrentToDate: Date; var PrevFromDate: Date; var PrevToDate: Date)
    var
        FromDay, FromMonth, FromYear : Integer;
        ToDay, ToMonth, ToYear : Integer;
    begin
        // Lấy ngày, tháng, năm của FromDate
        FromDay := Date2DMY(CurrentFromDate, 1);
        FromMonth := Date2DMY(CurrentFromDate, 2);
        FromYear := Date2DMY(CurrentFromDate, 3);

        // Lấy ngày, tháng, năm của ToDate
        ToDay := Date2DMY(CurrentToDate, 1);
        ToMonth := Date2DMY(CurrentToDate, 2);
        ToYear := Date2DMY(CurrentToDate, 3);

        // Giảm năm đi 1
        FromYear := FromYear - 1;
        ToYear := ToYear - 1;

        // Tạo lại ngày tháng năm của năm trước
        PrevFromDate := DMY2Date(FromDay, FromMonth, FromYear);
        PrevToDate := DMY2Date(ToDay, ToMonth, ToYear);
    end;

    procedure GetFullYearRange(FromDate: Date; ToDate: Date; var FromDateYear: Date; var ToDateYear: Date)
    var
        Year: Integer;
    begin
        if (FromDate = 0D) and (ToDate = 0D) then
            Error('FromDate và ToDate không được để trống.');

        // Lấy năm từ FromDate nếu có, nếu không thì lấy từ ToDate
        if FromDate <> 0D then
            Year := Date2DMY(FromDate, 3)
        else
            Year := Date2DMY(ToDate, 3);

        // Xác định đầu và cuối năm đó
        FromDateYear := DMY2Date(1, 1, Year);
        ToDateYear := DMY2Date(31, 12, Year);
    end;

    var
        FromDateFilter: Date;
        ToDateFilter: Date;
        DivisionFilter: Text[100];
        ApplicationManagement: Codeunit "Filter Tokens";
        lbText: text[100];
        lbTime: text[100];
        DateFilter: text[100];
        DatePrint: text[100];
        StoreFilter: text[100];
}
