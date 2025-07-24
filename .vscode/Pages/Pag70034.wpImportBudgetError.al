page 70034 BudgetError
{
    ApplicationArea = All;
    Caption = 'Import Budget. Error';
    PageType = List;
    SourceTable = "wp Import Budget. Error";
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Error Description"; Rec."Error Description")
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
                }
            }
        }
    }
}
