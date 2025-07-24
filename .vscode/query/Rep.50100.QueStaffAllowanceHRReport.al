query 50100 "QueStaffAllowanceHRReport"
{
    elements
    {

        dataitem(trans; "wpStaffAllowanceEntry")
        {
            filter(staffFilter; "Staff Card No.")
            {
            }

            filter(DateFilter; Date)
            {
            }

            column(Transaction_No_; "Transaction No.")
            {

            }
            column(POSTerminal; "POS Terminal No.")
            {

            }
            column(Item; "POS Terminal No.")
            {

            }
            column(TSE_Total_Amount; "Sales Amount")
            {
                Method = Sum;
            }
        }
    }
}

