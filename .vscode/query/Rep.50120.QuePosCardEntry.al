query 50120 "QuePosCardEntry"
{
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Transaction Type" = const(2), "Entry Status" = filter('<>2');

            filter(TH_Member_Card_No_Filter; "Member Card No.")
            {
            }
            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            dataitem(trans; "LSC Trans. Payment Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                SqlJoinType = InnerJoin;

                filter(TSE_Tender; "Tender Type")
                {
                }
                dataitem(entry; "LSC POS Card Entry")
                {
                    DataItemLink = "Receipt No." = trans."Receipt No.", "Transaction No." = trans."Transaction No.", "Store No." = trans."Store No.", "POS Terminal No." = trans."POS Terminal No.", "Line No." = trans."Line No.";
                    SqlJoinType = InnerJoin;

                    filter(TSE_Tender_PointFilter; "Card Class")
                    {
                    }
                    // column(TSE_Amount; "Amount")
                    // {
                    // }
                    column(TSE_Amount_Card_Entry; "Amount")
                    {
                        Method = Sum;
                    }
                }
            }
        }
    }
}

