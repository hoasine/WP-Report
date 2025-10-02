query 50114 "querrySaleConsignment"
{
    elements
    {
        dataitem(tbData; "Daily Consign. Sales Details")
        {
            // DataItemTableFilter = "Cost" = filter('<0');
            filter(TSE_TypeTransFilter; "Cost")
            {
            }
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
            column(TSE_Count; "Quantity")
            {
                Method = Sum;
            }
        }
    }
}

