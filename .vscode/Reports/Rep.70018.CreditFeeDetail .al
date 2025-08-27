table 58042 "Credit Fee Detail"
{
    Access = Internal;
    Caption = 'Credit Fee Detail';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Date"; Text[100])
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(2; "POS Terminal No."; Text[500])
        {
            Caption = 'POS Terminal No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction No.';
        }
        field(4; "suppliercd"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'suppliercd';
        }
        field(5; "CRPAYMENT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'CRPAYMENT';
        }
        field(6; "CREDIT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'CREDIT';
        }
        field(7; "BRDNM"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'BRDNM';
        }
        field(8; "supplierName"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'supplierName';
        }
        field(10; "dateFilter"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'dateFilter';
        }
        field(11; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "line no.")
        {
            Clustered = true;
        }
    }
}

report 70018 "Credit Fee Detail"
{
    ApplicationArea = All;
    Caption = 'Credit Fee Detail';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = CreditFeeDetailExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(CreditFeeDetail; "Credit Fee Detail")
        {
            DataItemTableView = sorting("Line No.");
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
            column(StartDateFilter; DateTarget) { }
            column(recdate; "Date") { }
            column(pos_no; "POS Terminal No.") { }
            column(Tran_no; "Transaction No.") { }
            column(suppliercd; suppliercd) { }
            column(CRPAYMENT; CRPAYMENT) { }
            column(CREDIT; CREDIT) { }
            column(BRDNM; BRDNM) { }
            column(supplier_Name; supplierName) { }

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                CreateData();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Credit Fee Detail';
        AboutText = 'About Text credit Fee Detail';
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
                    field("Store No"; StoreFilter)
                    {
                        TableRelation = "LSC Store"."No.";
                    }
                    field("Pos terminal"; PosterminalFilter)
                    {
                        TableRelation = "LSC POS Terminal"."No.";
                    }
                    field("Division"; DivisionFilter)
                    {
                        TableRelation = "LSC Division";
                    }
                    field("Special Groups (Brand)"; SpecialGroupFilter)
                    {
                        TableRelation = "LSC Item Special Groups";
                    }
                    field("Product Group (Class)"; ProductGroupFilter)
                    {
                        TableRelation = "LSC Retail Product Group"."Code";
                    }
                    field("Trans"; TransactionFilter)
                    {

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
        layout(CreditFeeDetailExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70018.CreditFeeDetailExcel.xlsx';
            Caption = 'Credit Fee Detail Excel';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70018.CreditFeeDetailExcel.xls.';
        }
    }

    trigger OnPreReport()
    begin
        CreateData();
    end;

    procedure CreateData()
    var
        totalAmount: Decimal;
        TransSaleEntry: Record "LSC Trans. Sales Entry";
        TransSaleEntryReturn: Record "LSC Trans. Sales Entry";
        tbItem: Record "Item";
        nextlineno: Integer;
        tenderTypeSetup: Record "LSC Tender Type Setup";
        AmountTenderTotal: Decimal;
        tenderTypeList: Text[200];
        CheckReturnAmount: Decimal;
        CheckReturnCREDIT: Decimal;
        Isfilter: Boolean;
    begin
        DateTarget := ParseDateRangeOfFilter(DateFilter);
        DatePrint := FORMAT(Today(), 0, '<Day,2>/<Month,2>/<Year4>');

        clear(CreditFeeDetail);
        CreditFeeDetail.DeleteAll();

        clear(CheckReturnAmount);
        Clear(CheckReturnCREDIT);

        tenderTypeList := '';
        clear(tenderTypeSetup);
        tenderTypeSetup.SetRange("Is Credit Card", true);
        if tenderTypeSetup.FindSet() then
            repeat
                if tenderTypeList <> '' then
                    tenderTypeList += '|'; // phân cách bằng dấu |
                tenderTypeList += Format(tenderTypeSetup."Code");
            until tenderTypeSetup.Next() = 0;

        clear(TransSaleEntry);
        if DateFilter <> '' then TransSaleEntry.SetFilter(Date, DateFilter);
        if StoreFilter <> '' then TransSaleEntry.SetRange("Store No.", StoreFilter);
        if PosterminalFilter <> '' then TransSaleEntry.SetRange("POS Terminal No.", PosterminalFilter);
        if TransactionFilter > 0 then TransSaleEntry.SetRange("Transaction No.", TransactionFilter);
        if ProductGroupFilter <> '' then TransSaleEntry.SetRange("Retail Product Code", ProductGroupFilter);
        if DivisionFilter <> '' then TransSaleEntry.SetRange("Division Code", DivisionFilter);
        if TransSaleEntry.FindSet() then begin
            repeat
                //Check brand(Special Group)
                if SpecialGroupFilter <> '' then begin
                    Clear(tbItem);
                    tbItem.SetRange("No.", TransSaleEntry."Item No.");
                    if tbItem.FindFirst() then begin
                        if tbItem."LSC Special Group Code" = SpecialGroupFilter then
                            Isfilter := true else
                            Isfilter := false;
                    end;
                end;

                if Isfilter = true then begin
                    clear(CreditFeeDetail);

                    Clear(transPayment);
                    transPayment.SetRange("Receipt No.", TransSaleEntry."Receipt No.");
                    transPayment.SetRange("POS Terminal No.", TransSaleEntry."POS Terminal No.");
                    transPayment.SetRange("Store No.", TransSaleEntry."Store No.");
                    transPayment.SetRange("Transaction No.", TransSaleEntry."Transaction No.");
                    transPayment.SetFilter("Tender Type", tenderTypeList);
                    transPayment.CalcSums("Amount Tendered");
                    AmountTenderTotal := transPayment."Amount Tendered";

                    if transPayment.FindFirst() then begin
                        //Phieu goc
                        Clear(transHeader);
                        transHeader.SetRange("Receipt No.", TransSaleEntry."Receipt No.");
                        transHeader.SetRange("POS Terminal No.", TransSaleEntry."POS Terminal No.");
                        transHeader.SetRange("Store No.", TransSaleEntry."Store No.");
                        transHeader.SetRange("Transaction No.", TransSaleEntry."Transaction No.");
                        if transHeader.FindFirst() then
                            totalAmount := transHeader.Payment - transHeader."Discount Amount";

                        if totalAmount > 0 then begin
                            nextlineno := nextlineno + 1;

                            CreditFeeDetail.CRPAYMENT := ((-TransSaleEntry."Total Rounded Amt." - TransSaleEntry."Discount Amount") / totalAmount) * AmountTenderTotal;
                            CheckReturnAmount := CreditFeeDetail.CRPAYMENT;

                            CreditFeeDetail."POS Terminal No." := TransSaleEntry."POS Terminal No.";
                            CreditFeeDetail."Date" := FORMAT(TransSaleEntry."Date", 0, '<Day,2>/<Month,2>/<Year4>');
                            CreditFeeDetail."Transaction No." := TransSaleEntry."Transaction No.";
                            CreditFeeDetail."Line No." := nextlineno;

                            Clear(tenderType);
                            tenderType.SetRange(Code, '3');
                            if (tenderType.FindFirst()) then begin
                                CreditFeeDetail.CREDIT := CreditFeeDetail.CRPAYMENT * tenderType."Integration MDR Rate";
                                CheckReturnCREDIT := CreditFeeDetail.CREDIT;
                            end;

                            item.Reset();
                            if item.get(TransSaleEntry."Item No.") then begin
                                CreditFeeDetail.suppliercd := item."Vendor No.";

                                vendor.Reset();
                                if vendor.get(item."Vendor No.") then begin
                                    CreditFeeDetail.supplierName := vendor.Name;
                                end;

                                itemSpecialGrpLink.Reset();
                                itemSpecialGrpLink.SetRange("Item No.", item."No.");
                                itemSpecialGrpLink.SetAutoCalcFields("Special Group Name");
                                if itemSpecialGrpLink.FindFirst() then
                                    CreditFeeDetail.BRDNM := itemSpecialGrpLink."Special Group Name";
                            end;

                            CreditFeeDetail.Insert();
                            // Phieu goc

                            //Return
                            if TransSaleEntry."Refunded Trans. No." <> 0 then begin
                                clear(TransSaleEntryReturn);
                                TransSaleEntryReturn.SetRange("Transaction No.", TransSaleEntry."Refunded Trans. No.");
                                TransSaleEntryReturn.SetRange("Store No.", TransSaleEntry."Refunded Store No.");
                                TransSaleEntryReturn.SetRange("POS Terminal No.", TransSaleEntry."Refunded POS No.");
                                TransSaleEntryReturn.SetRange("Item No.", TransSaleEntry."Item No.");
                                if TransSaleEntryReturn.FindFirst() then begin
                                    clear(CreditFeeDetail);

                                    Clear(transPayment);
                                    transPayment.SetRange("Receipt No.", TransSaleEntryReturn."Receipt No.");
                                    transPayment.SetRange("POS Terminal No.", TransSaleEntryReturn."POS Terminal No.");
                                    transPayment.SetRange("Store No.", TransSaleEntryReturn."Store No.");
                                    transPayment.SetRange("Transaction No.", TransSaleEntryReturn."Transaction No.");
                                    transPayment.CalcSums("Amount Tendered");
                                    AmountTenderTotal := transPayment."Amount Tendered";

                                    if transPayment.FindFirst() then begin
                                        //Phieu goc
                                        Clear(transHeader);
                                        transHeader.SetRange("Receipt No.", TransSaleEntryReturn."Receipt No.");
                                        transHeader.SetRange("POS Terminal No.", TransSaleEntryReturn."POS Terminal No.");
                                        transHeader.SetRange("Store No.", TransSaleEntryReturn."Store No.");
                                        transHeader.SetRange("Transaction No.", TransSaleEntryReturn."Transaction No.");
                                        if transHeader.FindFirst() then
                                            totalAmount := transHeader.Payment - transHeader."Discount Amount";

                                        nextlineno := nextlineno + 1;

                                        CreditFeeDetail.CRPAYMENT := 0;
                                        // CreditFeeDetail.CRPAYMENT := -CheckReturnAmount;
                                        CreditFeeDetail."POS Terminal No." := TransSaleEntryReturn."POS Terminal No.";
                                        CreditFeeDetail."Date" := FORMAT(TransSaleEntryReturn."Date", 0, '<Day,2>/<Month,2>/<Year4>');
                                        CreditFeeDetail."Transaction No." := TransSaleEntryReturn."Transaction No.";
                                        CreditFeeDetail."Line No." := nextlineno;

                                        // CreditFeeDetail.CREDIT := -CheckReturnCREDIT;
                                        CreditFeeDetail.CREDIT := 0;

                                        item.Reset();
                                        if item.get(TransSaleEntryReturn."Item No.") then begin
                                            CreditFeeDetail.suppliercd := item."Vendor No.";

                                            vendor.Reset();
                                            if vendor.get(item."Vendor No.") then begin
                                                CreditFeeDetail.supplierName := vendor.Name;
                                            end;

                                            itemSpecialGrpLink.Reset();
                                            itemSpecialGrpLink.SetRange("Item No.", item."No.");
                                            itemSpecialGrpLink.SetAutoCalcFields("Special Group Name");
                                            if itemSpecialGrpLink.FindFirst() then
                                                CreditFeeDetail.BRDNM := itemSpecialGrpLink."Special Group Name";
                                        end;

                                        CreditFeeDetail.Insert();
                                    end;
                                end;
                            end;
                            //Return

                        end;
                    end else begin

                    end;
                end;
            until TransSaleEntry.next = 0;
        end;
    end;

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


    var
        item: Record Item;
        vendor: Record Vendor;
        transHeader: Record "LSC Transaction Header";
        transPayment: Record "LSC Trans. Payment Entry";
        tenderType: Record "LSC Tender Type Setup";
        itemSpecialGrpLink: Record "LSC Item/Special Group Link";
        CheckText: Text;
        DateFilter: Text;
        StoreFilter: Text[50];
        PosterminalFilter: Text[50];
        TransactionFilter: Integer;
        DateFormat: text[100];
        ApplicationManagement: Codeunit "Filter Tokens";

        DatePrint: text[100];
        DateTarget: text[100];
        DivisionFilter: Text;
        SpecialGroupFilter: Text;
        ProductGroupFilter: Text;
}
