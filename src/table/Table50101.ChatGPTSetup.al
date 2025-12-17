namespace DefaultPublisher.CH_Platform_AI;

table 50101 "ChatGPT Setup"
{
    Caption = 'ChatGPT Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
            Description = 'Internal key used to keep a single setup record.';
        }
        field(10; "Default Model"; Text[50])
        {
            Caption = 'Default Model';
            DataClassification = CustomerContent;
            Description = 'Stores the default OpenAI model identifier for chat requests.';
        }
        field(20; Temperature; Decimal)
        {
            Caption = 'Temperature';
            DataClassification = CustomerContent;
            InitValue = 0.7;
            Description = 'Controls response creativity passed to the ChatGPT API.';
        }
        field(30; "Max Tokens"; Integer)
        {
            Caption = 'Max Tokens';
            DataClassification = CustomerContent;
            Description = 'Defines the maximum number of tokens requested per completion.';
        }
        field(40; "Logging Enabled"; Boolean)
        {
            Caption = 'Enable Logging';
            DataClassification = SystemMetadata;
            Description = 'Determines whether prompts and responses are persisted to the log.';
        }
        field(50; "History Enabled"; Boolean)
        {
            Caption = 'Enable History';
            DataClassification = SystemMetadata;
            Description = 'Shows conversation history FactBoxes when enabled.';
        }
        field(55; "API Key"; Text[250])
        {
            Caption = 'API Key';
            DataClassification = Credentials;
            ExtendedDatatype = Masked;
            Description = 'Stores the secret ChatGPT API key for authenticated requests.';
        }
        field(60; "API Key Stored"; Boolean)
        {
            Caption = 'API Key Stored';
            Editable = false;
            DataClassification = SystemMetadata;
            Description = 'Indicates whether an API key is present in setup.';
        }
        field(80; "Endpoint"; Text[100])
        {
            Caption = 'Endpoint';
            DataClassification = CustomerContent;
            InitValue = 'https://api.openai.com/v1/chat/completions';
            Description = 'Holds the HTTP endpoint used to reach the ChatGPT service.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    /// <summary>Initializes the primary key with the fixed identifier when missing.</summary>
    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'SETUP';
    end;
}
