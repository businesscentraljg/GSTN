table 50001 "GSTN Search Staging"
{
    Caption = 'GSTN Search Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(2; "GSTIN"; Code[15]) { }
        // ---- BASIC DETAILS ----
        field(3; "Legal Name"; Text[200]) { }
        field(4; "Trade Name"; Text[200]) { }
        field(5; Status; Text[50]) { }
        field(6; "Taxpayer Type"; Text[50]) { }
        field(7; Constitution; Text[100]) { }
        field(8; "Registration Date"; Date) { }
        field(9; "Last Updated Date"; Date) { }
        field(10; "Cancellation Date"; Date) { }
        field(11; "E-Invoice Status"; Text[20]) { }

        // ---- JURISDICTION ----
        field(12; "State Jurisdiction"; Text[200]) { }
        field(13; "Centre Jurisdiction"; Text[200]) { }
        field(14; "State Jurisdiction Code"; Code[10]) { }
        field(15; "Centre Jurisdiction Code"; Code[10]) { }

        // ---- PRINCIPAL ADDRESS (FLATTENED) ----
        field(16; "Pr. Building Name"; Text[200]) { }
        field(17; "Pr. Street"; Text[200]) { }
        field(18; "Pr. Location"; Text[100]) { }
        field(19; "Pr. Door No."; Text[50]) { }
        field(20; "Pr. Floor No."; Text[50]) { }
        field(21; "Pr. District"; Text[100]) { }
        field(22; "Pr. State"; Text[100]) { }
        field(23; "Pr. Pincode"; Code[10]) { }
        field(24; "Pr. Latitude"; Text[30]) { }
        field(25; "Pr. Longitude"; Text[30]) { }
        field(26; "Pr. Nature of Business"; Text[100]) { }

        // ---- ARRAYS STORED AS JSON TEXT ----
        field(27; "Nature of Business (JSON)"; Blob) { }
        field(28; "Additional Address (JSON)"; Blob) { }
        // ---- AUDIT ----
        field(29; "Raw JSON Response"; Blob) { }
        field(30; "Created At"; DateTime) { }
        field(31; "Created By"; Text[50]) { }

    }
    keys
    {
        key(PK; "Customer No.")
        {
            Clustered = true;
        }
    }
}
