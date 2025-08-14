table 58060 "Consignment Purchase Report"
{
    Access = Internal;
    Caption = 'Consignment Purchase Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Brand"; Text[100])
        {
            Caption = 'Brand';
            DataClassification = ToBeClassified;
        }
        field(2; "BrandName"; Text[100])
        {
            Caption = 'BrandName';
            DataClassification = ToBeClassified;
        }
        field(3; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Tax Rate"; Decimal)
        {
            Caption = 'Tax Rate';
            DataClassification = ToBeClassified;
        }
        field(6; "ProfitMargin"; Decimal)
        {
            Caption = 'ProfitMargin';
            DataClassification = ToBeClassified;
        }
        field(7; "TotalExclTax"; Decimal)
        {
            Caption = 'TotalExclTax';
            DataClassification = ToBeClassified;
        }
        field(8; "Cost"; Decimal)
        {
            Caption = 'Cost';
            DataClassification = ToBeClassified;
        }
        field(9; "Tax"; Decimal)
        {
            Caption = 'Tax';
            DataClassification = ToBeClassified;
        }
        field(10; "TotalCost"; Decimal)
        {
            Caption = 'TotalCost';
            DataClassification = ToBeClassified;
        }
        field(11; "VendorNo"; Text[100])
        {
            Caption = 'VendorNo';
            DataClassification = ToBeClassified;
        }
        field(12; "VendorName"; Text[100])
        {
            Caption = 'VendorName';
            DataClassification = ToBeClassified;
        }
        field(13; "Store No."; Text[100])
        {
            Caption = 'Store No.';
            DataClassification = ToBeClassified;
        }
        field(14; "StoreName"; Text[100])
        {
            Caption = 'StoreName';
            DataClassification = ToBeClassified;
        }
        field(15; "FromDateFilter"; Date)
        {
            Caption = 'FromDateFilter';
            DataClassification = ToBeClassified;
        }
        field(16; "ToDateFilter"; Date)
        {
            Caption = 'ToDateFilter';
            DataClassification = ToBeClassified;
        }
        field(17; "Line No."; Decimal)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(18; "Class"; Text[100])
        {
            Caption = 'Class';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        // key(PK; "VendorNo", "Brand", "Date", "Tax Rate", ProfitMargin, "Line No.")
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}


report 70032 "Consignment Purchase Report"
{
    ApplicationArea = All;
    Caption = 'Consignment Purchase Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70032.ConsignmentPurchase.rdl';
    dataset
    {
        dataitem(tbResuft; "Consignment Purchase Report")
        {
            column(Brand; "Brand") { }
            column(Class; "Class") { }
            column(BrandName; BrandName) { }
            column(Quantity; Quantity) { }
            column(TaxRate; "Tax Rate") { }
            column(Tax; "Tax") { }
            column(Cost; "Cost") { }
            column(Store_No_; "Store No.") { }
            column(StoreName; StoreName) { }
            column(VendorNo; "VendorNo") { }
            column(VendorName; VendorName) { }
            column(FromDateFilter; FromDateFilter) { }
            column(ToDateFilter; ToDateFilter) { }
            column(Date; Date) { }
            column(Tax_Rate; "Tax Rate") { }
            column(ProfitMargin; "ProfitMargin") { }
            column(TotalExclTax; "TotalExclTax") { }
            column(TotalCost; "TotalCost") { }

            trigger OnPreDataItem()

            var
                tbResuft2: Record "Consignment Purchase Report";
                tbConsHeader: Record "Consignment Header";
                CE: Record "Consignment Entries";
                LRecStore: Record "LSC Store";
                LRecVendor: Record "Vendor";
                lrecBrand: Record "LSC Item Special Groups";
                lrecdiv: Record "LSC Division";
                tbItem: Record "Item";
                tbVatPosting: Record "VAT Posting Setup";
                StartDate: Date;
                EndDate: Date;
                TotalCost: Decimal;
                nextlineno: Decimal;
                memoFilter: Text;
                TaxRate: Decimal;
            begin
                IF (TotalingPeriod = '') THEN
                    ERROR('The report couldn’t be generated, because it was empty. Input data for the Period field.');

                Clear(ce);
                tbResuft.DeleteAll();

                Clear(ce);
                ce.SetFilter("Date", TotalingPeriod);
                if VendorFilter <> '' then ce.SetFilter("Vendor No.", VendorFilter);

                if ce.FindSet() then begin
                    repeat
                        //GetTax
                        clear(tbItem);
                        tbItem.SetRange("No.", ce."Item No.");
                        tbItem.FindFirst();

                        Clear(tbVatPosting);// Record "VAT Posting Setup";
                        tbVatPosting.SetRange("VAT Prod. Posting Group", tbItem."VAT Prod. Posting Group");
                        tbVatPosting.SetRange("VAT Bus. Posting Group", 'DOMESTIC_IN');
                        if tbVatPosting.FindFirst() then begin
                            TaxRate := tbVatPosting."VAT %";
                        end else
                            TaxRate := 0;

                        cleaR(tbResuft);
                        tbResuft.setrange("VendorNo", ce."Vendor No.");
                        // tbResuft.SetRange("Date", ce."Date");
                        // tbResuft.setrange("Brand", ce."Special Group");
                        tbResuft.setrange("Class", ce."Product Group");
                        // tbResuft.setrange("ProfitMargin", ce."Consignment %");
                        // tbResuft.setrange("Tax Rate", TaxRate);

                        //Check Memo
                        clear(lrecvendor);
                        if LRecVendor.get(ce."Vendor No.") then begin
                            IF (Memo1Filter = Memo1Filter::"1.One Time") then
                                memoFilter := '1';
                            IF (Memo1Filter = Memo1Filter::"2.Two Times") then
                                memoFilter := '2';
                        end;

                        if lrecvendor."Memo 1" = memoFilter then begin
                            if (not tbResuft.FindFirst()) then begin
                                // if (not tbResuft.FindFirst()) or (ce."Total Excl Tax" < 0) then begin
                                Clear(tbResuft);
                                clear(tbResuft2);
                                Clear(TotalCost);
                                Clear(TaxPrice);

                                nextlineno := nextlineno + 100;

                                tbResuft.VendorName := LRecVendor.Name;
                                tbResuft."Date" := ce.Date;
                                tbResuft."Line No." := nextlineno;
                                tbResuft.Brand := ce."Special Group";

                                tbResuft.Class := ce."Product Group";

                                clear(lrecBrand);
                                if lrecBrand.Get(ce."Special Group") then
                                    tbResuft.BrandName := lrecBrand.Description;

                                tbResuft.Cost := ce.Cost;
                                tbResuft.ProfitMargin := ce."Consignment %";
                                tbResuft.Quantity := ce.Quantity;
                                tbResuft."Store No." := ce."Store No.";

                                clear(LRecStore);
                                if LRecStore.Get(ce."Store No.") then
                                    tbResuft.StoreName := LRecStore.Name;

                                tbResuft."Tax Rate" := TaxRate;
                                TaxPrice := ce.Cost * (tbResuft."Tax Rate" / 100);
                                tbResuft.Tax := TaxPrice;

                                TotalCost := ce.Cost + TaxPrice;
                                tbResuft.TotalCost := TotalCost;

                                tbResuft.TotalExclTax := ce."Total Excl Tax";
                                tbResuft.VendorNo := ce."Vendor No.";

                                ParseDateRange(TotalingPeriod, StartDate, EndDate);
                                tbResuft.FromDateFilter := StartDate;
                                tbResuft.ToDateFilter := EndDate;

                                tbResuft.Insert(true);
                            end else begin
                                tbResuft.TotalExclTax := tbResuft.TotalExclTax + ce."Total Excl Tax";
                                tbResuft.Quantity := tbResuft.Quantity + ce."Quantity";
                                tbResuft.Cost := tbResuft.Cost + ce."Cost";
                                tbResuft."Tax Rate" := TaxRate;

                                TaxPrice := ce.Cost * (tbResuft."Tax Rate" / 100);
                                tbResuft.Tax := tbResuft.Tax + TaxPrice;

                                TotalCost := ce.Cost + TaxPrice;
                                tbResuft.TotalCost := tbResuft.TotalCost + TotalCost;
                                tbResuft.Modify(true);
                            end;
                        end;

                    until ce.Next() = 0;

                    clear(tbResuft);
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
                    field(Memo1Filter; Memo1Filter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Memo 1 Filter';

                    }
                    field(PaymentDate; PaymentDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Payment Date';
                        NotBlank = true;
                        trigger OnValidate()
                        var
                            lRec_DateMaster: record "Date Master";
                        begin
                            TotalingPeriod := '';
                            FromDate := 0D;
                            ToDate := 0D;

                            lRec_DateMaster.RESET;
                            lRec_DateMaster.SETRANGE("Payment Type", Memo1Filter);
                            lRec_DateMaster.SETRANGE("Payment Date", PaymentDate);
                            lRec_DateMaster.FindLast();
                            ToDate := lRec_DateMaster."Closing Date";
                            lRec_DateMaster.RESET;
                            lRec_DateMaster.SETRANGE("Payment Type", Memo1Filter);
                            lRec_DateMaster.SETFilter("Payment Date", '<%1', PaymentDate);
                            lRec_DateMaster.FindLast();
                            FromDate := lRec_DateMaster."Closing Date" + 1;

                            TotalingPeriod := FORMAT(FromDate) + '..' + FORMAT(ToDate);

                        end;

                    }
                    field(TotalingPeriod; TotalingPeriod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Totaling Period';
                        Editable = false;

                    }
                    field("Vendor"; VendorFilter)
                    {
                        TableRelation = "Vendor";
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
        RecPeriods: Record "WP B.Inc Billing Periods";
        costratepctg: Decimal;
        PeriodsFilter: text;
        FromDateFilter: Date;
        ToDateFilter: Date;
        StoreFilter: text;
        DivisionFilter: text;
        RPGFilter: text;
        BrandFilter: text;
        StoreName: text;
        VendorName: text;
        BrandName: text;
        DivisionName: text;
        TaxPrice: Decimal;
        Memo1Filter: enum "Payment Type";
        PaymentDate: Date;
        TotalingPeriod: Text[100];
        FromDate: Date;
        ToDate: Date;
        VendorFilter: text;
}
