query 50113 "QueEfficiency"
{
    elements
    {
        dataitem(tbData; "Consignment Entries")
        {
            // DataItemTableFilter = "Member Card No." = filter('');
            filter(TSE_DivisonFilter; "Division")
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

