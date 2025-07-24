query 50111 "CalSaleWithTenderTypeMember"
{
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Member Card No." = filter(<> ''), "Transaction Type" = const(2);
            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            dataitem(PaymentValue; "LSC Trans. Payment Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                // DataItemTableFilter = Quantity = filter('<0');
                SqlJoinType = InnerJoin;

                filter(TenderFilter; "Tender Type")
                {
                }
                column(TenderType; "Tender Type")
                {
                }
                column(TSE_Total_Amount; "Amount Tendered")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
            }
        }
    }
}

query 50112 "CalSaleWithTenderTypeNonMember"
{
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Member Card No." = filter(''), "Transaction Type" = const(2);

            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            dataitem(PaymentValue; "LSC Trans. Payment Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                SqlJoinType = InnerJoin;

                filter(TenderFilter; "Tender Type")
                {
                }

                column(TenderType; "Tender Type")
                {
                }
                column(TSE_Total_Amount; "Amount Tendered")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
            }
        }
    }
}

