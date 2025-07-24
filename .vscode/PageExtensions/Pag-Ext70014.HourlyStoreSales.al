pageextension 70014 "Ext LSC Hourly Store Sales" extends "LSC Hourly Store Sales"
{
    actions
    {
        addbefore("&Update")
        {
            action(ExportMGP)
            {
                Caption = 'Hourly Store Sales Report';
                ToolTip = 'Hourly Store Sales Report';
                ApplicationArea = All;
                Image = ExportToExcel;
                // Promoted = true;
                // PromotedCategory = Category5;
                // PromotedIsBig = true;
                // Ellipsis = true;

                trigger OnAction()
                var
                    ConsignHeader: Record "LSC Hourly Distr Work Table";
                begin
                    // ConsignHeader.Reset();
                    // ConsignHeader.SetRange("Document No.", Rec."Document No.");
                    // if ConsignHeader.FindFirst() then;
                    Report.RunModal(70014, true, false, ConsignHeader);
                end;
            }
        }
    }
}
