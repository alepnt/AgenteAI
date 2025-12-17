tableextension 50101 "Sales Header ChatGPT Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "ChatGPT Conversation Id"; Guid)
        {
            Caption = 'ChatGPT Conversation Id';
            DataClassification = SystemMetadata;
        }
    }
}
