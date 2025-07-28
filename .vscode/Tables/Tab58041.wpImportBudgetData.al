table 58041 "wp Import Budget. Data"
{
    Caption = 'wp Import Budget. Data';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(34; "ClassCode"; text[100])
        {
            Caption = 'Class Code';
        }
        field(37; "DivisionCode"; text[100])
        {
            Caption = 'Division Code';
        }
        field(35; "Level"; Text[100])
        {
            Caption = 'Level';
        }
        field(38; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(39; "TotalSales"; Decimal)
        {
            Caption = 'TotalSales';
        }
        field(40; "StoreNo"; Text[100])
        {
            Caption = 'StoreNo';
        }
        field(55; "No. of Errors"; Integer)
        {
            Caption = 'No. of Errors';
            FieldClass = FlowField;
            Editable = false;

            CalcFormula = count("Import Purch. Error" where("Line No." = field("Line No.")));
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        lRec_PurchError: record "wp Import Budget. Error";
    begin
        lRec_PurchError.RESET;
        lRec_PurchError.SETRANGE("Line No.", "Line No.");
        lRec_PurchError.DeleteAll();
    end;

    procedure SetFieldStyle(FieldNumber: Integer): Text
    begin
        case FieldNumber of
            FieldNo("No. of Errors"):
                begin
                    CalcFields("No. of Errors");
                    if "No. of Errors" > 0 then
                        exit('Unfavorable');
                end;
        end;

        exit('');
    end;
}
