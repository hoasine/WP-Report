table 58043 "Payment Detail Cash Credit"
{
    Access = Internal;
    Caption = 'Payment Detail Cash Credit';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Date"; tEXT[100])
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
        field(7; "Special Group Name"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Special Group Name';
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
        field(12; "Total Sale"; Decimal)
        {
            Caption = 'Total Sale';
            DataClassification = ToBeClassified;
        }
        field(13; "Special Group Code"; Text[100])
        {
            Caption = 'Special Group Code';
            DataClassification = ToBeClassified;
        }
        field(14; "COUPONISSUE"; Decimal)
        {
            Caption = 'COUPONISSUE';
            DataClassification = ToBeClassified;
        }
        field(15; "Price_afer_discount"; Decimal)
        {
            Caption = 'Price_afer_discount';
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

report 70019 "Payment Detail Cash Credit"
{
    ApplicationArea = All;
    Caption = 'Payment Detail Cash Credit';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = PaymentDetailCashCreditExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    // MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(CreditFeeDetail; "Payment Detail Cash Credit")
        {
            // DataItemTableView = sorting();
            // RequestFilterFields = dateFilter;
            // PrintOnlyIfDetail = true;
            column(recdate; "Date") { }
            column(pos_no; "POS Terminal No.") { }
            column(Tran_no; "Transaction No.") { }
            column(suppliercd; suppliercd) { }
            column("Price_afer_discount"; Price_afer_discount) { }
            column(CRPayment; CRPAYMENT) { }
            column(COUPONISSUE; "COUPONISSUE") { }
            column("ttlSales"; "Total Sale") { }
            column(BRDNM; "Special Group Name") { }
            column(supplier_Name; supplierName) { }
            column(Class; "Special Group Code") { }

            trigger OnAfterGetRecord()
            begin
                CheckText := '2'
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
        AboutTitle = 'Payment Detail Cash Credit';
        AboutText = 'AboutText Payment Detail Cash Credit';
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
                }
            }
        }
        trigger OnOpenPage()
        begin

        end;
    }

    rendering
    {
        layout(PaymentDetailCashCreditExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70019.PaymentDetailCashCredit.xlsx';
            Caption = 'Payment Detail Cash Credit Excel';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70019.PaymentDetailCashCredit.xls.';
        }
    }

    trigger OnPreReport()
    begin
        CreateData();
    end;

    procedure CreateData()
    var
        TransSaleEntry: Record "LSC Trans. Sales Entry";
        TransSaleEntryReturn: Record "LSC Trans. Sales Entry";
        CreditFeeDetailReturn: Record "Payment Detail Cash Credit";
        nextlineno: Integer;
    begin
        clear(CreditFeeDetail);
        CreditFeeDetail.DeleteAll();

        clear(TransSaleEntry);
        if DateFilter <> '' then TransSaleEntry.SetFilter(Date, DateFilter);
        if StoreFilter <> '' then TransSaleEntry.SetRange("Store No.", StoreFilter);
        if PosterminalFilter <> '' then TransSaleEntry.SetRange("POS Terminal No.", PosterminalFilter);
        if TransactionFilter > 0 then TransSaleEntry.SetRange("Transaction No.", TransactionFilter);
        TransSaleEntry.SetRange("Orig Trans No.", 0);
        if TransSaleEntry.FindSet() then begin
            repeat
                clear(CreditFeeDetail);

                Clear(transPayment);
                transPayment.SetRange("Receipt No.", TransSaleEntry."Receipt No.");
                transPayment.SetRange("POS Terminal No.", TransSaleEntry."POS Terminal No.");
                transPayment.SetRange("Store No.", TransSaleEntry."Store No.");
                transPayment.SetRange("Transaction No.", TransSaleEntry."Transaction No.");
                // transPayment.SetFilter("Tender Type", '=%1|=%2', '3', '23');
                transPayment.SetFilter("Tender Type", '=%1', '3');

                if transPayment.FindFirst() then begin
                    Clear(transHeader);
                    transHeader.SetRange("Receipt No.", TransSaleEntry."Receipt No.");
                    transHeader.SetRange("POS Terminal No.", TransSaleEntry."POS Terminal No.");
                    transHeader.SetRange("Store No.", TransSaleEntry."Store No.");
                    transHeader.SetRange("Transaction No.", TransSaleEntry."Transaction No.");
                    if transHeader.FindFirst() then
                        CreditFeeDetail."Total Sale" := transHeader.Payment;

                    if CreditFeeDetail."Total Sale" <> 0 then begin
                        nextlineno := nextlineno + 1;
                        CreditFeeDetail."Line No." := nextlineno;
                        CreditFeeDetail.Price_afer_discount := (TransSaleEntry.Price - TransSaleEntry."Discount Amount");
                        CreditFeeDetail.CRPAYMENT := ((TransSaleEntry.Price - TransSaleEntry."Discount Amount") / CreditFeeDetail."Total Sale") * transPayment."Amount Tendered";
                        CreditFeeDetail.COUPONISSUE := 0;

                        Clear(tenderType);
                        tenderType.SetRange("Code", '3'); //Credit Card Type
                        if (tenderType.FindFirst()) then
                            CreditFeeDetail.CREDIT := CreditFeeDetail.CRPAYMENT * tenderType."Integration MDR Rate";


                        CreditFeeDetail."POS Terminal No." := TransSaleEntry."POS Terminal No.";
                        CreditFeeDetail.Date := FORMAT(TransSaleEntry."Date", 0, '<Day,2>/<Month,2>/<Year4>');

                        CreditFeeDetail."Transaction No." := TransSaleEntry."Transaction No.";

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
                            if itemSpecialGrpLink.FindFirst() then begin
                                CreditFeeDetail."Special Group Name" := itemSpecialGrpLink."Special Group Name";
                                CreditFeeDetail."Special Group Code" := itemSpecialGrpLink."Special Group Code";
                            end;
                        end;

                        CreditFeeDetail.Insert();

                        //Tìm phiếu return
                        TransSaleEntryReturn.SetRange("Orig Trans No.", TransSaleEntry."Transaction No.");
                        TransSaleEntryReturn.SetRange("Orig Trans Pos", TransSaleEntry."POS Terminal No.");
                        TransSaleEntryReturn.SetRange("Item No.", TransSaleEntry."Item No.");
                        TransSaleEntryReturn.SetRange("Store No.", TransSaleEntry."Store No.");
                        if TransSaleEntryReturn.FindFirst() then begin
                            Clear(CreditFeeDetail);

                            Clear(transHeader);
                            transHeader.SetRange("Receipt No.", TransSaleEntryReturn."Receipt No.");
                            transHeader.SetRange("POS Terminal No.", TransSaleEntryReturn."POS Terminal No.");
                            transHeader.SetRange("Store No.", TransSaleEntryReturn."Store No.");
                            transHeader.SetRange("Transaction No.", TransSaleEntryReturn."Transaction No.");
                            if transHeader.FindFirst() then
                                CreditFeeDetail."Total Sale" := transHeader.Payment;

                            nextlineno := nextlineno + 1;
                            CreditFeeDetail."Line No." := nextlineno;
                            CreditFeeDetail.COUPONISSUE := (TransSaleEntryReturn.Price - TransSaleEntryReturn."Discount Amount");
                            CreditFeeDetail.Price_afer_discount := -(TransSaleEntryReturn.Price - TransSaleEntryReturn."Discount Amount");
                            CreditFeeDetail.CRPAYMENT := 0; //Thanh toan bang CR khong có CR thanh toan khi return
                            CreditFeeDetail.CREDIT := 0; //CR chia 2 không dùng
                            CreditFeeDetail."POS Terminal No." := TransSaleEntryReturn."POS Terminal No.";
                            CreditFeeDetail.Date := FORMAT(TransSaleEntryReturn."Date", 0, '<Day,2>/<Month,2>/<Year4>');
                            CreditFeeDetail."Transaction No." := TransSaleEntryReturn."Transaction No."; // Gán lại trans no của bill gốc

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
                                if itemSpecialGrpLink.FindFirst() then begin
                                    CreditFeeDetail."Special Group Name" := itemSpecialGrpLink."Special Group Name";
                                    CreditFeeDetail."Special Group Code" := itemSpecialGrpLink."Special Group Code";
                                end;
                            end;

                            CreditFeeDetail.Insert();
                        end;
                    end;
                end else begin

                end;
            until TransSaleEntry.next = 0;
        end;
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
        ApplicationManagement: Codeunit "Filter Tokens";

}
