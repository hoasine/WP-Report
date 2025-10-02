
table 58059 "BusinessAnalysisReport"
{
    Access = Internal;
    Caption = 'BusinessAnalysisReport';
    DataClassification = CustomerContent;
    // TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Type"; Text[500])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(16; "RowType"; Text[100])
        {
            Caption = 'RowType';
            DataClassification = ToBeClassified;
        }
        field(17; "STT"; Integer)
        {
            Caption = 'STT';
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

        field(10; "Sales Price Purchase"; Decimal)
        {
            Caption = 'Sales Price Purchase';
            DataClassification = ToBeClassified;
        }

        field(11; "Gross Profit Purchase"; Decimal)
        {
            Caption = 'Gross Profit Purchase';
            DataClassification = ToBeClassified;
        }
        field(12; "GP Ratio Purchase"; Decimal)
        {
            Caption = 'GP Ratio Purchase';
            DataClassification = ToBeClassified;
        }
        field(13; "Sales Price Consignment"; Decimal)
        {
            Caption = 'Sales Price Consignment';
            DataClassification = ToBeClassified;
        }
        field(14; "Gross Profit Consignment"; Decimal)
        {
            Caption = 'Gross Profit Consignment';
            DataClassification = ToBeClassified;
        }
        field(15; "GP Ratio Consignment"; Decimal)
        {
            Caption = 'GP Ratio Consignment';
            DataClassification = ToBeClassified;
        }

        field(18; "Consignment Receive"; Decimal)
        {
            Caption = 'Consignment Receive';
            DataClassification = ToBeClassified;
        }
        field(19; "Consignment Return"; Decimal)
        {
            Caption = 'Consignment Return';
            DataClassification = ToBeClassified;
        }
        field(20; "Consignment Net Purchase"; Decimal)
        {
            Caption = 'Consignment Net Purchase';
            DataClassification = ToBeClassified;
        }
        field(21; "TypeDecimal"; Boolean)
        {
            Caption = 'TypeDecimal';
            DataClassification = ToBeClassified;
        }

        field(22; "Quantity Purchase"; Decimal)
        {
            Caption = 'Quantity Purchase';
            DataClassification = ToBeClassified;
        }
        field(23; "Quantity Consignment"; Decimal)
        {
            Caption = 'Quantity Consignment';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "STT", "Type", "RowType")
        {
            Clustered = true;
        }
    }
}


