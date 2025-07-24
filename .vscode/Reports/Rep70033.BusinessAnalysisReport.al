
table 58059 "BusinessAnalysisReport"
{
    Access = Internal;
    Caption = 'BusinessAnalysisReport';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Type"; Text[500])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(2; "Sales Price Aggregate"; Decimal)
        {
            Caption = 'Sales Price Aggregate';
            DataClassification = ToBeClassified;
        }
        field(3; "Sales Cost Aggregate"; Decimal)
        {
            Caption = 'Sales Cost Aggregate';
            DataClassification = ToBeClassified;
        }
        field(4; "Quantity Aggregate"; Decimal)
        {
            Caption = 'Quantity Aggregate';
            DataClassification = ToBeClassified;
        }
        field(5; "Gross Profit Aggregate"; Decimal)
        {
            Caption = 'Quantity Aggregate';
            DataClassification = ToBeClassified;
        }
        field(6; "GP Ratio Aggregate"; Decimal)
        {
            Caption = 'GP Ratio Aggregate';
            DataClassification = ToBeClassified;
        }
        field(7; "Discount Aggregate"; Decimal)
        {
            Caption = 'Discount Aggregate';
            DataClassification = ToBeClassified;
        }
        field(8; "Customers Aggregate"; Decimal)
        {
            Caption = 'Customers Aggregate';
            DataClassification = ToBeClassified;
        }
        field(9; "Customer Unit Aggregate"; Decimal)
        {
            Caption = 'Customer Unit Aggregate';
            DataClassification = ToBeClassified;
        }

        field(10; "Sales Price PS Purchase"; Decimal)
        {
            Caption = 'Sales Price PS Purchase';
            DataClassification = ToBeClassified;
        }

        field(11; "Gross Profit PS Purchase"; Decimal)
        {
            Caption = 'Gross Profit PS Purchase';
            DataClassification = ToBeClassified;
        }
        field(12; "GP Ratio PS Purchase"; Decimal)
        {
            Caption = 'GP Ratio PS Purchase';
            DataClassification = ToBeClassified;
        }
        field(13; "Sales Price PS Consignment"; Decimal)
        {
            Caption = 'Sales Price PS Consignment';
            DataClassification = ToBeClassified;
        }
        field(14; "Gross Profit PS Consignment"; Decimal)
        {
            Caption = 'Gross Profit PS Consignment';
            DataClassification = ToBeClassified;
        }
        field(15; "GP Ratio PS Consignment"; Decimal)
        {
            Caption = 'GP Ratio PS Consignment';
            DataClassification = ToBeClassified;
        }
    }
}


