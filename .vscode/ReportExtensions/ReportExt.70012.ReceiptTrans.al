reportextension 70012 WPReporReceipt extends "LSC Detailed Receipt"
{
    dataset
    {
        addfirst("Transaction Header")
        {
            dataitem("tbstaff"; "LSC Staff")
            {
                DataItemLink = "ID" = FIELD("Staff ID");
                column(Name_on_Receipt; "Name on Receipt")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                var
                    staff: Record "LSC Staff";
                begin
                    Clear(Name_on_Receipt);
                    staff.SetRange(ID, "Transaction Header"."Staff ID");
                    if staff.FindFirst() then
                        Name_on_Receipt := staff."Name on Receipt";
                end;
            }
        }
    }

    var
        Name_on_Receipt: text;

}
