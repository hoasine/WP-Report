query 50102 "QueSaleProduct"
{
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Payment" = filter('<>0'), "Transaction Type" = const(2), "Entry Status" = filter('<>2');
            ;

            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }

            column(SumPayment; "Payment")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(SumPaymentNonTax; "Net Amount")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(CountTransaction)
            {
                Method = Count;
            }
            dataitem(trans; "LSC Trans. Sales Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                DataItemTableFilter = "Gen. Prod. Posting Group" = filter('<>SERVICES');

                SqlJoinType = InnerJoin;

                column(SumNetAmount; "Net Amount")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
                column(SumGrossAmount; "Total Rounded Amt.")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
                column(SumCostAmount; "Cost Amount")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
                column(SumDiscountAmount; "Discount Amount")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
                column(CountSaleItem)
                {
                    Method = Count;
                }
            }
        }
    }
}

query 50101 "QueSaleTransactionList"
{
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Payment" = filter('<>0'), "Transaction Type" = const(2), "Entry Status" = filter('<>2');

            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(SaleIsReturnFilter; "Sale Is Return Sale")
            {
            }
            filter(SaleIsCancelFilter; "Sale Is Cancel Sale")
            {
            }
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            column(SumPayment; "Payment")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(SumPaymentNonTax; "Net Amount")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(CountTrans)
            {
                Method = Count;
            }
            dataitem(PaymentValue; "LSC Trans. Payment Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                SqlJoinType = InnerJoin;

                filter(TSE_TenderTypeFilter; "Tender Type")
                {
                }
                column(SumAmountTender; "Amount Tendered")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
                column(CountTender)
                {
                    Method = Count;
                }
            }
        }
    }
}

query 50103 "QueSaleTransCancel"
{
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Payment" = filter('<>0'), "Transaction Type" = const(2), "Entry Status" = filter('<>2');
            ;

            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(SaleIsReturnFilter; "Sale Is Return Sale")
            {
            }
            filter(SaleIsCancelFilter; "Sale Is Cancel Sale")
            {
            }
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            column(SumPayment; "Payment")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(SumPaymentNonTax; "Net Amount")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(CountTrans)
            {
                Method = Count;
            }
        }
    }
}

query 50104 "QueSaleTransCancelDepUnused"
{
    elements
    {
        dataitem(Transaction_Header; "LSC Transaction Header")
        {
            DataItemTableFilter = "Payment" = filter('<>0'), "Transaction Type" = const(2), "Entry Status" = filter('<>2');

            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(SaleIsReturnFilter; "Sale Is Return Sale")
            {
            }
            filter(SaleIsCancelFilter; "Sale Is Cancel Sale")
            {
            }
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            column(SumPayment; "Payment")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(SumPaymentNonTax; "Net Amount")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(CountTrans)
            {
                Method = Count;
            }
            dataitem(transIncome; "LSC Trans. Inc./Exp. Entry")
            {
                DataItemLink = "Transaction No." = Transaction_Header."Transaction No.", "Store No." = Transaction_Header."Store No.", "POS Terminal No." = Transaction_Header."POS Terminal No.";
                SqlJoinType = InnerJoin;

                filter(TSE_TypeIncomeFilter; "No.")
                {
                }
                column(SumAmountDeposit; "Amount")
                {
                    Method = Sum;
                    ReverseSign = true;
                }
                column(CountDeposit)
                {
                    Method = Count;
                }
            }
        }
    }
}

query 50105 "QueSaleTransaction_staff"
{
    elements
    {
        dataitem(staff; "wpStaffAllowanceEntry")
        {
            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            column("DisPercent"; "Discount %")
            {

            }
            column(SumDisAmount; "Discount Amount")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(Quantity)
            {
                Method = Count;
            }
            dataitem(staffBudget; "wpStaffBudgetMaintenance")
            {
                DataItemLink = "ID" = staff."Staff Allowance ID";
                SqlJoinType = InnerJoin;

                column(TenderType; "Tender Type Code")
                {
                }

                // filter(TenderType; "Tender Type Code")
                // {
                // }
            }
        }
    }
}

query 50106 "QueSaleTransaction_staffTotal"
{
    elements
    {
        dataitem(staff; "wpStaffAllowanceEntry")
        {
            filter(TH_DateFilter; Date)
            {
            }
            filter(TH_StoreFilter; "Store No.")
            {
            }
            filter(PosterminalFilter; "POS Terminal No.")
            {
            }
            column(SumDisAmount; "Discount Amount")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(Quantity)
            {
                Method = Count;
            }
            dataitem(staffBudget; "wpStaffBudgetMaintenance")
            {
                DataItemLink = "ID" = staff."Staff Allowance ID";
                SqlJoinType = InnerJoin;

                column(TenderType; "Tender Type Code")
                {
                }
            }
        }
    }
}

query 50107 "QueIncom"
{
    elements
    {
        dataitem(incomEntry; "LSC Trans. Inc./Exp. Entry")
        {
            filter(TH_TypeNonProductSaleFilter; "No.")
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
            column(SumAmount; "Amount")
            {
                Method = Sum;
                ReverseSign = true;
            }
            column(CountItem)
            {
                Method = Count;
            }
        }
    }
}

