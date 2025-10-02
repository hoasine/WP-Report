query 50113 "QueEfficiency"
{
    elements
    {
        dataitem(tbData; "Daily Consign. Sales Details")
        {
            // DataItemTableFilter = "Member Card No." = filter('');
            filter(TSE_DivisonFilter; "Division")
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(TH_DateFilter; Date)
            {
            }
            filter(TSE_ProductGroupFilter; "Product Group")
            {
            }
            filter(TSE_CateagoryFilter; "Item Category")
            {
            }
            filter(TSE_BrandFilter; "Special Group")
            {
            }
            column(TSE_Total_Sale; "Total Incl Tax")
            {
                Method = Sum;
            }
            column(TSE_Profit; "Consignment Amount")
            {
                Method = Sum;
            }
            column(Brand; "Special Group")
            {
            }

            dataitem(tbWP; "WP MPG Setup")
            {
                DataItemLink = "Contract ID" = tbData."Contract ID";
                SqlJoinType = InnerJoin;

                column(SumMGP; "Expected Gross Profit")
                {
                    Method = Sum;
                }

                dataitem(tbArea; "WP Counter Area")
                {
                    DataItemLink = "Contract ID" = tbData."Contract ID";
                    SqlJoinType = InnerJoin;

                    column(TSE_Area; "Quantity_Area")
                    {
                        Method = Sum;
                    }


                }
            }
        }
    }
}

query 50116 "QueEfficiencyOnlyProfit"
{
    elements
    {
        dataitem(tbData; "Daily Consign. Sales Details")
        {
            // DataItemTableFilter = "Member Card No." = filter('');
            filter(TSE_DivisonFilter; "Division")
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(TH_DateFilter; Date)
            {
            }
            filter(TSE_ProductGroupFilter; "Product Group")
            {
            }
            filter(TSE_CateagoryFilter; "Item Category")
            {
            }
            filter(TSE_BrandFilter; "Special Group")
            {
            }
            column(TSE_Total_Sale; "Net Amount")
            {
                Method = Sum;
            }
            column(TSE_Profit; "Consignment Amount")
            {
                Method = Sum;
            }
            column(TSE_Cost; "Cost")
            {
                Method = Sum;
            }
            column(TSE_Quantity; "Quantity")
            {
                Method = Sum;
            }
        }
    }
}

//Profit hang Direct
// query 50115 "QueSaleWithTypeItem"
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
//             filter(PosterminalFilter; "POS Terminal No.")
//             {
//             }
//             dataitem(trans; "LSC Trans. Sales Entry")
//             {
//                 DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
//                 SqlJoinType = InnerJoin;
//                 // DataItemTableFilter = "Gen. Prod. Posting Group" = filter('=OUTR');
//                 filter(TSE_TyleSaleFilter; "Gen. Prod. Posting Group")//OUTR CONS
//                 {
//                 }
//                 filter(TSE_DivisonFilter; "Division Code")
//                 {
//                 }
//                 filter(TSE_ProductGroupFilter; "Retail Product Code")
//                 {
//                 }
//                 filter(TSE_CategoryFilter; "Item Category Code")
//                 {
//                 }
//                 column(TSE_Net_Amount; "Net Amount")
//                 {
//                     Method = Sum;
//                     ReverseSign = true;
//                 }
//                 column(TSE_Cost_Amount; "Cost Amount")
//                 {
//                     Method = Sum;
//                     ReverseSign = true;
//                 }

//                 column(TSE_Quantity_Amount; Quantity)
//                 {
//                     Method = Sum;
//                     ReverseSign = true;
//                 }
//             }
//         }
//     }
// }


query 50115 "QueryProfitDirect"
{
    elements
    {
        dataitem(tbEntry; "Value Entry")
        {
            DataItemTableFilter = "Item Ledger Entry Type" = const(1), "Gen. Prod. Posting Group" = filter('=OUTR');

            filter(TH_DateFilter; "Posting Date")
            {
            }
            filter(TH_StoreFilter; "Location Code")
            {
            }
            // filter(PosterminalFilter; "pos")
            // {
            // }
            column(TSE_Net_Amount; "Sales Amount (Actual)")
            {
                Method = Sum;
            }
            column(TSE_Cost_Amount; "Cost Amount (Actual)")
            {
                Method = Sum;
                ReverseSign = true;
            }

            column(TSE_Quantity_Amount; "Valued Quantity")
            {
                Method = Sum;
                ReverseSign = true;
            }

            dataitem(item; "Item")
            {
                DataItemLink = "No." = tbEntry."Item No.";
                SqlJoinType = InnerJoin;
                // DataItemTableFilter = "Gen. Prod. Posting Group" = filter('=OUTR');
                filter(TSE_TyleSaleFilter; "Gen. Prod. Posting Group")//OUTR CONS
                {
                }
                filter(TSE_DivisonFilter; "LSC Division Code")
                {
                }
                filter(TSE_ProductGroupFilter; "LSC Retail Product Code")
                {
                }
                filter(TSE_CategoryFilter; "Item Category Code")
                {
                }
            }
        }
    }
}
