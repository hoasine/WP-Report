table 58049 "Member Sale Report"
{
    Access = Internal;
    Caption = 'Member Sale Report';
    DataClassification = CustomerContent;
    TableType = Temporary;
    ReplicateData = false;

    fields
    {
        field(1; "MemberCard"; text[100])
        {
            Caption = 'MemberCard';
            DataClassification = ToBeClassified;
        }
        field(2; "DateJoin"; Text[100])
        {
            Caption = 'DateJoin';
            DataClassification = ToBeClassified;
        }
        field(3; "MemberName"; text[100])
        {
            Caption = 'MemberName';
            DataClassification = ToBeClassified;
        }
        field(4; "TypeMember"; text[100])
        {
            Caption = 'TypeMember';
            DataClassification = ToBeClassified;
        }
        field(5; "Telephone"; text[100])
        {
            Caption = 'Telephone';
            DataClassification = ToBeClassified;
        }
        field(6; "Email"; text[100])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;
        }
        field(7; "Address"; text[100])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(8; "LastPurchase"; Text[100])
        {
            Caption = 'LastPurchase';
            DataClassification = ToBeClassified;
        }
        field(9; "CurrentPoint"; Decimal)
        {
            Caption = 'CurrentPoint';
            DataClassification = ToBeClassified;
        }
        field(10; "LastPointRedeemDate"; Text[100])
        {
            Caption = 'LastPointRedeemDate';
            DataClassification = ToBeClassified;
        }
        field(11; "TotalSale"; Decimal)
        {
            Caption = 'TotalSale';
            DataClassification = ToBeClassified;
        }
        field(12; "CurrentSale"; Decimal)
        {
            Caption = 'CurrentSale';
            DataClassification = ToBeClassified;
        }
        field(13; "TenderType"; text[100])
        {
            Caption = 'TenderType';
            DataClassification = ToBeClassified;
        }
        field(14; "AmountTender"; Decimal)
        {
            Caption = 'AmountTender';
            DataClassification = ToBeClassified;
        }
        field(15; "AccountNo"; text[100])
        {
            Caption = 'AccountNo';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; MemberCard, TenderType)
        {
            Clustered = true;
        }
    }
}


