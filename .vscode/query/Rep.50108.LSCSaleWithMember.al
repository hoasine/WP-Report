query 50108 "LSC Sale With Member"
{
    OrderBy = Ascending(TH_Store_No);
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Member Card No." = filter(<> ''), "Transaction Type" = const(2), "Entry Status" = filter('<>2');
            ;

            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(TH_DateFilter; Date)
            {
            }
            column(TH_Store_No; "Store No.")
            {
            }
            dataitem(Trans_Sales_Entry; "LSC Trans. Sales Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                // DataItemTableFilter = Quantity = filter('<0');
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Gen. Prod. Posting Group" = filter('<>SERVICES');

                filter(TSE_DivisonFilter; "Division Code")
                {
                }
                filter(TSE_ProductGroupFilter; "Retail Product Code")
                {
                }
                filter(TSE_CateagoryFilter; "Item Category Code")
                {
                }
                column(TSE_Total_Amount; "Total Rounded Amt.")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
            }
        }
    }
}


query 50109 "LSC Sale With Non Member"
{
    OrderBy = Ascending(TH_Store_No);
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Member Card No." = filter(''), "Transaction Type" = const(2), "Entry Status" = filter('<>2');
            ;

            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(TH_DateFilter; Date)
            {
            }
            column(TH_Store_No; "Store No.")
            {
            }
            dataitem(Trans_Sales_Entry; "LSC Trans. Sales Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                // DataItemTableFilter = Quantity = filter('<0');
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Gen. Prod. Posting Group" = filter('<>SERVICES');

                filter(TSE_DivisonFilter; "Division Code")
                {
                }
                filter(TSE_ProductGroupFilter; "Retail Product Code")
                {
                }
                filter(TSE_CateagoryFilter; "Item Category Code")
                {
                }
                column(TSE_Total_Amount; "Total Rounded Amt.")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
            }
        }
    }
}

// query 50110 "Querry LSC Sale Total"
// {
//     elements
//     {
//         dataitem(Transaction_Header; "LSC Transaction Header")
//         {
//             DataItemTableFilter = "Transaction Type" = const(2), "Entry Status" = filter('<>2');
//             ;

//             filter(TH_DateFilter; Date)
//             {
//             }
//             filter(TH_StoreFilter; "Store No.")
//             {
//             }
//             dataitem(Trans_Sales_Entry; "LSC Trans. Sales Entry")
//             {
//                 DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
//                 // DataItemTableFilter = Quantity = filter('<0');
//                 SqlJoinType = InnerJoin;
//                 DataItemTableFilter = "Gen. Prod. Posting Group" = filter('<>SERVICES');

//                 filter(TSE_DivisonFilter; "Division Code")
//                 {
//                 }
//                 filter(TSE_ProductGroupFilter; "Retail Product Code")
//                 {
//                 }
//                 filter(TSE_CateagoryFilter; "Item Category Code")
//                 {
//                 }
//                 column(TSE_Total_Amount; "Net Amount")
//                 {
//                     Method = Sum;
//                     ReverseSign = true;
//                 }
//                 dataitem(items; "Item")
//                 {
//                     DataItemLink = "No." = Trans_Sales_Entry."Item No.";
//                     SqlJoinType = LeftOuterJoin;

//                     filter(TSE_SpecialGroupFilter; "LSC Special Group Code")
//                     {
//                     }
//                 }
//             }
//         }
//     }
// }