pageextension 50100 CustomerChatGPT extends "Customer Card"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(ChatGPTHistory; "ChatGPT Log FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Conversation Id" = field("ChatGPT Conversation Id"), "Source Record Id" = field("Record Id");
                Visible = HistoryEnabled;
            }
        }
        addlast(General)
        {
            field("ChatGPT Conversation Id"; Rec."ChatGPT Conversation Id")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Stores the conversation identifier used to link log entries.';
            }
            field("Record Id"; Rec.RecordId())
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(AskChatGPT)
            {
                Caption = 'Chiedi a ChatGPT';
                ApplicationArea = All;
                /// <summary>Builds a customer prompt and sends it to ChatGPT, showing the response.</summary>
                trigger OnAction()
                    var
                        PromptBuilder: Codeunit "ChatGPT Prompt Builder";
                        Connector: Codeunit "ChatGPT Connector";
                        Messages: JsonArray;
                        ResponseText: Text;
                        UserPrompt: Text;
                        ConversationId: Guid;
                    begin
                        ConversationId := Rec."ChatGPT Conversation Id";
                        UserPrompt := PromptBuilder.BuildSummaryPrompt(PromptBuilder.BuildCustomerContext(Rec));
                        Messages := PromptBuilder.ComposeMessages('You are a helpful Business Central assistant.', UserPrompt);
                        Connector.SendChat(Messages, ResponseText, ConversationId, Page::"Customer Card", Rec.RecordId());
                        if Rec."ChatGPT Conversation Id" <> ConversationId then begin
                            Rec."ChatGPT Conversation Id" := ConversationId;
                            Modify(true);
                        end;
                        Message(ResponseText);
                        CurrPage.Update(false);
                    end;
            }
        }
    }

    /// <summary>Initializes visibility flags based on setup settings.</summary>
    trigger OnOpenPage()
    var
        Setup: Record "ChatGPT Setup";
        SetupMgt: Codeunit "ChatGPT Setup Mgt";
    begin
        SetupMgt.GetSetup(Setup);
        HistoryEnabled := Setup."History Enabled";
    end;

var
    HistoryEnabled: Boolean;
}
