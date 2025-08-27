query 50114 "Daily Sale Report for Mgt"
{
    elements
    {
        dataitem(tbData; "LSC Transaction Header")
        {
            DataItemTableFilter = "Transaction Type" = const(2), "Entry Status" = filter('<>2');
            ;
            filter(TH_DateFilter; Date)
            {
            }
            filter(StoreFilter; "Store No.")
            {
            }
            column(TSE_Total_Sale; "Net Amount")
            {
                Method = Sum;
            }
        }
    }
}

query 50115 "Daily Sale Mgt Customer"
{
    elements
    {
        dataitem(tbData; "LSC Transaction Header")
        {
            DataItemTableFilter = "Transaction Type" = const(2), "Entry Status" = filter('<>2');
            ;
            filter(TH_DateFilter; Date)
            {
            }
            filter(StoreFilter; "Store No.")
            {
            }
            column(TSE_Count_Customer)
            {
                Method = Count;
            }
        }
    }
}

//Không dùng
// query 50116 "Daily Customer With DCP"
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
//             filter(StoreFilter; "Store No.")
//             {
//             }
//             column(TSE_Count_Customer)
//             {
//                 Method = Count;
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
//                 column(TSE_Total_Amount; "Total Rounded Amt.")
//                 {
//                     Method = Sum;
//                     ReverseSign = true;
//                 }
//             }
//         }
//     }
// }
