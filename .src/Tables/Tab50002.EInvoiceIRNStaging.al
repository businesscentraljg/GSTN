table 50002 "E-Invoice IRN Staging"
{
    Caption = 'E-Invoice IRN Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Document Type"; Option)
        {
            OptionMembers = Invoice,CreditMemo;
        }
        field(3; "Document No."; Code[20]) { }
        field(4; "Posting Date"; Date) { }

        // REQUEST
        field(5; "Request JSON"; Blob) { }
        field(6; "Request DateTime"; DateTime) { }

        // RESPONSE
        field(7; "Response JSON"; Blob) { }
        field(8; "Success"; Boolean) { }
        field(9; "Message"; Text[250]) { }

        // IRN DETAILS
        field(10; "IRN"; Text[100]) { }
        field(11; "Ack No."; BigInteger) { }
        field(12; "Ack Date"; Text[100]) { }
        field(13; "EWB No."; BigInteger) { }
        field(14; "EWB Valid Till"; Text[100]) { }

        // STATUS
        field(15; "HTTP Status Code"; Integer) { }
        field(16; "Error Text"; Text[250]) { }
        field(17; "Request Id"; Text[50]) { }
        field(18; "GSTIN Used"; Code[15]) { }
        field(20; "Signed Invoice"; Blob) { }
        field(21; "Signed QR Code"; Blob) { }
        field(22; "IRN Status"; Text[50]) { }
        field(23; "EWB Date"; Text[100]) { }
        field(24; "Remarks"; Text[250]) { }
        field(25; "InfCd"; Text[250]) { }
        field(26; "Desc"; Text[250]) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
