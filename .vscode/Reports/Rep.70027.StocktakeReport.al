table 58051 "Stock Take Report"
{
    Access = Internal;
    Caption = 'Stock Take Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {

        field(1; "BrandName"; Text[500])
        {
            Caption = 'BrandName';
            DataClassification = ToBeClassified;
        }
        field(2; "GroupField"; Text[500])
        {
            Caption = 'GroupField';
            DataClassification = ToBeClassified;
        }
        field(3; "On system"; Decimal)
        {
            Caption = 'On system';
            DataClassification = ToBeClassified;
        }
        field(4; "On hand"; Decimal)
        {
            Caption = 'On hand';
            DataClassification = ToBeClassified;
        }
        field(5; "Variance"; Decimal)
        {
            Caption = 'Variance';
            DataClassification = ToBeClassified;
        }
        field(6; "Total Sale"; Decimal)
        {
            Caption = 'Total Sale';
            DataClassification = ToBeClassified;
        }
        field(11; "%Lost/ Gain"; Decimal)
        {
            Caption = '%Lost/ Gain';
            DataClassification = ToBeClassified;
        }
        field(12; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(13; "ItemNo"; Text[500])
        {
            Caption = 'ItemNo';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "ItemNo", GroupField)
        {
            Clustered = true;
        }
    }
}


