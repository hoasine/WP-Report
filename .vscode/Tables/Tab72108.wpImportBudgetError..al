table 72108 "wp Import Budget. Error"
{
    Caption = 'wp Import Budget. Error';
    LookupPageId = PurchError;
    DrillDownPageID = PurchError;
    ReplicateData = false;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';

        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Error Description"; Text[500])
        {
            Caption = 'Error Description';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }


}