report 70033 "BusinessAnalysisReport"
{
    ApplicationArea = All;
    Caption = 'Business Analysis Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70033.BusinessAnalysisReport.rdl';
    dataset
    {
        dataitem(tbResuft; "BusinessAnalysisReport")
        {
            column(Type; Type)
            {
            }
            column(RowType; RowType)
            {
            }
            column(STT; STT)
            {
            }
            column(DateFilterFormat; DateFilterFormat) { }
            column(CustomerUnitAggregate; "Customer Unit Aggregate")
            {
            }
            column(CustomersAggregate; "Customers Aggregate")
            {
            }
            column(DiscountAggregate; abs("Discount Aggregate"))
            {
            }
            column(GPRatioAggregate; "GP Ratio Aggregate")
            {
            }
            column(GrossProfitAggregate; "Gross Profit Aggregate")
            {
            }
            column(QuantityAggregate; "Quantity Aggregate")
            {
            }
            column(SalesCostAggregate; "Sales Cost Aggregate")
            {
            }
            column(SalesPriceAggregate; "Sales Price Aggregate")
            {
            }
            column(SalesPricePurchase; "Sales Price Purchase")
            {
            }
            column(GrossPurchase; "Gross Profit Purchase")
            {
            }
            column(GPRatioPurchase; "GP Ratio Purchase")
            {
            }
            column(SalesPriceConsignment; "Sales Price Consignment")
            {
            }
            column(GrossProfitConsignment; "Gross Profit Consignment")
            {
            }
            column(GPRatioConsignment; "GP Ratio Consignment")
            {
            }

            column(ConsignmentReceive; "Consignment Receive")
            {
            }
            column(ConsignmentReturn; "Consignment Return")
            {
            }
            column(ConsignmentNetPurchase; "Consignment Net Purchase")
            {
            }
            column(QuantityPurchase; "Quantity Purchase")
            {
            }
            column(QuantityConsignment; "Quantity Consignment")
            {
            }

            column(CustomerUnitAggregateText; CustomerUnitAggregateText)
            {
            }
            column(CustomersAggregateText; CustomersAggregateText)
            {
            }
            column(DiscountAggregateText; DiscountAggregateText)
            {
            }
            column(GPRatioAggregateText; GPRatioAggregateText)
            {
            }
            column(GrossProfitAggregateText; GrossProfitAggregateText)
            {
            }
            column(QuantityAggregateText; "QuantityAggregateText")
            {
            }
            column(SalesCostAggregateText; SalesCostAggregateText)
            {
            }
            column(SalesPriceAggregateText; SalesPriceAggregateText)
            {
            }
            column(SalesPricePurchaseText; SalesPricePurchaseText)
            {
            }
            column(GrossPurchaseText; GrossPurchaseText)
            {
            }
            column(GPRatioPurchaseText; GPRatioPurchaseText)
            {
            }
            column(SalesPriceConsignmentText; SalesPriceConsignmentText)
            {
            }
            column(GrossProfitConsignmentText; GrossProfitConsignmentText)
            {
            }
            column(GPRatioConsignmentText; GPRatioConsignmentText)
            {
            }

            column(ConsignmentReceiveText; ConsignmentReceiveText)
            {
            }
            column(ConsignmentReturnText; ConsignmentReturnText)
            {
            }
            column(ConsignmentNetPurchaseText; ConsignmentNetPurchaseText)
            {
            }
            // column(QuantityPurchaseText; "QuantityPurchaseText")
            // {
            // }
            // column(QuantityConsignmentText; "QuantityConsignmentText")
            // {
            // }

            trigger OnPreDataItem()
            var
                querSaleTotal: Query "QueSaleProduct";
                querSaleTotalLY: Query "QueSaleProduct";
                QueProfitDirect: Query "QueryProfitDirect";
                QueProfitDirectLY: Query "QueryProfitDirect";
                quEfficiency: Query "QueEfficiencyOnlyProfit";
                quEfficiencyLY: Query "QueEfficiencyOnlyProfit";

                querrySaleCons: Query "querrySaleConsignment";
                querrySaleConsReturn: Query "querrySaleConsignment";

                quTotalMember: Query "QueCustumerReportCount";
                quTotalMemberLY: Query "QueCustumerReportCount";
                tbTemp: Record "BusinessAnalysisReport";
                tbTempPurchase: Record "BusinessAnalysisReport";
                // tbBudget: Record "wp Import Budget. Data";


                LastReceipt: text;
                dateLastYear: Text[100];

                NetPurchaseCostRate: Decimal;
            begin
                DateFilterFormat := ParseDateRangeOfFilter(DateFilter);
                //Aggregate----------------------------------------
                tbResuft.DeleteAll();
                dateLastYear := GetPreviousYearDateRange(DateFilter);

                #region Sales Of Purchase Style ----------------------------------------

                Clear(tbResuft);
                tbResuft.Type := 'PurchaseStyle';
                tbResuft.RowType := '1. Results';
                TypeDecimal := false;
                tbResuft.STT := 2;

                Clear(quEfficiency);
                quEfficiency.SetFilter(TH_DateFilter, DateFilter);
                if StoreFilter <> '' then quEfficiency.SetFilter(TH_StoreFilter, StoreFilter);
                quEfficiency.Open;
                while quEfficiency.Read do begin
                    tbResuft."Sales Price Consignment" := quEfficiency.TSE_Total_Sale;
                    tbResuft."Gross Profit Consignment" := quEfficiency.TSE_Profit;
                    if tbResuft."Sales Price Consignment" > 0 then
                        tbResuft."GP Ratio Consignment" := (tbResuft."Gross Profit Consignment" / tbResuft."Sales Price Consignment") * 100;
                End;

                Clear(QueProfitDirect);
                QueProfitDirect.SetFilter(TH_DateFilter, DateFilter);
                QueProfitDirect.SetRange(TSE_TyleSaleFilter, 'OUTR');
                if StoreFilter <> '' then QueProfitDirect.SetFilter(TH_StoreFilter, StoreFilter);
                QueProfitDirect.Open;
                while QueProfitDirect.Read do begin
                    tbResuft."Quantity Purchase" := QueProfitDirect.TSE_Quantity_Amount;
                    tbResuft."Sales Price Purchase" := QueProfitDirect.TSE_Net_Amount;
                    tbResuft."Gross Profit Purchase" := QueProfitDirect.TSE_Net_Amount - QueProfitDirect.TSE_Cost_Amount;
                    if tbResuft."Sales Price Purchase" > 0 then
                        tbResuft."GP Ratio Purchase" := (tbResuft."Gross Profit Purchase" / tbResuft."Sales Price Purchase") * 100;
                End;

                tbResuft.Insert();


                Clear(tbTempPurchase);
                tbTempPurchase.SetRange(Type, 'PurchaseStyle');
                tbTempPurchase.SetRange(RowType, '1. Results');
                tbTempPurchase.FindFirst();

                Clear(tbResuft);
                tbResuft.Type := 'PurchaseStyle';
                tbResuft.RowType := '2. Last Year Ratio';
                TypeDecimal := true;
                tbResuft.STT := 1;

                Clear(quEfficiencyLY);
                quEfficiencyLY.SetFilter(TH_DateFilter, dateLastYear);
                if StoreFilter <> '' then quEfficiencyLY.SetFilter(TH_StoreFilter, StoreFilter);
                quEfficiencyLY.Open;
                while quEfficiencyLY.Read do begin
                    tbResuft."Quantity Consignment" := quEfficiencyLY.TSE_Quantity;

                    if quEfficiencyLY.TSE_Total_Sale > 0 then
                        tbResuft."Sales Price Consignment" := tbTempPurchase."Sales Price Consignment" / quEfficiencyLY.TSE_Total_Sale;

                    if quEfficiencyLY.TSE_Profit > 0 then
                        tbResuft."Gross Profit Consignment" := tbTempPurchase."Gross Profit Consignment" / quEfficiencyLY.TSE_Profit;

                    if tbResuft."Sales Price Consignment" > 0 then
                        tbResuft."GP Ratio Consignment" := tbTempPurchase."GP Ratio Consignment" /
                        (tbResuft."Gross Profit Consignment" / tbResuft."Sales Price Consignment");
                End;

                Clear(QueProfitDirectLY);
                QueProfitDirectLY.SetFilter(TH_DateFilter, dateLastYear);
                QueProfitDirectLY.SetRange(TSE_TyleSaleFilter, 'OUTR');
                if StoreFilter <> '' then QueProfitDirectLY.SetFilter(TH_StoreFilter, StoreFilter);
                QueProfitDirectLY.Open;
                while QueProfitDirectLY.Read do begin
                    if QueProfitDirectLY.TSE_Net_Amount > 0 then
                        tbResuft."Sales Price Purchase" := tbTempPurchase."Sales Price Purchase" / QueProfitDirectLY.TSE_Net_Amount;

                    if QueProfitDirectLY.TSE_Net_Amount - QueProfitDirectLY.TSE_Cost_Amount > 0 then
                        tbResuft."Gross Profit Purchase" := tbTempPurchase."Gross Profit Purchase" /
                         (QueProfitDirectLY.TSE_Net_Amount - QueProfitDirectLY.TSE_Cost_Amount);

                    if tbResuft."Sales Price Purchase" > 0 then
                        tbResuft."GP Ratio Purchase" := tbTempPurchase."GP Ratio Purchase" /
                        (tbResuft."Gross Profit Purchase" / tbResuft."Sales Price Purchase");
                End;

                tbResuft.Insert();

                // Clear(tbResuft);
                // tbResuft.Type := 'PurchaseStyle';
                // tbResuft.RowType := 'Budget Ratio';
                // tbResuft.STT := 1;

                // Clear(tbBudget);
                // tbBudget.SetFilter(Date, DateFilter);
                // if StoreFilter <> '' then
                //     tbBudget.SetFilter("StoreNo", StoreFilter);
                // tbBudget.CalcSums(TotalSales);
                // if tbBudget.TotalSales > 0 then
                //     tbResuft."Sales Price Consignment" := (tbTempPurchase."Sales Price Consignment" / tbBudget.TotalSales) * 100;

                // tbResuft."Gross Profit Consignment" := 0;
                // tbResuft."GP Ratio Consignment" := 0;

                // if tbBudget.TotalSales > 0 then
                //     tbResuft."Sales Price Consignment" := (tbTempPurchase."Sales Price Purchase" / tbBudget.TotalSales) * 100;
                // tbResuft."Gross Profit Purchase" := 0;
                // tbResuft."GP Ratio Purchase" := 0;

                // tbResuft.Insert();

                #endregion

                #region

                Clear(tbResuft);
                tbResuft.Type := 'Aggregate'; //Results---------------------------------
                tbResuft.RowType := '1. Results';
                TypeDecimal := false;
                tbResuft.STT := 1;

                quEfficiency.Open;
                while quEfficiency.Read do begin
                    tbResuft."Sales Price Aggregate" += quEfficiency.TSE_Total_Sale;
                    tbResuft."Quantity Aggregate" += quEfficiency.TSE_Quantity;
                End;
                QueProfitDirect.Open;
                while QueProfitDirect.Read do begin
                    tbResuft."Sales Price Aggregate" += QueProfitDirect.TSE_Net_Amount;
                    tbResuft."Quantity Aggregate" += QueProfitDirect.TSE_Quantity_Amount;
                End;
                quEfficiency.Open;
                while quEfficiency.Read do begin
                    tbResuft."Sales Cost Aggregate" += quEfficiency.TSE_Cost;
                End;
                QueProfitDirect.Open;
                while QueProfitDirect.Read do begin
                    tbResuft."Sales Cost Aggregate" += QueProfitDirect.TSE_Cost_Amount;
                End;

                tbResuft."Gross Profit Aggregate" := tbResuft."Sales Price Aggregate" - tbResuft."Sales Cost Aggregate";
                tbResuft."GP Ratio Aggregate" := ((tbResuft."Sales Price Aggregate" - tbResuft."Sales Cost Aggregate") / tbResuft."Sales Price Aggregate") * 100;

                Clear(querSaleTotal);
                querSaleTotal.SetFilter("TH_DateFilter", DateFilter);
                if StoreFilter <> '' then querSaleTotal.SetRange("TH_StoreFilter", StoreFilter);
                if PosTerminalFilter <> '' then querSaleTotal.SetRange("PosterminalFilter", PosTerminalFilter);
                querSaleTotal.Open;
                while querSaleTotal.Read do begin
                    tbResuft."Discount Aggregate" := querSaleTotal.SumDiscountAmount;
                end;

                tbResuft."Customers Aggregate" := 0;
                LastReceipt := '';
                Clear(quTotalMember);
                quTotalMember.SetFilter(TH_DateFilter, DateFilter);
                if StoreFilter <> '' then quTotalMember.SetFilter(TH_StoreFilter, StoreFilter);
                if PosTerminalFilter <> '' then quTotalMember.SetFilter(PosterminalFilter, PosTerminalFilter);
                quTotalMember.Open;
                while quTotalMember.Read do begin
                    if quTotalMember.Receipt_No_ <> LastReceipt then begin
                        tbResuft."Customers Aggregate" += 1;
                        LastReceipt := quTotalMember.Receipt_No_;
                    end;
                end;

                tbResuft."Customer Unit Aggregate" := tbResuft."Sales Price Aggregate" / tbResuft."Customers Aggregate";//NA
                tbResuft.Insert();


                Clear(tbResuft);
                tbResuft.Type := 'Aggregate'; //Last Year Ratio---------------------------------
                tbResuft.RowType := '2. Last Year Ratio';
                TypeDecimal := true;
                tbResuft.STT := 2;

                Clear(tbTemp);
                tbTemp.SetRange(Type, 'Aggregate');
                tbTemp.SetRange(RowType, '1. Results');
                tbTemp.FindFirst();

                quEfficiencyLY.Open;
                while quEfficiencyLY.Read do begin
                    tbResuft."Sales Price Aggregate" += quEfficiencyLY.TSE_Total_Sale;
                End;

                QueProfitDirectLY.Open;
                while QueProfitDirectLY.Read do begin
                    tbResuft."Sales Price Aggregate" += QueProfitDirectLY.TSE_Net_Amount;
                End;
                if tbResuft."Sales Price Aggregate" > 0 then
                    tbResuft."Sales Price Aggregate" := tbTemp."Sales Price Aggregate" / tbResuft."Sales Price Aggregate";

                quEfficiencyLY.Open;
                while quEfficiencyLY.Read do begin
                    tbResuft."Sales Cost Aggregate" += quEfficiencyLY.TSE_Cost;
                End;

                QueProfitDirectLY.Open;
                while QueProfitDirectLY.Read do begin
                    tbResuft."Sales Cost Aggregate" += QueProfitDirectLY.TSE_Cost_Amount;
                End;
                if tbResuft."Sales Cost Aggregate" > 0 then
                    tbResuft."Sales Cost Aggregate" := tbTemp."Sales Cost Aggregate" / tbResuft."Sales Cost Aggregate";

                if (tbResuft."Sales Price Aggregate" - tbResuft."Sales Cost Aggregate") > 0 then
                    tbResuft."Gross Profit Aggregate" := (tbResuft."Sales Price Aggregate" - tbResuft."Sales Cost Aggregate") / tbTemp."Gross Profit Aggregate";

                if (tbResuft."Sales Price Aggregate" - tbResuft."Sales Cost Aggregate") > 0 then
                    tbResuft."GP Ratio Aggregate" := tbTemp."GP Ratio Aggregate" /
                    (tbResuft."Sales Price Aggregate" / (tbResuft."Sales Price Aggregate" - tbResuft."Sales Cost Aggregate"));

                Clear(querSaleTotalLY);
                querSaleTotalLY.SetFilter("TH_DateFilter", dateLastYear);
                if StoreFilter <> '' then querSaleTotalLY.SetRange("TH_StoreFilter", StoreFilter);
                if PosTerminalFilter <> '' then querSaleTotalLY.SetRange("PosterminalFilter", PosTerminalFilter);
                querSaleTotalLY.Open;
                while querSaleTotalLY.Read do begin
                    if querSaleTotalLY.SumSaleItem > 0 then
                        tbResuft."Quantity Aggregate" := tbTemp."Quantity Aggregate" / querSaleTotalLY.SumSaleItem;
                    if querSaleTotalLY.SumDiscountAmount > 0 then
                        tbResuft."Discount Aggregate" := tbTemp."Discount Aggregate" / querSaleTotalLY.SumDiscountAmount;
                end;

                tbResuft."Customers Aggregate" := 0;
                LastReceipt := '';
                Clear(quTotalMemberLY);
                quTotalMemberLY.SetFilter(TH_DateFilter, dateLastYear);
                if StoreFilter <> '' then quTotalMemberLY.SetFilter(TH_StoreFilter, StoreFilter);
                if PosTerminalFilter <> '' then quTotalMemberLY.SetFilter(PosterminalFilter, PosTerminalFilter);
                quTotalMemberLY.Open;
                while quTotalMemberLY.Read do begin
                    if quTotalMemberLY.Receipt_No_ <> LastReceipt then begin
                        tbResuft."Customers Aggregate" += 1;
                        LastReceipt := quTotalMemberLY.Receipt_No_;
                    end;
                end;
                if tbResuft."Customers Aggregate" > 0 then
                    tbResuft."Customers Aggregate" := tbTemp."Customers Aggregate" / tbResuft."Customers Aggregate";

                if tbResuft."Customers Aggregate" > 0 then
                    tbResuft."Customer Unit Aggregate" := tbResuft."Sales Price Aggregate" / tbResuft."Customers Aggregate";//NA
                tbResuft.Insert();


                // Clear(tbResuft);
                // tbResuft.Type := 'Aggregate';
                // //Target theo tung thang
                // Clear(tbBudget);
                // tbBudget.SetFilter(Date, DateFilter);
                // if StoreFilter <> '' then
                //     tbBudget.SetFilter("StoreNo", StoreFilter);
                // tbBudget.CalcSums(TotalSales);
                // tbResuft.RowType := 'Budget Ratio';
                // tbResuft.STT := 3;
                // if tbBudget.TotalSales > 0 then
                //     tbResuft."Sales Price Aggregate" := (tbTemp."Sales Price Aggregate" / tbBudget.TotalSales) * 100;
                // tbResuft."Sales Cost Aggregate" := 0;
                // tbResuft."Quantity Aggregate" := 0;
                // tbResuft."Gross Profit Aggregate" := 0;
                // tbResuft."GP Ratio Aggregate" := 0;
                // tbResuft."Discount Aggregate" := 0;
                // tbResuft."Customers Aggregate" := 0;
                // tbResuft."Customer Unit Aggregate" := 0;//NA
                // tbResuft.Insert();

                #endregion

                #region Consignment---------------------------------------

                Clear(tbResuft);
                tbResuft.Type := 'Consignment';
                TypeDecimal := false;
                tbResuft.RowType := '1. Cost';
                tbResuft.STT := 1;
                Clear(querrySaleCons);
                querrySaleCons.SetFilter(TH_DateFilter, DateFilter);
                querrySaleCons.SetFilter(TSE_TypeTransFilter, '>0');
                if StoreFilter <> '' then querrySaleCons.SetFilter(TH_StoreFilter, StoreFilter);
                querrySaleCons.Open;
                while querrySaleCons.Read do begin
                    tbResuft."Consignment Receive" := querrySaleCons.TSE_Cost;
                End;
                Clear(querrySaleConsReturn);
                querrySaleConsReturn.SetFilter(TH_DateFilter, DateFilter);
                querrySaleConsReturn.SetFilter(TSE_TypeTransFilter, '<0');
                if StoreFilter <> '' then querrySaleConsReturn.SetFilter(TH_StoreFilter, StoreFilter);
                querrySaleConsReturn.Open;
                while querrySaleConsReturn.Read do begin
                    tbResuft."Consignment Return" := querrySaleConsReturn.TSE_Cost;
                End;
                tbResuft."Consignment Net Purchase" := tbResuft."Consignment Receive" - abs(tbResuft."Consignment Return");
                NetPurchaseCostRate := tbResuft."Consignment Net Purchase";
                tbResuft.Insert();

                Clear(tbResuft);
                tbResuft.Type := 'Consignment';
                TypeDecimal := false;
                tbResuft.RowType := '2. Price';
                tbResuft.STT := 2;
                querrySaleCons.Open;
                while querrySaleCons.Read do begin
                    tbResuft."Consignment Receive" := querrySaleCons.TSE_Total_Sale;
                End;
                querrySaleConsReturn.Open;
                while querrySaleConsReturn.Read do begin
                    tbResuft."Consignment Return" := abs(querrySaleConsReturn.TSE_Total_Sale);
                End;
                tbResuft."Consignment Net Purchase" := tbResuft."Consignment Receive" - abs(tbResuft."Consignment Return");
                if tbResuft."Consignment Net Purchase" > 0 then
                    NetPurchaseCostRate := NetPurchaseCostRate / tbResuft."Consignment Net Purchase";
                tbResuft.Insert();

                Clear(tbResuft);
                tbResuft.Type := 'Consignment';
                tbResuft.RowType := '3. Cost Rate';
                TypeDecimal := true;
                tbResuft.STT := 3;
                querrySaleCons.Open;
                while querrySaleCons.Read do begin
                    if querrySaleCons.TSE_Total_Sale > 0 then
                        tbResuft."Consignment Receive" := (querrySaleCons.TSE_Cost / querrySaleCons.TSE_Total_Sale) * 100;
                End;
                querrySaleConsReturn.Open;
                while querrySaleConsReturn.Read do begin
                    if Abs(querrySaleConsReturn.TSE_Total_Sale) > 0 then
                        tbResuft."Consignment Return" := (abs(querrySaleConsReturn.TSE_Cost) / abs(querrySaleConsReturn.TSE_Total_Sale)) * 100;
                End;
                tbResuft."Consignment Net Purchase" := NetPurchaseCostRate * 100;
                tbResuft.Insert();

                Clear(tbResuft);
                tbResuft.Type := 'Consignment';
                tbResuft.RowType := '4. Quantity';
                TypeDecimal := true;
                tbResuft.STT := 4;
                querrySaleCons.Open;
                while querrySaleCons.Read do begin
                    tbResuft."Consignment Receive" := querrySaleCons.TSE_Count;
                End;
                querrySaleConsReturn.Open;
                while querrySaleConsReturn.Read do begin
                    tbResuft."Consignment Return" := querrySaleConsReturn.TSE_Count;
                End;
                tbResuft."Consignment Net Purchase" := abs(tbResuft."Consignment Receive") - abs(tbResuft."Consignment Return");
                tbResuft.Insert();

                #endregion
            end;

            trigger OnAfterGetRecord()
            begin
                if TypeDecimal = false then begin
                    CustomerUnitAggregateText := FormatWithThousandsDecimalValue("Customer Unit Aggregate", 0);
                    CustomersAggregateText := FormatWithThousandsDecimalValue("Customers Aggregate", 0);
                    DiscountAggregateText := FormatWithThousandsDecimalValue("Discount Aggregate", 0);
                    GPRatioAggregateText := Format(Round("GP Ratio Aggregate", 0.01, '='));
                    GrossProfitAggregateText := FormatWithThousandsDecimalValue("Gross Profit Aggregate", 0);
                    QuantityAggregateText := FormatWithThousandsDecimalValue("Quantity Aggregate", 0);
                    SalesCostAggregateText := FormatWithThousandsDecimalValue("Sales Cost Aggregate", 0);
                    SalesPriceAggregateText := FormatWithThousandsDecimalValue("Sales Price Aggregate", 0);
                    SalesPricePurchaseText := FormatWithThousandsDecimalValue("Sales Price Purchase", 0);
                    GrossPurchaseText := FormatWithThousandsDecimalValue("Gross Profit Purchase", 0);
                    GPRatioPurchaseText := Format(Round("GP Ratio Purchase", 0.01, '='));
                    SalesPriceConsignmentText := FormatWithThousandsDecimalValue("Sales Price Consignment", 0);
                    GrossProfitConsignmentText := FormatWithThousandsDecimalValue("Gross Profit Consignment", 0);
                    GPRatioConsignmentText := FormatWithThousandsDecimalValue("GP Ratio Consignment", 2);
                    ConsignmentReceiveText := FormatWithThousandsDecimalValue("Consignment Receive", 0);
                    ConsignmentReturnText := FormatWithThousandsDecimalValue("Consignment Return", 0);
                    ConsignmentNetPurchaseText := FormatWithThousandsDecimalValue("Consignment Net Purchase", 0);
                end else begin
                    CustomerUnitAggregateText := Format(Round("Customer Unit Aggregate", 0.01, '='));
                    CustomersAggregateText := Format(Round("Customers Aggregate", 0.01, '='));
                    DiscountAggregateText := Format(Round("Discount Aggregate", 0.01, '='));
                    GPRatioAggregateText := Format(Round("GP Ratio Aggregate", 0.01, '='));
                    GrossProfitAggregateText := Format(Round("Gross Profit Aggregate", 0.01, '='));
                    QuantityAggregateText := Format(Round("Quantity Aggregate", 0.01, '='));
                    SalesCostAggregateText := Format(Round("Sales Cost Aggregate", 0.01, '='));
                    SalesPriceAggregateText := Format(Round("Sales Price Aggregate", 0.01, '='));
                    SalesPricePurchaseText := Format(Round("Sales Price Purchase", 0.01, '='));
                    GrossPurchaseText := Format(Round("Gross Profit Purchase", 0.01, '='));
                    GPRatioPurchaseText := Format(Round("GP Ratio Purchase", 0.01, '='));
                    SalesPriceConsignmentText := Format(Round("Sales Price Consignment", 0.01, '='));
                    GrossProfitConsignmentText := Format(Round("Gross Profit Consignment", 0.01, '='));
                    GPRatioConsignmentText := Format(Round("GP Ratio Consignment", 0.01, '='));
                    ConsignmentReceiveText := Format(Round("Consignment Receive", 0.01, '='));
                    ConsignmentReturnText := Format(Round("Consignment Return", 0.01, '='));
                    ConsignmentNetPurchaseText := Format(Round("Consignment Net Purchase", 0.01, '='));
                end;
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

    procedure FormatWithThousandsDecimals(Value: Decimal; Decimals: Integer): Text
    var
        RoundedValue: Decimal;
        FormatStr: Text;
        TempText: Text;
        ResultText: Text;
        i: Integer;
        Count: Integer;
        Pos: Integer;
        IntPart: Text;
        DecPart: Text;
    begin
        // Làm tròn đến số thập phân mong muốn
        RoundedValue := Round(Value, Power(10, -Decimals), '=');

        // Tạo format string
        if Decimals = 0 then
            FormatStr := '<Integer,0>'
        else
            FormatStr := '<Precision,0:' + Format(Decimals) + '>';

        TempText := Format(RoundedValue, 0, FormatStr);

        // Tách phần nguyên và phần thập phân
        Pos := StrPos(TempText, '.');
        if Pos > 0 then begin
            IntPart := CopyStr(TempText, 1, Pos - 1);
            DecPart := CopyStr(TempText, Pos + 1, Decimals);
        end else begin
            IntPart := TempText;
            DecPart := '';
        end;

        // Thêm dấu phẩy phần ngàn
        ResultText := '';
        Count := 0;
        for i := StrLen(IntPart) downto 1 do begin
            Count += 1;
            ResultText := CopyStr(IntPart, i, 1) + ResultText;
            if (Count mod 3 = 0) and (i > 1) then
                ResultText := ',' + ResultText;
        end;

        if Decimals > 0 then
            exit(ResultText + '.' + PadStr(DecPart, Decimals, '0'))
        else
            exit(ResultText);
    end;


    procedure FormatWithThousandsDecimalValue(Value: Decimal; Decimals: Integer): Text
    var
        TempText: Text;
        IntegerPart: Text;
        DecimalPart: Text;
        ResultText: Text;
        i: Integer;
        Count: Integer;
        Pos: Integer;
    begin
        // Làm tròn trước theo số thập phân mong muốn
        if (Decimals >= 0) and (Decimals <= 15) then
            Value := Round(Value, Power(10, -Decimals), '=');

        // Convert sang text (dùng default)
        TempText := Format(Value, 0, '<Integer,0>');

        // Xác định dấu thập phân (.)
        Pos := StrPos(TempText, '.');
        if Pos > 0 then begin
            IntegerPart := CopyStr(TempText, 1, Pos - 1);
            DecimalPart := CopyStr(TempText, Pos + 1, MaxStrLen(TempText));
        end else begin
            IntegerPart := TempText;
            DecimalPart := '';
        end;

        // Chèn dấu ',' vào phần integer
        ResultText := '';
        Count := 0;
        for i := StrLen(IntegerPart) downto 1 do begin
            Count += 1;
            ResultText := CopyStr(IntegerPart, i, 1) + ResultText;
            if (Count mod 3 = 0) and (i > 1) then
                ResultText := ',' + ResultText;
        end;

        // Ghép phần thập phân
        if Decimals > 0 then
            ResultText := ResultText + '.' + PadStr(DecimalPart, Decimals, '0');

        exit(ResultText);
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
        DateFilter: Text;
        StoreFilter: Text;
        DateFilterFormat: Text[100];
        PosTerminalFilter: Text;
        ApplicationManagement: Codeunit "Filter Tokens";

        CustomerUnitAggregateText: Text;
        CustomersAggregateText: Text;
        DiscountAggregateText: Text;
        GPRatioAggregateText: Text;
        GrossProfitAggregateText: Text;
        QuantityAggregateText: Text;
        SalesCostAggregateText: Text;
        SalesPriceAggregateText: Text;
        SalesPricePurchaseText: Text;
        GrossPurchaseText: Text;
        GPRatioPurchaseText: Text;
        SalesPriceConsignmentText: Text;
        GrossProfitConsignmentText: Text;
        GPRatioConsignmentText: Text;
        ConsignmentReceiveText: Text;
        ConsignmentReturnText: Text;
        ConsignmentNetPurchaseText: Text;

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
