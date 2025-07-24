query 50117 "QueDailySaleReport"
{
    elements
    {
        dataitem(trans; "LSC Trans. Sales Entry")
        {
            // DataItemTableFilter = "Member Card No." = filter('');
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(TSE_DivisonFilter; "Division Code")
            {
            }
            filter(TSE_ProductGroupFilter; "Retail Product Code")
            {
            }
            filter(TH_DateFilter; Date)
            {
            }
            column(TSE_Total_Amount; "Total Rounded Amt.")
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
                SqlJoinType = InnerJoin;

                filter(TSE_SpecialGroupFilter; "LSC Special Group Code")
                {
                }
            }

        }
    }
}

query 50118 "QueCustumerReportCount"
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
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            column(TSE_Quantity_Custumer)
            {
                Method = Count;
            }
            dataitem(PaymentValue; "LSC Trans. Sales Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                SqlJoinType = InnerJoin;

                filter(TSE_DivisonFilter; "Division Code")
                {
                }
                filter(TSE_ProductGroupFilter; "Retail Product Code")
                {
                }
                dataitem(itemsDetail; "Item")
                {
                    DataItemLink = "No." = PaymentValue."Item No.";
                    SqlJoinType = InnerJoin;

                    filter(TSE_SpecialGroupFilter; "LSC Special Group Code")
                    {
                    }
                }
            }
        }
    }
}


