table 50100 "ChatGPT Log"
{
    Caption = 'ChatGPT Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            Description = 'Sequential identifier for each logged interaction.';
        }
        field(10; "Conversation Id"; Guid)
        {
            Caption = 'Conversation Id';
            DataClassification = SystemMetadata;
            Description = 'Groups related chat requests into the same conversation.';
        }
        field(20; "Created At"; DateTime)
        {
            Caption = 'Created At';
            DataClassification = SystemMetadata;
            Description = 'Timestamp indicating when the entry was recorded.';
        }
        field(30; "User Id"; Code[50])
        {
            Caption = 'User Id';
            DataClassification = SystemMetadata;
            Description = 'User who initiated the chat request.';
        }
        field(40; "Request"; Text[2048])
        {
            Caption = 'Request';
            DataClassification = CustomerContent;
            Description = 'JSON payload sent to the ChatGPT API.';
        }
        field(50; "Response"; Text[2048])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
            Description = 'Raw response content returned by ChatGPT.';
        }
        field(60; "Source Page Id"; Integer)
        {
            Caption = 'Source Page Id';
            DataClassification = SystemMetadata;
            Description = 'Page from which the request originated for traceability.';
        }
        field(70; "Source Record Id"; RecordId)
        {
            Caption = 'Source Record';
            DataClassification = SystemMetadata;
            Description = 'Record identifier associated with the request context.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Conversation; "Conversation Id", "Entry No.")
        {
        }
    }
}
