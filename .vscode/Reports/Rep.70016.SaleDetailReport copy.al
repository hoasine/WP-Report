report 70016 "Sale Detail Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70016.SaleDetailReport.rdl';

    ApplicationArea = All;
    Caption = 'Sale Detail Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Date Filter";
            column(USERID; UserId)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(SaleLCY; SaleLCY)
            {
            }
            column(SaleQTY; SaleQTY)
            {
            }
            column(SaleLCY_Control22; SaleLCY)
            {
            }
            column(SaleQTY_Control23; SaleQTY)
            {
            }
            column(Sale_LCYCaption; Sale_LCYCaptionLbl)
            {
            }
            column(QtyCaption; QtyCaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Item_numberCaption; Item_numberCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(Sale_by_item_number_sorted_by_dateCaption; Sale_by_item_number_sorted_by_dateCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(TotalCaption_Control24; TotalCaption_Control24Lbl)
            {
            }
            dataitem(Date; Date)
            {
                DataItemTableView = SORTING("Period Type", "Period Start") ORDER(Ascending);
                column(SaleLCY_Control16; SaleLCY)
                {
                }
                column(SaleQTY_Control17; SaleQTY)
                {
                }
                column(Date_Date__Period_Start_; Date."Period Start")
                {
                }
                column(Date_Period_Type; "Period Type")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Item.SetRange(Item."Date Filter", Date."Period Start", Date."Period End");
                    Item.CalcFields(Item."Sales (Qty.)", Item."Sales (LCY)", Item."COGS (LCY)");
                    SaleQTY := Item."Sales (Qty.)";
                    SaleLCY := Item."Sales (LCY)";
                end;

                trigger OnPreDataItem()
                begin
                    Date.SetRange(Date."Period Type", ChoseDate);
                    Date.SetRange(Date."Period Start", FromDate, ToDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Item.SetRange(Item."Location Filter", User."Location Code");
                Item.SetRange(Item."Date Filter", FromDate, ToDate);
                Item.CalcFields(Item."Sales (Qty.)");
                if Item."Sales (Qty.)" = 0 then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
                if Item.GetFilter(Item."Date Filter") <> '' then begin
                    ;
                    FromDate := Item.GetRangeMin(Item."Date Filter");
                    ToDate := Item.GetRangeMax(Item."Date Filter");
                    case ChoseDate of
                        1:
                            begin
                                ;
                                FromDate := CalcDate('<-CW>', FromDate);
                                ToDate := CalcDate('<CW>', ToDate);
                            end;
                        2:
                            begin
                                ;
                                FromDate := CalcDate('<-CM>', FromDate);
                                ToDate := CalcDate('<CM>', ToDate);
                            end;
                    end;
                    Item.SetRange(Item."Date Filter", FromDate, ToDate);
                end;

                BHR.SetCurrentKey("Item No.", "Item Ledger Entry Type", "Location Code", "Variant Code",
                                  "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");

                BHR.SetRange(BHR."Item Ledger Entry Type", 1);

                if Item.GetFilter(Item."No.") <> '' then begin
                    ;
                    FromItem := Item.GetRangeMin(Item."No.");
                    ToItem := Item.GetRangeMax(Item."No.");
                    BHR.SetRange(BHR."Item No.", FromItem, ToItem);
                end;

                if Item.GetFilter(Item."Date Filter") <> '' then begin
                    ;
                    FromDate := Item.GetRangeMin(Item."Date Filter");
                    ToDate := Item.GetRangeMax(Item."Date Filter");
                    BHR.SetRange(BHR."Posting Date", FromDate, ToDate);
                end
                else begin
                    ;
                    FromDate := 0D;
                    ToDate := Today();
                    BHR.SetRange(BHR."Posting Date", FromDate, ToDate);
                end;

                User.GetUserSetup(User, false);
                BHR.SetRange("Location Code", User."Location Code");

                Filter := Item.GetFilters;
                if "Items with movement" then
                    if Filter <> '' then
                        Filter := Filter + Text004
                    else
                        Filter := Text005;
                if Filter <> '' then
                    Filter := Filter + Text006 + Format(ChoseDate)
                else
                    Filter := Text007 + Format(ChoseDate);

                BHR.CalcSums(BHR."Sales Amount (Actual)");

                TotalSales := -BHR."Sales Amount (Actual)";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1100409001)
                {
                    ShowCaption = false;
                    field(ChoseDate; ChoseDate)
                    {
                        Caption = 'By';
                    }
                }
            }
        }
    }

    labels
    {
    }

    var
        Text004: Label ', "Items with movement"';
        Text005: Label 'Items with movement';
        Text006: Label ', After ';
        Text007: Label 'After ';
        FromItem: Code[20];
        ToItem: Code[20];
        FromDate: Date;
        ToDate: Date;
        TotalSales: Decimal;
        SaleQTY: Decimal;
        SaleLCY: Decimal;
        UseLCY: Decimal;
        CalcProfitLCY: Decimal;
        BHR: Record "Value Entry";
        "Filter": Text[250];
        "Items with movement": Boolean;
        ChoseDate: Option Days,Weeks,Months;
        User: Record "LSC Retail User";
        LastFieldNo: Integer;
        Sale_LCYCaptionLbl: Label 'Sale Amount';
        QtyCaptionLbl: Label 'Qty';
        NameCaptionLbl: Label 'Name';
        Item_numberCaptionLbl: Label 'Item number';
        PageCaptionLbl: Label 'Page';
        Sale_by_item_number_sorted_by_dateCaptionLbl: Label 'Sale by item number sorted by date';
        TotalCaptionLbl: Label 'Total';
        TotalCaption_Control24Lbl: Label 'Total';
}

