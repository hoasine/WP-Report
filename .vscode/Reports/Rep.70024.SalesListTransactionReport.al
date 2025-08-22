table 58047 "Sales List Transaction Report"
{
    Access = Internal;
    Caption = 'Sales List Transaction Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Item"; Text[500])
        {
            Caption = 'Item';
            DataClassification = ToBeClassified;
        }
        field(4; "Code"; Text[500])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Qty"; Decimal)
        {
            Caption = 'Qty';
            DataClassification = ToBeClassified;
        }
        field(3; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
        }
        field(5; "STT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'STT';
        }

        field(6; "Key"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Key';
        }
    }
    keys
    {
        key(PK; "Key")
        {
            Clustered = true;
        }
    }
}

table 58056 "Group By Sale List"
{
    Access = Internal;
    Caption = 'Sales List Transaction Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "Item"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Key';
        }
        field(2; "Value"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Value';
        }
    }
    keys
    {
        key(PK; "Item")
        {
            Clustered = true;
        }
    }
}

report 70024 "Sales List Transaction Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode\ReportLayouts\\Rep.70024.SalesListTransactionReport.rdl';
    ApplicationArea = All;
    Caption = 'Sales List Transaction Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Data"; "Sales List Transaction Report")
        {
            // DataItemTableView = SORTING("Item");
            // RequestFilterFields = "Document No.", "Vendor No.", "Product Group";

            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {

            }

            column(Item; "Item")
            {

            }

            column(Qty; "Qty")
            {

            }
            column(STT; "STT")
            {

            }

            column(Amount; "Amount")
            {

            }

            column(Date; DateFormatText)
            {

            }
            column(DateFormatText; DateFormat)
            {

            }
            column(StoreNo; StoreFilter)
            {

            }

            column(Posterminal; PosTerminalFilter)
            {

            }

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                IF (DateFilter = '') THEN
                    ERROR('The report couldn’t be generated, because the Date is empty.');

                CreateData();
            end;
        }
    }


    requestpage
    {
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
    }

    labels
    {

    }

    procedure CreateData()
    var
        tbTransHeader: Record "LSC Transaction Header";
        tbPayment: Record "LSC Trans. Payment Entry";
        tbPaymentTemp: Record "LSC Trans. Payment Entry";
        tbTrans: Record "LSC Trans. Sales Entry";
        // tbPostedStatement: Record "LSC Statement";
        // tbPostedStatementLine: Record "LSC Statement Line";
        tbPostedStatement: Record "LSC Posted Statement";
        tbPostedStatementLine: Record "LSC Posted Statement Line";
        tbTenderType: Record "LSC Tender Type Setup";
        tbInfocode: Record "LSC Trans. Infocode Entry";
        tbMemberPoint: Record "LSC Member Point Entry";
        tbMemberSale: Record "LSC Member Sales Entry";
        tbTender: Record "LSC Tender Type Setup";
        queryPayment: Query "QueSaleTransactionList";
        querySaleWithPayment: Query "QuerrySaleWithPayment";
        querySaleTransCancel: Query "QueSaleTransCancel";
        querySaleTransCancelDepUnused: Query "QueSaleTransCancelDepUnused";
        tbStaffAllowance: Record wpStaffAllowanceEntry;
        tbTempGroup: Record "Group By Sale List";
        querQueSaleTransaction_staff: Query "QueSaleTransaction_staff";
        querSaleITem: Query "QueSaleProduct";
        querQueSaleTransaction_staffTotal: Query "QueSaleTransaction_staffTotal";
        tbPostedSafeLine: Record "LSC Posted Safe Statement Line";
        querQueIncom: Query QueIncom;
        check: Decimal;
        CashTransfer: Decimal;
        QtyCashTransfer: Decimal;

        CashGap: Decimal;
        TenderRemove: Decimal;
        FloatEntry: Decimal;
        QtyFloatRemove: Decimal;

        STTTemp: Decimal;
        KeyTemp: Decimal;

        TinhLaiCancelTransQty: Decimal;
        TinhLaiCancelTransAmount: Decimal;
    begin
        DateFormatText := ParseDateRangeOfFilter(DateFilter);

        clear(Data);
        Data.DeleteAll();

        IF (DateFilter = '') THEN
            ERROR('The report couldn’t be generated, because the Date is empty.');

        IF (StoreFilter = '') THEN
            ERROR('The report couldn’t be generated, because the Store is empty.');

        ParseDateRange(DateFilter);

        STTTemp := 1;
        KeyTemp := 1;

        Clear(tbPostedStatement);
        // tbPostedStatement.SetFilter("Posting Date", DateFilter);
        tbPostedStatement.SetFilter("Trans. Ending Date", DateFilter);
        if StoreFilter <> '' then tbPostedStatement.SetRange("Store No.", StoreFilter);
        if tbPostedStatement.FindSet() then begin
            repeat
                //Get Value posted statement line
                clear(tbPostedStatementLine);
                tbPostedStatementLine.SetRange("Statement No.", tbPostedStatement."No.");
                if StoreFilter <> '' then tbPostedStatementLine.SetRange("Store No.", StoreFilter);
                if PosTerminalFilter <> '' then tbPostedStatementLine.SetRange("POS Terminal No.", PosTerminalFilter);
                if tbPostedStatementLine.FindSet() then begin
                    repeat
                        Clear(Data);
                        Data.setrange("Code", tbPostedStatementLine."Tender Type");
                        if not Data.FindFirst() then begin
                            //Change Name
                            Clear(tbTender);
                            tbTender.SetFilter(Description, '<>%1', '');
                            tbTender.SetRange(Code, tbPostedStatementLine."Tender Type");
                            if tbTender.FindFirst() then begin
                                Data."Item" := tbTender."Description";
                            end else
                                Data."Item" := tbPostedStatementLine."Tender Type Name";

                            Data.Code := tbPostedStatementLine."Tender Type";

                            Clear(queryPayment);
                            queryPayment.SetFilter("TH_DateFilter", DateFilter);
                            if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
                            if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
                            queryPayment.SetRange("TSE_TenderTypeFilter", tbPostedStatementLine."Tender Type");
                            queryPayment.Open;
                            while queryPayment.Read do begin
                                Data.Qty := queryPayment.CountTender;
                            end;

                            Data."Amount" := tbPostedStatementLine."Trans. Amount in LCY";

                            if (tbPostedStatementLine."Tender Type" = '1') then begin
                                FloatEntry := FloatEntry + tbPostedStatementLine."Added to Drawer";

                                if tbPostedStatementLine."Added to Drawer" <> 0 then
                                    QtyFloatRemove := QtyFloatRemove + 1;
                                CashGap := CashGap + tbPostedStatementLine."Difference in LCY";
                            end;

                            if (tbPostedStatementLine."Tender Type" = '9') then
                                TenderRemove := TenderRemove + tbPostedStatementLine."Added to Drawer"
                            else begin
                                STTTemp := STTTemp + 1;
                                Data.STT := STTTemp;

                                KeyTemp := KeyTemp + 1;
                                Data."Key" := KeyTemp;

                                Data.insert(true);
                            end;
                        end else begin
                            Clear(queryPayment);
                            queryPayment.SetFilter("TH_DateFilter", DateFilter);
                            if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
                            if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
                            queryPayment.SetRange("TSE_TenderTypeFilter", tbPostedStatementLine."Tender Type");
                            queryPayment.Open;
                            while queryPayment.Read do begin
                                Data.Qty := queryPayment.CountTender;
                            end;

                            Data."Amount" := Data."Amount" + tbPostedStatementLine."Trans. Amount in LCY";

                            Data.Modify();

                            if (tbPostedStatementLine."Tender Type" = '1') then begin
                                FloatEntry := FloatEntry + tbPostedStatementLine."Added to Drawer";

                                if tbPostedStatementLine."Added to Drawer" <> 0 then
                                    QtyFloatRemove := QtyFloatRemove + 1;

                                CashGap := CashGap + tbPostedStatementLine."Difference in LCY";
                            end;

                            if (tbPostedStatementLine."Tender Type" = '9') then
                                TenderRemove := TenderRemove + tbPostedStatementLine."Added to Drawer";
                        end;
                    until tbPostedStatementLine.next = 0;
                end;

                //Get Cash Transfer Safe Statement Line
                clear(tbPostedSafeLine);
                tbPostedSafeLine.SetRange("Statement No.", tbPostedStatement."No.");
                tbPostedSafeLine.SetRange("Transaction Type", tbPostedSafeLine."Transaction Type"::"Remove Tender");
                tbPostedSafeLine.CalcSums(Amount);
                CashTransfer := -tbPostedSafeLine.Amount;
                QtyCashTransfer := tbPostedSafeLine.Count();
            until tbPostedStatement.next = 0;

            Clear(Data);
            check := Data.Count();
        end;

        //Total sale
        Amount := 0;
        Quantity := 0;
        Clear(tbTransHeader);
        tbTransHeader.SetFilter("Date", DateFilter);
        tbTransHeader.SetRange("Transaction Type", tbTransHeader."Transaction Type"::Sales);
        tbTransHeader.SetFilter("Payment", '<>0');
        if StoreFilter <> '' then tbTransHeader.SetRange("Store No.", StoreFilter);
        if PosTerminalFilter <> '' then tbTransHeader.SetRange("POS Terminal No.", PosTerminalFilter);
        tbTransHeader.CalcSums("Payment");
        Amount := tbTransHeader."Payment";
        Quantity := tbTransHeader.Count;

        Clear(Data);
        Data."Item" := 'Total Sale';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Product sale Tax querSaleITem
        Amount := 0;
        Quantity := 0;
        Clear(querSaleITem);
        querSaleITem.SetFilter("TH_DateFilter", DateFilter);
        if StoreFilter <> '' then querSaleITem.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querSaleITem.SetRange("PosterminalFilter", PosTerminalFilter);
        querSaleITem.Open;
        while querSaleITem.Read do begin
            Quantity := querSaleITem.CountSaleItem;
            Amount := querSaleITem.SumGrossAmount;
        end;

        Clear(Data);
        Data."Item" := 'Product Sale - Incl Tax';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Product sale
        Amount := 0;
        Quantity := 0;
        Clear(querSaleITem);
        querSaleITem.SetFilter("TH_DateFilter", DateFilter);
        if StoreFilter <> '' then querSaleITem.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querSaleITem.SetRange("PosterminalFilter", PosTerminalFilter);
        querSaleITem.Open;
        while querSaleITem.Read do begin
            Quantity := querSaleITem.CountSaleItem;
            Amount := querSaleITem.SumNetAmount;
        end;

        Clear(Data);
        Data."Item" := 'Product Sale';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);


        //Non product sale querQueIncom - Other Services
        Amount := 0;
        Quantity := 0;
        Clear(querQueIncom);
        querQueIncom.SetFilter("TH_DateFilter", DateFilter);
        querQueIncom.SetFilter("TH_TypeNonProductSaleFilter", '338822|338824|338825|338821');
        if StoreFilter <> '' then querQueIncom.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querQueIncom.SetRange("PosterminalFilter", PosTerminalFilter);
        querQueIncom.Open;
        while querQueIncom.Read do begin
            Quantity := querQueIncom.CountItem;
            Amount := querQueIncom.SumAmount;
        end;

        Clear(Data);
        Data."Item" := 'Other Services';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);


        //Non product sale querQueIncom - Rose Gift Card
        Amount := 0;
        Quantity := 0;
        Clear(querQueIncom);
        querQueIncom.SetFilter("TH_DateFilter", DateFilter);
        querQueIncom.SetFilter("TH_TypeNonProductSaleFilter", '10');
        if StoreFilter <> '' then querQueIncom.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querQueIncom.SetRange("PosterminalFilter", PosTerminalFilter);
        querQueIncom.Open;
        while querQueIncom.Read do begin
            Quantity := querQueIncom.CountItem;
            Amount := querQueIncom.SumAmount;
        end;

        Clear(Data);
        Data."Item" := 'Issued Rose Gift Card';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        // Customer count------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(tbTransHeader);
        tbTransHeader.SetFilter("Date", DateFilter);
        tbTransHeader.SetFilter("Member Card No.", '<>%1', '');
        tbTransHeader.SetRange("Transaction Type", tbTransHeader."Transaction Type"::Sales);
        if StoreFilter <> '' then tbTransHeader.SetRange("Store No.", StoreFilter);
        if PosTerminalFilter <> '' then tbTransHeader.SetRange("POS Terminal No.", PosTerminalFilter);
        if tbTransHeader.FindSet() then begin
            Quantity := tbTransHeader.Count();
        end;

        Clear(Data);
        Data."Item" := 'Customer Count';
        Data."Qty" := Quantity;
        Data."Amount" := 0;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Total Customer------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(tbTransHeader);
        tbTransHeader.SetFilter("Date", DateFilter);
        tbTransHeader.SetFilter("Member Card No.", '<>%1', '');
        tbTransHeader.SetRange("Transaction Type", tbTransHeader."Transaction Type"::Sales);
        tbTransHeader.SetFilter("Payment", '>%1', 0);//Các bill có giá trị là mua hàng - loại trừ return cancel
        if StoreFilter <> '' then tbTransHeader.SetRange("Store No.", StoreFilter);
        if PosTerminalFilter <> '' then tbTransHeader.SetRange("POS Terminal No.", PosTerminalFilter);
        if tbTransHeader.FindSet() then begin
            Quantity := tbTransHeader.Count();
        end;

        Clear(Data);
        Data."Item" := 'Total Customer';
        Data."Qty" := Quantity;
        Data."Amount" := 0;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Cancel Transaction---------Header trans field Retrieved from Receipt No. có dữ liệu không đúng vì cả return và canel đều có ngoại trừ return thì có ở infocode
        Amount := 0;
        Quantity := 0;
        Clear(querySaleTransCancel);
        querySaleTransCancel.SetFilter("TH_DateFilter", DateFilter);
        querySaleTransCancel.SetRange("SaleIsCancelFilter", true);
        querySaleTransCancel.SetRange("SaleIsReturnFilter", true);
        if StoreFilter <> '' then querySaleTransCancel.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querySaleTransCancel.SetRange("PosterminalFilter", PosTerminalFilter);
        querySaleTransCancel.Open;
        while querySaleTransCancel.Read do begin
            Quantity := querySaleTransCancel.CountTrans;
            Amount := querySaleTransCancel.SumPayment;
        end;

        Clear(Data);
        Data."Item" := 'Cancel Transaction';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Return Transaction--------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(querySaleTransCancel);
        querySaleTransCancel.SetFilter("TH_DateFilter", DateFilter);
        querySaleTransCancel.SetRange("SaleIsCancelFilter", false);
        querySaleTransCancel.SetRange("SaleIsReturnFilter", true);
        if StoreFilter <> '' then querySaleTransCancel.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querySaleTransCancel.SetRange("PosterminalFilter", PosTerminalFilter);
        querySaleTransCancel.Open;
        while querySaleTransCancel.Read do begin
            Quantity := querySaleTransCancel.CountTrans;
            Amount := querySaleTransCancel.SumPayment;
        end;

        Clear(Data);
        Data."Item" := 'Return Transaction - Incl Tax';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Return Transaction Net Amount--------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(querySaleTransCancel);
        querySaleTransCancel.SetFilter("TH_DateFilter", DateFilter);
        querySaleTransCancel.SetRange("SaleIsCancelFilter", false);
        querySaleTransCancel.SetRange("SaleIsReturnFilter", true);
        if StoreFilter <> '' then querySaleTransCancel.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querySaleTransCancel.SetRange("PosterminalFilter", PosTerminalFilter);
        querySaleTransCancel.Open;
        while querySaleTransCancel.Read do begin
            Quantity := querySaleTransCancel.CountTrans;
            Amount := -querySaleTransCancel.SumPaymentNonTax;
        end;

        Clear(Data);
        Data."Item" := 'Return Transaction';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Credit Voucher - tạo mới
        Clear(Data);
        Data.SetRange(Code, '27');
        if Data.FindFirst() then begin
            Data.Item := 'Issued Credit Voucher';
            Data.Amount := -Data.Amount;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Issued Credit Voucher';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Void All------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(tbTransHeader);
        tbTransHeader.SetFilter("Date", DateFilter);
        tbTransHeader.SetRange("Transaction Type", tbTransHeader."Transaction Type"::Sales);
        tbTransHeader.SetRange("Entry Status", tbTransHeader."Entry Status"::Voided);
        if StoreFilter <> '' then tbTransHeader.SetRange("Store No.", StoreFilter);
        if PosTerminalFilter <> '' then tbTransHeader.SetRange("POS Terminal No.", PosTerminalFilter);
        Quantity := tbTransHeader.Count();

        Clear(Data);
        Data."Item" := 'Stop(Void All)';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Float Entry
        Clear(Data);
        Data."Item" := 'Float Entry';
        Data."Qty" := QtyFloatRemove;
        Data."Amount" := FloatEntry;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Remove Tender
        Clear(Data);
        Data."Item" := 'Remove Float';
        Data."Qty" := QtyFloatRemove;
        Data."Amount" := -TenderRemove;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Deposit redemp
        Clear(Data);
        Data.SetRange(Code, '25');
        if Data.FindFirst() then begin
            DAta.Item := 'Deposit Payment(Out)';
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Deposit Payment(Out)';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Deposit in
        Amount := 0;
        Quantity := 0;
        Clear(querySaleTransCancelDepUnused);
        querySaleTransCancelDepUnused.SetFilter("TH_DateFilter", DateFilter);
        querySaleTransCancelDepUnused.SetRange("TSE_TypeIncomeFilter", '1312');
        if StoreFilter <> '' then querySaleTransCancelDepUnused.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querySaleTransCancelDepUnused.SetRange("PosterminalFilter", PosTerminalFilter);
        querySaleTransCancelDepUnused.Open;
        while querySaleTransCancelDepUnused.Read do begin
            Quantity := querySaleTransCancelDepUnused.CountDeposit;
            Amount := querySaleTransCancelDepUnused.SumAmountDeposit;
        end;

        Clear(Data);
        Data."Item" := 'Deposit Prepayment(In)';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        // Amount := 0;
        // Quantity := 0;
        // Clear(tbInfocode);
        // tbInfocode.SetRange("Infocode", 'DMOBILENO');
        // tbInfocode.SetFilter("Date", DateFilter);
        // tbInfocode.SetFilter("Amount", '<%1', 0);//Amount nhỏ hơn 0 là deposit in
        // if StoreFilter <> '' then tbInfocode.SetRange("Store No.", StoreFilter);
        // if PosTerminalFilter <> '' then tbInfocode.SetRange("POS Terminal No.", PosTerminalFilter);
        // tbInfocode.CalcSums(Amount);

        // Clear(Data);
        // Data."Item" := 'Deposit Prepayment(In)';
        // Data."Qty" := tbInfocode.Count();
        // Data."Amount" := -tbInfocode.Amount;
        // STTTemp := STTTemp + 1;
        // Data.STT := STTTemp;
        // KeyTemp := KeyTemp + 1;
        // Data."Key" := KeyTemp;
        // Data.insert(true);

        //Deposit Payment Normal(Out)------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(queryPayment);
        queryPayment.SetFilter("TH_DateFilter", DateFilter);
        if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
        queryPayment.SetRange("TSE_TenderTypeFilter", '25');
        queryPayment.Open;
        while queryPayment.Read do begin
            Quantity := queryPayment.CountTender;
            Amount := -queryPayment.SumPayment;
        end;

        Clear(Data);
        Data."Item" := 'Deposit Payment Normal(Out) - Incl Tax';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Deposit Payment Normal(Out) Non Tax------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(queryPayment);
        queryPayment.SetFilter("TH_DateFilter", DateFilter);
        if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
        queryPayment.SetRange("TSE_TenderTypeFilter", '25');
        queryPayment.Open;
        while queryPayment.Read do begin
            Quantity := queryPayment.CountTender;
            Amount := queryPayment.SumPaymentNonTax;
        end;

        Clear(Data);
        Data."Item" := 'Deposit Payment Normal(Out)';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Deposit Entry Normal------------------------------------------Vì không có deposit cho giá nên không tính được(đã confirm Chị Ngọc) 
        Amount := 0;
        Quantity := 0;
        Clear(Data);
        Data."Item" := 'Deposit Entry Normal(In)';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Deposit Cancle(Used)------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(queryPayment);
        queryPayment.SetFilter("TH_DateFilter", DateFilter);
        queryPayment.SetRange("SaleIsCancelFilter", true);
        queryPayment.SetRange("SaleIsReturnFilter", true);
        queryPayment.SetRange("TSE_TenderTypeFilter", '25');
        if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
        queryPayment.Open;
        while queryPayment.Read do begin
            Quantity := queryPayment.CountTender;
            Amount := queryPayment.SumAmountTender;
        end;

        Clear(Data);
        Data."Item" := 'Deposit Cancel(Out)';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Deposit Cancle(Unused)------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(querySaleTransCancelDepUnused);
        querySaleTransCancelDepUnused.SetFilter("TH_DateFilter", DateFilter);
        querySaleTransCancelDepUnused.SetRange("SaleIsCancelFilter", true);
        querySaleTransCancelDepUnused.SetRange("SaleIsReturnFilter", true);
        querySaleTransCancelDepUnused.SetRange("TSE_TypeIncomeFilter", '1312');
        if StoreFilter <> '' then querySaleTransCancelDepUnused.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querySaleTransCancelDepUnused.SetRange("PosterminalFilter", PosTerminalFilter);
        querySaleTransCancelDepUnused.Open;
        while querySaleTransCancelDepUnused.Read do begin
            Quantity := querySaleTransCancelDepUnused.CountDeposit;
            Amount := -querySaleTransCancelDepUnused.SumAmountDeposit;
        end;

        Clear(Data);
        Data."Item" := 'Deposit Cancel(In)';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Cash Gap
        Clear(Data);
        Data."Item" := 'Cash Gap';
        Data."Qty" := 0;
        Data."Amount" := CashGap;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Cash
        Clear(Data);
        Data.SetRange(Code, '1');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Cash';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Cash Normal------------------------------------------
        Amount := 0;
        Quantity := 0;
        Amount := 0;
        Quantity := 0;
        Clear(queryPayment);
        queryPayment.SetFilter("TH_DateFilter", DateFilter);
        if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
        queryPayment.SetRange("TSE_TenderTypeFilter", '1');
        queryPayment.Open;
        while queryPayment.Read do begin
            Quantity := queryPayment.CountTender;
            Amount := -queryPayment.SumAmountTender;
        end;

        Clear(Data);
        Data."Item" := 'Cash Normal';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Cash Return------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(queryPayment);
        queryPayment.SetFilter("TH_DateFilter", DateFilter);
        queryPayment.SetRange("SaleIsCancelFilter", false);
        queryPayment.SetRange("SaleIsReturnFilter", true);
        queryPayment.SetRange("TSE_TenderTypeFilter", '1');
        if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
        queryPayment.Open;
        while queryPayment.Read do begin
            Quantity := queryPayment.CountTender;
            Amount := -queryPayment.SumAmountTender;
        end;

        Clear(Data);
        Data."Item" := 'Cash Return';
        Data."Qty" := Quantity;
        Data."Amount" := -Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Cash Transfer
        Amount := 0;
        Quantity := 0;
        Clear(querySaleWithPayment);
        querySaleWithPayment.SetFilter("TH_DateFilter", DateFilter);
        querySaleWithPayment.SetRange("TH_TransTypeFilter", tbTransHeader."Transaction Type"::"Remove Tender");
        querySaleWithPayment.SetFilter("AmountFilter", '>0');
        querySaleWithPayment.SetFilter("TenderFilter", '9');
        if StoreFilter <> '' then querySaleWithPayment.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then querySaleWithPayment.SetRange("PosterminalFilter", PosTerminalFilter);
        querySaleWithPayment.Open;
        while querySaleWithPayment.Read do begin
            Quantity := querySaleWithPayment.TSE_Quantity;
            Amount := querySaleWithPayment.TSE_Amount;
        end;

        Clear(Data);
        Data."Item" := 'Cash Transfer';
        // Data."Qty" := QtyCashTransfer;
        // Data."Amount" := CashTransfer;
        Data."Qty" := Quantity;
        Data."Amount" := -Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Credit Card Normal------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(queryPayment);
        queryPayment.SetFilter("TH_DateFilter", DateFilter);
        if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
        queryPayment.SetFilter("TSE_TenderTypeFilter", '57|55|56|53|60|51|61|62|3|33|71|70');
        queryPayment.Open;
        while queryPayment.Read do begin
            Quantity := queryPayment.CountTender;
            Amount := -queryPayment.SumAmountTender;
        end;

        Clear(Data);
        Data."Item" := 'Credit Card Normal';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Credit Card Return------------------------------------------
        Amount := 0;
        Quantity := 0;
        Clear(queryPayment);
        queryPayment.SetFilter("TH_DateFilter", DateFilter);
        queryPayment.SetRange("SaleIsCancelFilter", false);
        queryPayment.SetRange("SaleIsReturnFilter", true);
        queryPayment.SetFilter("TSE_TenderTypeFilter", '57|55|56|53|60|51|61|62|3|33|71|70');
        if StoreFilter <> '' then queryPayment.SetRange("TH_StoreFilter", StoreFilter);
        if PosTerminalFilter <> '' then queryPayment.SetRange("PosterminalFilter", PosTerminalFilter);
        queryPayment.Open;
        while queryPayment.Read do begin
            Quantity := queryPayment.CountTender;
            Amount := -queryPayment.SumAmountTender;
        end;

        Clear(Data);
        Data."Item" := 'Credit Card Return';
        Data."Qty" := Quantity;
        Data."Amount" := Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Provided Points------------------------------------------ = sale point -  reutrn point
        Amount := 0;
        Quantity := 0;
        Clear(tbMemberPoint);
        // tbMemberPoint.SetFilter("Points", '>0'); lấy offset tất cả lại sale & cancel
        tbMemberPoint.SetFilter("Date", DateFilter);
        tbMemberPoint.SetRange("Entry Type", 0);
        if StoreFilter <> '' then tbMemberPoint.SetRange("Store No.", StoreFilter);
        if PosTerminalFilter <> '' then tbMemberPoint.SetRange("POS Terminal No.", PosTerminalFilter);
        tbMemberPoint.CalcSums(Points);
        Quantity := tbMemberPoint.Count();
        Amount := Amount + tbMemberPoint.Points;

        Clear(Data);
        Data."Item" := 'Provided Points';
        Data."Qty" := Quantity;
        Data."Amount" := -Amount;
        STTTemp := STTTemp + 1;
        Data.STT := STTTemp;
        KeyTemp := KeyTemp + 1;
        Data."Key" := KeyTemp;
        Data.insert(true);

        //Use Points------------------------------------------
        Clear(Data);
        Data.SetRange(Code, '11');
        if Data.FindFirst() then begin
            DAta.Item := 'Use Point';
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Use Point';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //VISA Taka Standard
        Clear(Data);
        Data.SetRange(Code, '57');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'VISA Taka Standard';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //VISA Taka Debit
        Clear(Data);
        Data.SetRange(Code, '55');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'VISA Taka Debit';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //VISA Taka Gold
        Clear(Data);
        Data.SetRange(Code, '56');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'VISA Taka Gold';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //JCB Taka
        Clear(Data);
        Data.SetRange(Code, '53');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'JCB Taka Standard';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Taka Rose Gift Card
        Clear(Data);
        Data.SetRange(Code, '60');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Taka Rose Gift Card';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Taka BP Gift Card
        Clear(Data);
        Data.SetRange(Code, '51');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Taka BP Gift Card';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Taka BP Gift Card
        Clear(Data);
        Data.SetRange(Code, '61');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'KPL Gift Card';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //SGC BP Reward GC
        Clear(Data);
        Data.SetRange(Code, '62');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'SGC BP Reward GC';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Credit Card
        Clear(Data);
        Data.SetRange(Code, '3');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Credit Card';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Other Credit Card
        Clear(Data);
        Data.SetRange(Code, '33');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Other Credit Card';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Bank Transfer
        Clear(Data);
        Data.SetRange(Code, '71');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Bank Transfer';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Supplier Voucher
        Clear(Data);
        Data.SetRange(Code, '21');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Supplier Voucher';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //Taka Voucher
        Clear(Data);
        Data.SetRange(Code, '20');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Taka Voucher';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;



        //CR Voucher sử dụng
        Clear(Data);
        Data.SetRange(Code, '23');
        if Data.FindFirst() then begin
            DAta.Item := 'Taka Credit Voucher';
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Taka Credit Voucher';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        //VN Pay
        Clear(Data);
        Data.SetRange(Code, '70');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'VNPay QR';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        // // Staff Allowance
        // Amount := 0;
        // Quantity := 0;
        // Clear(querQueSaleTransaction_staff);
        // querQueSaleTransaction_staff.SetFilter("TH_DateFilter", DateFilter);
        // if StoreFilter <> '' then querQueSaleTransaction_staff.SetRange("TH_StoreFilter", StoreFilter);
        // if PosTerminalFilter <> '' then querQueSaleTransaction_staff.SetRange("PosterminalFilter", PosTerminalFilter);
        // querQueSaleTransaction_staff.Open;
        // while querQueSaleTransaction_staff.Read do begin
        //     if querQueSaleTransaction_staff.TenderType = '80' then begin
        //         Clear(Data);
        //         DAta.Item := Format('Allow. Staff ' + format(querQueSaleTransaction_staff.DisPercent)) + '%';
        //         DAta.Code := '';
        //         Data.Amount := querQueSaleTransaction_staff.SumDisAmount;
        //         Data.Qty := querQueSaleTransaction_staff.Quantity;
        //         STTTemp := STTTemp + 1;
        //         Data.STT := STTTemp;
        //         KeyTemp := KeyTemp + 1;
        //         Data."Key" := KeyTemp;
        //         Data.Insert(true);
        //     end else if querQueSaleTransaction_staff.TenderType = '81' then begin
        //         Clear(Data);
        //         DAta.Item := Format('Allow. Group ' + format(querQueSaleTransaction_staff.DisPercent)) + '%';
        //         DAta.Code := '';
        //         Data.Amount := querQueSaleTransaction_staff.SumDisAmount;
        //         Data.Qty := querQueSaleTransaction_staff.Quantity;
        //         STTTemp := STTTemp + 1;
        //         Data.STT := STTTemp;
        //         KeyTemp := KeyTemp + 1;
        //         Data."Key" := KeyTemp;
        //         Data.Insert(true);
        //     end else if querQueSaleTransaction_staff.TenderType = '82' then begin
        //         Clear(Data);
        //         DAta.Item := Format('Allow. Member ' + format(querQueSaleTransaction_staff.DisPercent)) + '%';
        //         DAta.Code := '';
        //         Data.Amount := querQueSaleTransaction_staff.SumDisAmount;
        //         Data.Qty := querQueSaleTransaction_staff.Quantity;
        //         STTTemp := STTTemp + 1;
        //         Data.STT := STTTemp;
        //         KeyTemp := KeyTemp + 1;
        //         Data."Key" := KeyTemp;
        //         Data.Insert(true);
        //     end;
        // end;

        // Staff Allowance Total
        // Amount := 0;
        // Quantity := 0;
        // Clear(querQueSaleTransaction_staffTotal);
        // querQueSaleTransaction_staffTotal.SetFilter("TH_DateFilter", DateFilter);
        // if StoreFilter <> '' then querQueSaleTransaction_staffTotal.SetRange("TH_StoreFilter", StoreFilter);
        // if PosTerminalFilter <> '' then querQueSaleTransaction_staffTotal.SetRange("PosterminalFilter", PosTerminalFilter);
        // querQueSaleTransaction_staffTotal.Open;
        // while querQueSaleTransaction_staffTotal.Read do begin
        //     if querQueSaleTransaction_staffTotal.TenderType = '80' then begin
        //         Clear(Data);
        //         DAta.Item := Format('Staff Allowance');
        //         DAta.Code := '80';
        //         Data.Amount := querQueSaleTransaction_staffTotal.SumDisAmount;
        //         Data.Qty := querQueSaleTransaction_staffTotal.Quantity;
        //         STTTemp := STTTemp + 1;
        //         Data.STT := STTTemp;
        //         KeyTemp := KeyTemp + 1;
        //         Data."Key" := KeyTemp;
        //         Data.Insert(true);
        //     end else if querQueSaleTransaction_staffTotal.TenderType = '81' then begin
        //         Clear(Data);
        //         DAta.Item := Format('Group Allowance');
        //         DAta.Code := '81';
        //         Data.Amount := querQueSaleTransaction_staffTotal.SumDisAmount;
        //         Data.Qty := querQueSaleTransaction_staffTotal.Quantity;
        //         STTTemp := STTTemp + 1;
        //         Data.STT := STTTemp;
        //         KeyTemp := KeyTemp + 1;
        //         Data."Key" := KeyTemp;
        //         Data.Insert(true);
        //     end else if querQueSaleTransaction_staffTotal.TenderType = '82' then begin
        //         Clear(Data);
        //         DAta.Item := Format('Member Allowance');
        //         DAta.Code := '82';
        //         Data.Amount := querQueSaleTransaction_staffTotal.SumDisAmount;
        //         Data.Qty := querQueSaleTransaction_staffTotal.Quantity;
        //         STTTemp := STTTemp + 1;
        //         Data.STT := STTTemp;
        //         KeyTemp := KeyTemp + 1;
        //         Data."Key" := KeyTemp;
        //         Data.Insert(true);
        //     end;
        // end;

        Clear(Data);
        Data.SetRange(Code, '80');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Staff Allowance';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        Clear(Data);
        Data.SetRange(Code, '81');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Group Allowance';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        Clear(Data);
        Data.SetRange(Code, '82');
        if Data.FindFirst() then begin
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            Data.Modify(true);
        end else begin
            Clear(Data);
            DAta.Item := 'Member Allowance';
            DAta.Code := '';
            Data.Amount := 0;
            Data.Qty := 0;
            STTTemp := STTTemp + 1;
            Data.STT := STTTemp;
            KeyTemp := KeyTemp + 1;
            Data."Key" := KeyTemp;
            Data.Insert(true);
        end;

        // //Tính lại cancel transaction trừ deposit ra
        // Clear(Data);
        // Data.SetRange(Item, 'Deposit Cancel(Unused)');
        // if Data.FindFirst() then begin
        //     TinhLaiCancelTransQty := TinhLaiCancelTransQty + data.Qty;
        //     TinhLaiCancelTransAmount := TinhLaiCancelTransAmount + data.Amount;
        // end;

        // Clear(Data);
        // Data.SetRange(Item, 'Deposit Cancel(Used)');
        // if Data.FindFirst() then begin
        //     TinhLaiCancelTransQty := TinhLaiCancelTransQty + data.Qty;
        //     TinhLaiCancelTransAmount := TinhLaiCancelTransAmount + data.Amount;
        // end;

        // Clear(Data);
        // Data.SetRange(Item, 'Cancel Transaction');
        // if Data.FindFirst() then begin
        //     Data.Qty := Data.Qty - TinhLaiCancelTransQty;
        //     Data.Amount := Data.Amount - TinhLaiCancelTransAmount;
        //     Data.Modify();
        // end;


        Clear(Data);
    end;

    trigger OnInitReport()
    begin
        DateFilter := Format(Today());
        // StoreFilter := 'HCM';
    end;

    procedure ParseDateRange(InputText: Text): Text
    var
        FromDateStr, ToDateStr : Text;
        FromDate, ToDate : Date;
        StartPos, EndPos : Integer;
    begin
        // Tìm vị trí dấu ':' để lấy phần ngày
        StartPos := StrPos(InputText, ':');
        if StartPos = 0 then
            exit('');

        // Lấy phần chuỗi sau dấu ':'
        FromDateStr := DelStr(CopyStr(InputText, StartPos + 1, MaxStrLen(InputText)), 1, 0);
        FromDateStr := DELCHR(FromDateStr, '=', ' '); // Xóa khoảng trắng đầu

        // Nếu có dấu '..' thì là from date to date
        if StrPos(FromDateStr, '..') > 0 then begin
            // Tách chuỗi từ và đến
            ToDateStr := CopyStr(FromDateStr, StrPos(FromDateStr, '..') + 2, MaxStrLen(FromDateStr));
            FromDateStr := CopyStr(FromDateStr, 1, StrPos(FromDateStr, '..') - 1);

            Evaluate(FromDate, FromDateStr, 103); // 103 = dd/MM/yyyy
            Evaluate(ToDate, ToDateStr, 103);
            exit(Format(FromDate, 0, '<Day,2>/<Month,2>/<Year,4>') + '-' + Format(ToDate, 0, '<Day,2>/<Month,2>/<Year,4>'));
        end else begin
            Evaluate(FromDate, FromDateStr, 103);
            exit(Format(FromDate, 0, '<Day,2>/<Month,2>/<Year,4>'));
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
        StatementNoFilter: Text;
        DateFilter: Text;
        DateFormat: Text[100];
        StoreFilter: Text;
        PosTerminalFilter: Text;
        ProductSaleQty: Decimal;
        NonProductSaleQty: Decimal;
        Quantity: Decimal;
        Amount: Decimal;
        ApplicationManagement: Codeunit "Filter Tokens";

        DateFormatText: Text[200];

}

