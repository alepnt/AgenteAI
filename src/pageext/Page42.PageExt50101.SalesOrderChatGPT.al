pageextension 50101 SalesOrderChatGPT extends "Sales Order"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(SalesChatGPTHistory; "ChatGPT Log FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Conversation Id" = field("ChatGPT Conversation Id"), "Source Record Id" = field(RecId);
                Visible = HistoryEnabled;
            }
        }
        addlast(General)
        {
            field("ChatGPT Conversation Id"; ConversationId)
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Stores the conversation identifier used to link log entries.';
            }
            field(RecId; Rec.RecordId())
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Keeps the current record identifier for logging purposes.';
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action(AskChatGPT)
            {
                Caption = 'Chiedi a ChatGPT';
                Image = Chat;
                ApplicationArea = All;
                /// <summary>Builds a sales order prompt and sends it to ChatGPT, displaying the reply.</summary>
                trigger OnAction()
                var
                    PromptBuilder: Codeunit "ChatGPT Prompt Builder";
                    Connector: Codeunit "ChatGPT Connector";
                    Messages: JsonArray;
                    ResponseText: Text;
                    UserPrompt: Text;
                begin
                    UserPrompt := PromptBuilder.BuildExplanationPrompt(PromptBuilder.BuildSalesOrderContext(Rec));
                    Messages := PromptBuilder.ComposeMessages('You are a helpful assistant for sales orders.', UserPrompt);
                    Connector.SendChat(Messages, ResponseText, ConversationId, Page::"Sales Order", Rec.RecordId());
                    Message(ResponseText);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    /// <summary>Loads setup to control FactBox visibility for the current session.</summary>
    trigger OnOpenPage()
    var
        Setup: Record "ChatGPT Setup";
        SetupMgt: Codeunit "ChatGPT Setup Mgt";
    begin
        SetupMgt.GetSetup(Setup);
        HistoryEnabled := Setup."History Enabled";
    end;

    var
        ConversationId: Guid;
        HistoryEnabled: Boolean;
}
