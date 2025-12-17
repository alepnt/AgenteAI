tableextension 50100 "Customer ChatGPT Ext" extends Customer
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
