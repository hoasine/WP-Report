pageextension 70015 "Ext Consignment Document List" extends "Consignment Document List"
{
    actions
    {
        addbefore(Card)
        {
            action(ExportMGP)
            {
                Caption = 'MGP Monthly Report';
                ToolTip = 'MGP Monthly Report';
                ApplicationArea = All;
                Image = ExportToExcel;
                // Promoted = true;
                // PromotedCategory = Category5;
                // PromotedIsBig = true;
                // Ellipsis = true;

                trigger OnAction()

                begin
                    Report.RunModal(70013, true, false);
                end;
            }

            action(ExportMGPAll)
            {
                Caption = 'Monthly Report For Expected Profit';
                ToolTip = 'Monthly Report For Expected Profit';
                ApplicationArea = All;
                Image = ExportToExcel;
                // Promoted = true;
                // PromotedCategory = Category5;
                // PromotedIsBig = true;
                // Ellipsis = true;

                trigger OnAction()
                var
                    ConsignHeader: Record "Consignment Billing Entries";
                begin
                    ConsignHeader.Reset();
                    ConsignHeader.SetRange("Document No.", Rec."Document No.");
                    if ConsignHeader.FindFirst() then;
                    Report.RunModal(70015);
                end;
            }
        }
    }
}
