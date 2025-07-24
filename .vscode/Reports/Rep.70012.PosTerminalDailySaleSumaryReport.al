report 70012 "P Daily Sale Sumary Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70012.PosTerminalDailySaleSumaryReport.rdl';
    ApplicationArea = All;
    Caption = 'P Daily Sale Sumary Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("LSC POS Terminal"; "LSC POS Terminal")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Store No.", "No.", "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(POS_Terminal__GETFILTER__Store_No___; "LSC POS Terminal".GetFilter("Store No."))
            {
            }
            column(POS_Terminal__GETFILTER__No___; "LSC POS Terminal".GetFilter("No."))
            {
            }
            column(POS_Terminal__GETFILTER__Date_Filter__; "LSC POS Terminal".GetFilter("Date Filter"))
            {
            }
            column(POS_Terminal__No__; "No.")
            {
            }
            column(CountAmount; "CountAmount")
            {
            }
            column(SalesAmt; "SalesAmt")
            {
            }
            column(DiffAmount; "DiffAmount")
            {
            }
            column(ProfitPercentage; "ProfitPercentage")
            {
            }
            column(Store_No_; "Store No.")
            {
            }
            column(Posted_Date; "Date Filter")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(RecPostedStatement);
                RecPostedStatement.SetRange("POS Terminal No.", "LSC POS Terminal"."No.");
                RecPostedStatement.SetRange("Store No.", "LSC POS Terminal"."Store No.");
                RecPostedStatement.SetRange("Tender Type", '1');
                RecPostedStatement.SetFilter("Posted Date", "LSC POS Terminal".GetFilter("Date Filter"));
                RecPostedStatement.CalcSums("Counted Amount in LCY", "Trans. Amount in LCY", "Added to Drawer", "Difference in LCY");
                // CountAmount := RecPostedStatement."Counted Amount in LCY";
                // SalesAmt := RecPostedStatement."Trans. Amount in LCY" + RecPostedStatement."Added to Drawer";
                // DiffAmount := -RecPostedStatement."Difference in LCY";

                // if SalesAmt <> 0 then
                //     ProfitPercentage := (SalesAmt - (CountAmount + DiffAmount)) 
                // else
                //     ProfitPercentage := 0;

                CountAmount := 0;
                SalesAmt := RecPostedStatement."Trans. Amount in LCY" ;
                DiffAmount := 0;
                ProfitPercentage := 0;
            end;

            trigger OnPreDataItem()
            begin
                IF ("Date Filter" <> 0D) THEN
                    ERROR('The report couldn’t be generated, because the Date Filter is empty.');

                LastFieldNo := FieldNo("No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }
    }

    labels
    {
    }

    var
        RecPostedStatementHeader: Record "LSC Posted Statement";
        RecPostedStatement: Record "LSC Posted Statement Line";
        SalesAmt: Decimal;
        CountAmount: Decimal;
        DiffAmount: Decimal;
        ProfitAmount: Decimal;
        ProfitPercentage: Decimal;

        //default
        LastFieldNo: Integer;
        Profit: Decimal;
        ProfitProc: Decimal;
        POS_Terminal_SalesCaptionLbl: Label 'POS Terminal Sales';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Store_FilterCaptionLbl: Label 'Store Filter';
        POS_Terminal_FilterCaptionLbl: Label 'POS Terminal Filter';
        Date_FilterCaptionLbl: Label 'Date Filter';
        SaleCaptionLbl: Label 'Sale';
        DiscountCaptionLbl: Label 'Discount';
        EmptyStringCaptionLbl: Label 'Profit %';
        CostCaptionLbl: Label 'Cost';
        ProfitCaptionLbl: Label 'Profit';
        TotalsCaptionLbl: Label 'Totals';
}

          
