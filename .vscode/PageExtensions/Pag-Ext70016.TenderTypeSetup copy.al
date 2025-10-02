pageextension 70016 WPTenderTypeSetupExt extends "LSC Tender Type Setup List"
{
    layout
    {
        addafter("Default Currency Tender")
        {
            field("Is Credit Card"; Rec."Is Credit Card")
            {
                ApplicationArea = All;
            }
        }
    }
}
