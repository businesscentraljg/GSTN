table 50000 "GSP Authentication Setup"
{
    Caption = 'GSP Authentication Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "GSP App ID"; Text[100])
        { }
        field(3; "GSP App Secret"; Text[100])
        { }

        field(4; "Access Token"; Text[2048])
        {
            Editable = false;
            ExtendedDatatype = Masked;
        }
        field(5; "Token Type"; Text[30])
        {
            Editable = false;
        }
        field(6; "Scope"; Text[50])
        {
            Editable = false;
        }
        field(7; "Token Expires At"; DateTime)
        {
            Editable = false;
        }
        field(8; "JTI"; Text[100])
        {
            Editable = false;
        }
        field(9; "Show Message"; Boolean)
        {
        }
        field(10; "Base URL"; Text[250])
        {
            Caption = 'Base URL';
        }
        field(11; "C Type"; Text[50])
        {
            Caption = 'Content Type';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