report 70027 "Stock Take Report"
{
    ApplicationArea = All;
    Caption = 'Stock Take Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = StockTakeReportExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Data; "Stock Take Report")
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
            column(DateFilter; DateFilterText) { }
            column(MonthFilter; lbTime) { }
            column(PeriodsTotalSale; lbText) { }
            column(ItemNo; "ItemNo") { }
            column(BrandName; "BrandName") { }
            column(GroupField; "GroupField") { }
            column(Onsystem; "On system") { }
            column(OnHand; "On hand") { }
            column(Variance; "Variance") { }
            column(TotalSale; "Total Sale") { }
            column(LostGain; "%Lost/ Gain") { }

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                IF (DateFilter = 0D) THEN
                    ERROR('The report couldn’t be generated, because the DateFilter is empty.');

                CreateData();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Stock Take Report Excel';
        AboutText = 'AboutText Stock Take Report Excel';
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field("Date"; DateFilter)
                    {

                    }
                    field("Store No"; StoreFilter)
                    {
                        TableRelation = "LSC Store"."No.";
                    }
                    field("Brand No."; BrandFilter)
                    {
                        TableRelation = "LSC Item Special Groups";
                    }
                    field("Item"; ItemFilter)
                    {
                        TableRelation = "Item";
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
        layout(StockTakeReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70027.StockTakeReportExcel.xlsx';
            Caption = 'Stock Take Report';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70027.StockTakeReportExcel.xlsx';
        }
    }

    trigger OnPreReport()
    begin

    end;

    procedure CreateData()
    var
        totalAmount: Decimal;
        tbItem: Record "Item";
        tbItemTotalSale: Record "Item";
        tbSpecialGroup: Record "LSC Item/Special Group Link";
        tbSpecialGroupValue: Record "LSC Item Special Groups";
        RetailPriceUtils: Codeunit "LSC Retail Price Utils";
        RetailSetup: Record "LSC Retail Setup";
        PriceListLineTemp: Record "Price List Line" temporary;

        InputYear: Integer;
        StartDate: date;
        EndDate: date;
        BrandName: text[100];
        Window: Dialog;
        Counter: Integer;
    begin
        clear(Data);
        Data.DeleteAll();

        Counter := 0;
        Window.Open(
              'Number of Item #1###########\' +
              'Processed              #2###########');

        clear(tbItem);
        if DateFilter <> 0D then tbItem.SetRange("Date Filter", DateFilter);
        if StoreFilter <> '' then tbItem.SetFilter("LSC Store Filter", StoreFilter);
        if BrandFilter <> '' then tbItem.SetFilter("LSC Special Group Code", BrandFilter);
        if ItemFilter <> '' then tbItem.SetFilter("No.", ItemFilter);
        if tbItem.FindSet() then begin
            repeat
                Counter += 1;
                if (Counter mod 100) = 0 then
                    Window.Update(2, Counter);

                Clear(InputYear);
                Clear(DateFilterText);
                Clear(lbTime);
                Clear(StartDate);
                Clear(EndDate);
                Clear(lbText);
                clear(DatePrint);

                InputYear := Date2DMY(DateFilter, 3); // Lấy năm
                DateFilterText := StrSubstNo('Print Date: %1', FORMAT(DateFilter, 0, '<Day,2>/<Month,2>/<Year4>'));
                DatePrint := StrSubstNo('Target Date: %1', FORMAT(Today(), 0, '<Day,2>/<Month,2>/<Year4>'));
                lbTime := StrSubstNo('%1.%2', Format(DateFilter, 0, '<Month Text>'), InputYear);

                if (DateFilter > DMY2Date(1, 12, InputYear - 1)) and (DateFilter <= DMY2Date(1, 5, InputYear)) then begin
                    // Ngày đầu tháng 12 năm hiện tại
                    StartDate := DMY2Date(1, 12, InputYear - 1);
                    // Ngày đầu tháng 5 năm sau
                    EndDate := DMY2Date(1, 5, InputYear);

                    lbText := StrSubstNo('Total Sale: Dec %1 - May %2', InputYear - 1, InputYear);
                end else begin
                    // Ngày đầu tháng 6 năm hiện tại
                    StartDate := DMY2Date(1, 6, InputYear);
                    // Ngày đầu tháng 11 năm hiện tại
                    EndDate := DMY2Date(1, 11, InputYear);

                    lbText := StrSubstNo('Total Sale: Jun %1 - Nov %2', InputYear, InputYear);
                end;

                Clear(tbSpecialGroup);
                tbSpecialGroup.SetRange("Item No.", tbItem."No.");
                if tbSpecialGroup.FindFirst() then begin
                    Clear(tbSpecialGroupValue);
                    tbSpecialGroupValue.SetRange("Code", tbSpecialGroup."Special Group Code");
                    if tbSpecialGroupValue.FindFirst() then
                        BrandName := tbSpecialGroupValue."Description";
                end;

                clear(tbItemTotalSale);
                tbItemTotalSale.SetRange("No.", tbItem."No.");
                if DateFilter <> 0D then tbItemTotalSale.SetRange("Date Filter", StartDate, EndDate);
                if StoreFilter <> '' then tbItemTotalSale.SetFilter("LSC Store Filter", StoreFilter);
                if BrandFilter <> '' then tbItemTotalSale.SetFilter("LSC Special Group Code", BrandFilter);
                tbItemTotalSale.FindSet();
                tbItemTotalSale.CalcFields("Sales (Qty.)", "Sales (LCY)");

                //Quantity
                clear(Data);
                Data.GroupField := 'Quantity';
                Data.ItemNo := tbItem."No.";
                Data.BrandName := BrandName;
                tbItem.CalcFields(Inventory);

                Data."Total Sale" := tbItemTotalSale."Sales (Qty.)";
                Data."On system" := tbItem.Inventory;
                Data."On hand" := 0;
                Data."Variance" := 0;
                Data.Insert(true);
                //Quantity

                //Sale total
                clear(Data);
                Data.GroupField := 'Retail Price';
                Data.ItemNo := tbItem."No.";
                Data.BrandName := BrandName;
                tbItem.CalcFields(Inventory);
                Data."Total Sale" := tbItemTotalSale."Sales (LCY)";

                Clear(PriceListLineTemp);
                // RetailPriceUtils.GetRetailSalesPrice(tbItem."No.", RetailSetup."Default Price Group", Today(), '', '', '', PriceListLineTemp);
                RetailPriceUtils.GetItemPrice(RetailSetup."Default Price Group", tbItem."No.", '', DateFilter, '', PriceListLineTemp, '');
                Data."On system" := tbItem.Inventory * PriceListLineTemp."Unit Price";
                Data."On hand" := 0;
                Data."Variance" := 0;
                Data.Insert(true);
            //Sale total

            until tbItem.next = 0;
        end;
    end;

    var
        ItemFilter: Text[100];
        BrandFilter: Text[100];
        DateFilter: Date;
        StoreFilter: Text[100];
        ApplicationManagement: Codeunit "Filter Tokens";
        lbText: text[100];
        lbTime: text[100];
        DateFilterText: text[100];
        DatePrint: text[100];

}