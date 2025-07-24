table 58048 "Supplier Voucher Report Table"
{
    Access = Internal;
    Caption = 'Supplier Voucher Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "BrandName"; text[100])
        {
            Caption = 'BrandName';
            DataClassification = ToBeClassified;
        }
        field(2; "SupplierCode"; text[100])
        {
            Caption = 'SupplierCode';
            DataClassification = ToBeClassified;
        }
        field(3; "SupplierName"; text[100])
        {
            Caption = 'SupplierName';
            DataClassification = ToBeClassified;
        }
        field(4; "Nomination"; decimal)
        {
            Caption = 'Nomination';
            DataClassification = ToBeClassified;
        }
        field(5; "TotalAmount"; decimal)
        {
            Caption = 'TotalAmount';
            DataClassification = ToBeClassified;
        }
        field(9; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; BrandName, SupplierCode, Nomination)
        {
            Clustered = true;
        }
    }
}

report 70021 "Supplier Voucher Report"
{
    ApplicationArea = All;
    Caption = 'Supplier Voucher Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = SupplierVoucherReportExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Data; "Supplier Voucher Report Table")
        {
            // RequestFilterFields = "DateFilter", VendorNoFilter, "SpecialGroupFilter";
            // DataItemTableView = sorting(BrandName, SupplierCode, Nomination);
            column(BrandName; BrandName) { }
            column(SupplierCode; SupplierCode) { }
            column(SupplierName; SupplierName) { }
            column(Nomination; Nomination) { }
            column(Quantity; Quantity) { }
            column(TotalAmount; TotalAmount) { }

            trigger OnPreDataItem()
            var
                tbTransPayment: Record "LSC Trans. Payment Entry";
                tbInfoCodes: Record "LSC Trans. Infocode Entry";
                tbTransSaleEntry: Record "LSC Trans. Sales Entry";
                tbItem: Record Item;
                tbVendor: Record Vendor;
                tbSpecialGroup: Record "LSC Item/Special Group Link";

                BrandName: Text[100];
                SupplierCode: Text[100];
                SupplierName: Text[100];
                Nomination: Decimal;
                Quantity: Decimal;
                TotalAmount: Decimal;
                TotalCount: Decimal;
                IsInsert: Integer;
            begin
                clear(Data);
                Data.DeleteAll();

                Clear(tbTransPayment);
                tbTransPayment.SetRange("Tender Type", '21');
                tbTransPayment.SetFilter("Amount Tendered", '>%1', 0); //Kiểm tra bill decler thì skip
                if DateFilter <> 0D then
                    tbTransPayment.SetRange(Date, DateFilter);

                TotalCount := tbTransPayment.Count;

                if tbTransPayment.FindSet() then
                    repeat
                        IsInsert := 1;

                        Clear(BrandName);
                        Clear(SupplierCode);
                        Clear(SupplierName);
                        Clear(Nomination);//Giá trị voucher
                        Clear(Quantity);
                        Clear(TotalAmount);

                        Nomination := tbTransPayment."Amount Tendered";
                        Quantity := Quantity + 1;

                        //Vendor
                        clear(tbTransSaleEntry);
                        tbTransSaleEntry.SetRange("Receipt No.", tbTransPayment."Receipt No.");
                        tbTransSaleEntry.SetRange("POS Terminal No.", tbTransPayment."POS Terminal No.");
                        tbTransSaleEntry.SetRange("Transaction No.", tbTransPayment."Transaction No.");
                        tbTransSaleEntry.SetRange("Store No.", tbTransPayment."Store No.");
                        if tbTransSaleEntry.FindFirst() then begin

                            Clear(tbItem);
                            tbItem.SetRange("No.", tbTransSaleEntry."Item No.");
                            if tbItem.FindFirst() then begin

                                Clear(tbVendor);
                                tbVendor.SetRange("No.", tbItem."Vendor No.");
                                if tbVendor.FindFirst() then begin
                                    SupplierCode := tbVendor."No.";
                                    SupplierName := tbVendor."Name";
                                end;

                                Clear(tbSpecialGroup);
                                tbSpecialGroup.SetRange("Item No.", tbItem."No.");
                                tbSpecialGroup.SetAutoCalcFields("Special Group Name");
                                if tbSpecialGroup.FindFirst() then begin
                                    BrandName := tbSpecialGroup."Special Group Name";
                                end;
                            end;

                            clear(Data);
                            Data.setrange("BrandName", BrandName);
                            Data.setrange("SupplierCode", SupplierCode);
                            Data.setrange("Nomination", Nomination);
                            if not Data.FindFirst() then begin
                                Clear(Data);
                                Data.BrandName := BrandName;
                                Data.SupplierCode := SupplierCode;
                                Data.SupplierName := SupplierName;
                                Data.Nomination := Nomination;
                                Data.Quantity := 1;
                                Data.TotalAmount := Data.Quantity * Data.Nomination;

                                if VendorNoFilter <> '' then
                                    if tbVendor."No." <> VendorNoFilter then
                                        IsInsert := 0;

                                if SpecialGroupFilter <> '' then
                                    if tbItem."LSC Special Group Code" <> SpecialGroupFilter then
                                        IsInsert := 0;

                                if IsInsert = 1 then
                                    Data.Insert();
                            end else begin
                                Data.Quantity := Data.Quantity + 1;
                                Data.TotalAmount := Data.Quantity * Nomination;
                                Data.Modify();
                            end;
                        end;
                    until tbTransPayment.next = 0;
            end;

            trigger OnAfterGetRecord()
            begin

            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Supplier Vouche rReport';
        AboutText = 'AboutText Supplier Voucher Report';
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field("Date"; DateFilter)
                    {
                    }
                    field("Brand Name"; SpecialGroupFilter)
                    {
                        TableRelation = "LSC Item Special Groups";
                    }
                    field("Vendor Name"; VendorNoFilter)
                    {
                        TableRelation = "Vendor";
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
        layout(SupplierVoucherReportExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70021.SupplierVoucherReportExcel.xlsx';
            Caption = 'Supplier Voucher Report';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70021.SupplierVoucherReportExcel.xlsx';
        }
    }

    trigger OnPreReport()
    begin

    end;

    var
        DateFilter: Date;
        SpecialGroupFilter: Text[100];
        VendorNoFilter: Text[100];
}