report 70023 "Member Sale Report"
{
    ApplicationArea = All;
    Caption = 'Member Sale Report';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = MemberSaleExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Data; "Member Sale Report")
        {
            // RequestFilterFields = "MemberCard", AccountNo, TypeMember, Telephone, Email;
            // DataItemTableView = sorting(MemberCard);
            column(MemberCard; MemberCard) { }
            column(DateJoin; DateJoin) { }
            column(MemberName; MemberName) { }
            column(TypeMember; TypeMember) { }
            column(Telephone; Telephone) { }
            column(Email; Email) { }
            column(Address; Address) { }
            column(LastPurchase; LastPurchase) { }
            column(CurrentPoint; CurrentPoint) { }
            column(LastPointRedeemDate; LastPointRedeemDate) { }
            column(TotalSale; TotalSale) { }
            column(CurrentSale; CurrentSale) { }
            column(TenderType; TenderType) { }
            column(AmountTender; AmountTender) { }
            column(DateFilter; DateFilter) { }

            trigger OnPreDataItem()
            var
                tbMemberAcount: Record "LSC Member Account";
                tbTender: Record "LSC Tender Type Setup";
                tbMemberContact: Record "LSC Member Contact";
                tbMemberShipcard: Record "LSC Membership Card";
                tbMemberSale: Record "LSC Member Sales Entry";
                tbMemberPoint: Record "LSC Member Point Entry";
                tbPayment: Record "LSC Trans. Payment Entry";
                tbTransHeader: Record "LSC Transaction Header";
                firstMonth: Date;
                tbInsert: Record "Member Sale Report";
                tbMemberShip: Record "LSC Membership Card";

                Window: Dialog;
                TotalTrans: Integer;
                Counter: Integer;
            begin
                clear(Data);
                Data.DeleteAll();

                Counter := 0;
                Window.Open(
                  'Number of Member #1###########\' +
                  'Processed              #2###########');

                Clear(tbMemberAcount);
                if AccountNoFilter <> '' then tbMemberAcount.SetRange("No.", Data.AccountNo);

                if CardNoFilter <> '' then begin
                    Clear(tbMemberShip);
                    tbMemberShip.SetRange("Card No.", CardNoFilter);
                    if tbMemberShip.FindFirst() then
                        tbMemberAcount.SetRange("No.", tbMemberShip."Account No.");
                end;

                if TelephoneFilter <> '' then begin
                    Clear(tbMemberContact);
                    tbMemberContact.SetRange("Phone No.", TelephoneFilter);
                    if tbMemberContact.FindFirst() then
                        tbMemberAcount.SetRange("No.", tbMemberContact."Account No.");
                end;

                if DateFilter <> '' then begin
                    tbMemberAcount.SetFilter("Date Filter", DateFilter);
                end;

                TotalTrans := tbMemberAcount.Count;
                Window.Update(1, TotalTrans);
                if tbMemberAcount.FindSet() then
                    repeat
                        Counter += 1;
                        if (Counter mod 100) = 0 then
                            Window.Update(2, Counter);

                        clear(tbInsert);

                        Clear(tbMemberShipcard);
                        tbMemberShipcard.SetRange("Account No.", tbMemberAcount."No.");
                        if tbMemberShipcard.FindSet() then begin
                            tbInsert.MemberCard := tbMemberShipcard."Card No.";
                        end;

                        if tbInsert.MemberCard <> '' then begin
                            tbInsert.Init();
                            tbMemberAcount.CalcFields("Total Sales", "Main Contact Name", "Balance");
                            tbInsert.TotalSale := tbMemberAcount."Total Sales";
                            tbInsert.DateJoin := FORMAT(tbMemberAcount."Date Activated", 0, '<Day,2>/<Month,2>/<Year4>');
                            tbInsert.MemberName := tbMemberAcount."Main Contact Name";
                            tbInsert.TypeMember := tbMemberAcount."Scheme Code";

                            Clear(tbMemberContact);
                            tbMemberContact.SetRange("Account No.", tbMemberAcount."No.");
                            if tbMemberContact.FindFirst() then begin
                                tbInsert.Telephone := tbMemberContact."Phone No.";
                                tbInsert.Email := tbMemberContact."E-Mail";
                                tbInsert.Address := tbMemberContact."Address";
                            end;

                            //Ngày mua cuối 
                            Clear(tbMemberSale);
                            tbMemberSale.SetRange("Member Account No.", tbMemberAcount."No.");
                            if tbMemberSale.FindLast() then begin
                                tbInsert.LastPurchase := FORMAT(tbMemberSale."Date", 0, '<Day,2>/<Month,2>/<Year4>');
                                // tbInsert.LastPurchase := tbMemberAcount."Last Sales Date";//kiem tra
                            end;

                            //Ngày đổi điểm cuối
                            Clear(tbMemberPoint);
                            tbMemberPoint.SetRange("Account No.", tbMemberAcount."No.");
                            if tbMemberPoint.FindLast() then begin
                                tbInsert.LastPointRedeemDate := FORMAT(tbMemberPoint."Date", 0, '<Day,2>/<Month,2>/<Year4>');
                            end;

                            tbInsert.CurrentPoint := tbMemberAcount.Balance;

                            //Ngày đổi điểm cuối
                            Clear(tbMemberSale);
                            tbMemberSale.SetRange("Member Account No.", tbMemberAcount."No.");
                            //Giá trị mua hàng từ đầu tháng tới ngày hiện tại
                            firstMonth := CalcDate('<-CM>', Today());
                            tbMemberSale.SetRange("Date", firstMonth, Today());
                            tbMemberSale.CalcSums("Gross Amount");
                            tbInsert.CurrentSale := -tbMemberSale."Gross Amount";

                            Clear(tbTender);
                            tbTender.SetRange("Default Function", tbTender."Default Function"::Normal);
                            if tbTender.FindSet() then
                                repeat
                                    Clear(Data);
                                    Data.MemberCard := tbInsert.MemberCard;
                                    Data.DateJoin := tbInsert.DateJoin;
                                    Data.MemberName := tbInsert.MemberName;
                                    Data.TypeMember := tbInsert.TypeMember;
                                    Data.Telephone := tbInsert.Telephone;
                                    Data.Email := tbInsert.Email;
                                    Data.Address := tbInsert."Address";
                                    Data.LastPurchase := tbInsert."LastPurchase";
                                    Data.LastPointRedeemDate := tbInsert."LastPointRedeemDate";
                                    Data.CurrentPoint := tbInsert.CurrentPoint;
                                    Data.CurrentSale := tbInsert."CurrentSale";
                                    Data.TotalSale := tbInsert."TotalSale";

                                    Data.TenderType := tbTender.Description;

                                    //Kiem tra filter
                                    Clear(tbTransHeader);
                                    Data.AmountTender := 0;
                                    tbTransHeader.SetRange("Member Card No.", data.MemberCard);
                                    repeat
                                        Clear(tbPayment);
                                        tbPayment.SetRange("POS Terminal No.", tbTransHeader."POS Terminal No.");
                                        tbPayment.SetRange("Store No.", tbTransHeader."Store No.");
                                        tbPayment.SetRange("Transaction No.", tbTransHeader."Transaction No.");
                                        tbPayment.SetRange("Receipt No.", tbTransHeader."Receipt No.");
                                        tbPayment.SetRange("Tender Type", tbTender.Code);
                                        tbPayment.CalcSums("Amount Tendered");

                                        Data.AmountTender := Data.AmountTender + tbPayment."Amount Tendered";
                                    until tbTransHeader.Next() = 0;
                                    Data.Insert();
                                until tbTender.Next() = 0;
                        end;
                    until tbMemberAcount.Next() = 0;
            end;

            trigger OnAfterGetRecord()
            begin

            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Member Sale Report';
        AboutText = 'AboutText Member Sale Report';
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
                    field("Card No"; CardNoFilter)
                    {
                        TableRelation = "LSC Membership Card";
                    }
                    field("Account No"; AccountNoFilter)
                    {
                        TableRelation = "LSC Item Special Groups";
                    }
                    // field("TypeMember"; TypeMemberFilter)
                    // {
                    //     TableRelation = "LSC Member Scheme";
                    // }
                    field("Telephone"; TelephoneFilter)
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
        layout(MemberSaleExcel)
        {
            Type = Excel;
            LayoutFile = '.vscode/ReportLayouts/Excel/Rep.70023.MemberSaleExcel.xlsx';
            Caption = 'Supplier Voucher Report';
            Summary = '.vscode/ReportLayouts/Excel/Rep.70023.MemberSaleExcel.xlsx';
        }
    }

    trigger OnPreReport()
    begin

    end;

    var
        DateFilter: Text[100];
        CardNoFilter: Text[100];
        AccountNoFilter: Text[100];
        TelephoneFilter: Text[100];
        TypeMemberFilter: Text[100];
        ApplicationManagement: Codeunit "Filter Tokens";
}