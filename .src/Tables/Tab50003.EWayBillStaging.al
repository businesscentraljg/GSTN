table 50003 "EWay Bill Staging"
{
    Caption = 'EWay Bill Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Document No."; Code[20]) { }
        field(3; "Success"; Boolean) { }
        field(4; "Message"; Text[250]) { }
        field(5; "Eway Bill No"; Text[50]) { }
        field(6; "Eway Bill Date"; Text[100]) { }
        field(7; "Valid Upto"; Text[100]) { }
        field(8; "Alert"; Text[100]) { }
        field(9; "Request Id"; Text[50]) { }
        field(10; "GSTIN Used"; Code[15]) { }
        field(11; "Request DateTime"; DateTime) { }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
