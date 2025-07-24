pageextension 70013 "Ext Consignment Document" extends "Consignment Document"
{
    actions
    {
        addbefore(POSStatementRpt)
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
        }
    }
}
