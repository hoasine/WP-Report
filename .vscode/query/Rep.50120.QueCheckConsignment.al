query 50120 "QueCheckConsignment"
{
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Transaction Type" = const(2);


            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            dataitem(trans; "LSC Trans. Sales Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                SqlJoinType = InnerJoin;
                filter(TSE_DivisonFilter; "Division Code")
                {
                }
                filter(TSE_ProductGroupFilter; "Retail Product Code")
                {
                }
                column(TSE_Total_Amount; "Net Amount")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
                column(TSE_Quantity_Amount)
                {
                    Method = Count;
                }
                dataitem(items; "Item")
                {
                    DataItemLink = "No." = trans."Item No.";
                    SqlJoinType = LeftOuterJoin;

                    filter(TSE_SpecialGroupFilter; "LSC Special Group Code")
                    {
                    }
                }

            }
        }
    }
}