report 70033 "BusinessAnalysisReport"
{
    ApplicationArea = All;
    Caption = 'BusinessAnalysisReport';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70033.BusinessAnalysisReport.rdl';
    dataset
    {
        dataitem(tbResuft; "BusinessAnalysisReport")
        {
            column(Type; Type)
            {
            }
            column(CustomerUnitAggregate_tbResuft; "Customer Unit Aggregate")
            {
            }
            column(CustomersAggregate_tbResuft; "Customers Aggregate")
            {
            }
            column(DiscountAggregate_tbResuft; "Discount Aggregate")
            {
            }
            column(GPRatioAggregate_tbResuft; "GP Ratio Aggregate")
            {
            }
            column(GPRatioPSConsignment_tbResuft; "GP Ratio PS Consignment")
            {
            }
            column(GPRatioPSPurchase_tbResuft; "GP Ratio PS Purchase")
            {
            }
            column(GrossProfitAggregate_tbResuft; "Gross Profit Aggregate")
            {
            }
            column(GrossProfitPSConsignment_tbResuft; "Gross Profit PS Consignment")
            {
            }
            column(GrossProfitPSPurchase_tbResuft; "Gross Profit PS Purchase")
            {
            }
            column(QuantityAggregate_tbResuft; "Quantity Aggregate")
            {
            }
            column(SalesCostAggregate_tbResuft; "Sales Cost Aggregate")
            {
            }
            column(SalesPriceAggregate_tbResuft; "Sales Price Aggregate")
            {
            }
            column(SalesPricePSConsignment_tbResuft; "Sales Price PS Consignment")
            {
            }
            column(SalesPricePSPurchase_tbResuft; "Sales Price PS Purchase")
            {
            }
            column(SystemCreatedAt_tbResuft; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy_tbResuft; SystemCreatedBy)
            {
            }
            column(SystemId_tbResuft; SystemId)
            {
            }
            column(SystemModifiedAt_tbResuft; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy_tbResuft; SystemModifiedBy)
            {
            }


            trigger OnPreDataItem()
            var
                querSaleTotal: Query "QueSaleProduct";
                querSaleTotal2: Query "QueSaleProduct";

                DateFormat: Text[100];
            begin
                //Aggregate----------------------------------------
                Clear(tbResuft);
                tbResuft.Type := 'Results';

                Clear(querSaleTotal);
                querSaleTotal.SetFilter("TH_DateFilter", DateFilter);
                if StoreFilter <> '' then querSaleTotal.SetRange("TH_StoreFilter", StoreFilter);
                if PosTerminalFilter <> '' then querSaleTotal.SetRange("PosterminalFilter", PosTerminalFilter);
                querSaleTotal.Open;
                while querSaleTotal.Read do begin
                    tbResuft."Sales Price Aggregate" := querSaleTotal.SumGrossAmount;
                    tbResuft."Sales Cost Aggregate" := querSaleTotal.SumCostAmount;
                    tbResuft."Quantity Aggregate" := querSaleTotal.CountSaleItem;
                    tbResuft."Gross Profit Aggregate" := querSaleTotal.SumGrossAmount - querSaleTotal.SumCostAmount;
                    tbResuft."GP Ratio Aggregate" := querSaleTotal.SumGrossAmount / (querSaleTotal.SumGrossAmount - querSaleTotal.SumCostAmount);
                    tbResuft."Discount Aggregate" := querSaleTotal.SumDiscountAmount;
                    tbResuft."Customers Aggregate" := querSaleTotal.CountTransaction;
                    tbResuft."Customer Unit Aggregate" := 0;//NA
                    tbResuft.Insert();
                end;

                Clear(tbResuft);
                tbResuft.Type := 'Last Year Ratio';

                DateFormat := GetPreviousYearDateRange(DateFilter);
                Clear(querSaleTotal2);
                querSaleTotal2.SetFilter("TH_DateFilter", DateFormat);
                if StoreFilter <> '' then querSaleTotal2.SetRange("TH_StoreFilter", StoreFilter);
                if PosTerminalFilter <> '' then querSaleTotal2.SetRange("PosterminalFilter", PosTerminalFilter);
                querSaleTotal2.Open;
                while querSaleTotal2.Read do begin
                    tbResuft."Sales Price Aggregate" := querSaleTotal.SumGrossAmount / querSaleTotal2.SumGrossAmount;
                    tbResuft."Sales Cost Aggregate" := querSaleTotal.SumCostAmount / querSaleTotal2.SumCostAmount;
                    tbResuft."Quantity Aggregate" := querSaleTotal.CountSaleItem / querSaleTotal2.CountSaleItem;
                    tbResuft."Gross Profit Aggregate" := (querSaleTotal.SumGrossAmount - querSaleTotal.SumCostAmount) / (querSaleTotal2.SumGrossAmount - querSaleTotal2.SumCostAmount);
                    tbResuft."GP Ratio Aggregate" := (querSaleTotal.SumGrossAmount / (querSaleTotal.SumGrossAmount - querSaleTotal.SumCostAmount)) /
                    (querSaleTotal2.SumGrossAmount / (querSaleTotal2.SumGrossAmount - querSaleTotal2.SumCostAmount));
                    tbResuft."Discount Aggregate" := querSaleTotal.SumDiscountAmount / querSaleTotal2.SumDiscountAmount;
                    tbResuft."Customers Aggregate" := querSaleTotal.CountTransaction / querSaleTotal2.CountTransaction;
                    tbResuft."Customer Unit Aggregate" := 0;//NA
                    tbResuft.Insert();
                end;

                Clear(tbResuft);
                tbResuft.Type := 'Budget Ratio';
                tbResuft."Sales Price Aggregate" := 0;
                tbResuft."Sales Cost Aggregate" := 0;
                tbResuft."Quantity Aggregate" := 0;
                tbResuft."Gross Profit Aggregate" := 0;
                tbResuft."GP Ratio Aggregate" := 0;
                tbResuft."Discount Aggregate" := 0;
                tbResuft."Customers Aggregate" := 0;
                tbResuft."Customer Unit Aggregate" := 0;//NA
                tbResuft.Insert();

                //Sales Of Purchase Style ----------------------------------------
                Clear(tbResuft);
                tbResuft.Type := 'Results';
                tbResuft."Sales Price PS Purchase" := 0;
                tbResuft."Gross Profit PS Purchase" := 0;
                tbResuft."GP Ratio PS Purchase" := 0;
                tbResuft."Sales Price PS Consignment" := 0;
                tbResuft."Gross Profit PS Consignment" := 0;
                tbResuft."GP Ratio PS Consignment" := 0;
                tbResuft.Insert();

                Clear(tbResuft);
                tbResuft.Type := 'Last Year Ratio';
                tbResuft."Gross Profit PS Purchase" := 0;
                tbResuft."Gross Profit PS Purchase" := 0;
                tbResuft."GP Ratio PS Purchase" := 0;
                tbResuft."Sales Price PS Consignment" := 0;
                tbResuft."Gross Profit PS Consignment" := 0;
                tbResuft."GP Ratio PS Consignment" := 0;
                tbResuft.Insert();

                Clear(tbResuft);
                tbResuft.Type := 'Budget Ratio';
                tbResuft."Gross Profit PS Purchase" := 0;
                tbResuft."Gross Profit PS Purchase" := 0;
                tbResuft."GP Ratio PS Purchase" := 0;
                tbResuft."Sales Price PS Consignment" := 0;
                tbResuft."Gross Profit PS Consignment" := 0;
                tbResuft."GP Ratio PS Consignment" := 0;
                tbResuft.Insert();
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
                group(GroupName)
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
        actions
        {
            area(Processing)
            {
            }
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
        DateFilter: Text;
        DateFormat: Text[100];
        StoreFilter: Text;
        PosTerminalFilter: Text;
        ApplicationManagement: Codeunit "Filter Tokens";


    procedure GetPreviousYearDateRange(CurrentRange: Text): Text
    var
        FromText, ToText : Text;
        FromDate, ToDate : Date;
        NewFromDate, NewToDate : Date;
        NewFromText, NewToText : Text;
        SeparatorPos: Integer;
    begin
        // Tách chuỗi theo dấu ..
        SeparatorPos := StrPos(CurrentRange, '..');
        if SeparatorPos = 0 then
            Error('Chuỗi không đúng định dạng');

        FromText := CopyStr(CurrentRange, 1, SeparatorPos - 1);
        ToText := CopyStr(CurrentRange, SeparatorPos + 2);

        // Chuyển từ text sang date
        Evaluate(FromDate, FromText);
        Evaluate(ToDate, ToText);

        // Trừ 1 năm
        NewFromDate := CalcDate('-1Y', FromDate);
        NewToDate := CalcDate('-1Y', ToDate);

        // Định dạng lại ngày
        NewFromText := Format(NewFromDate, 0, '<Day,2>/<Month,2>/<Year,2>');
        NewToText := Format(NewToDate, 0, '<Day,2>/<Month,2>/<Year,2>');

        // Ghép lại thành chuỗi mới
        exit(NewFromText + '..' + NewToText);
    end;

}
