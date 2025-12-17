pageextension 50101 SalesOrderChatGPT extends "Sales Order"
{
    layout
    {
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
        addlast(FactBoxes)
        {
            part(SalesChatGPTHistory; "ChatGPT Log FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Conversation Id" = field("ChatGPT Conversation Id"), "Source Record Id" = field("Record Id");
                Visible = HistoryEnabled;
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
                ApplicationArea = All;
                /// <summary>Builds a sales order prompt and sends it to ChatGPT, displaying the reply.</summary>
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
                        UserPrompt := PromptBuilder.BuildExplanationPrompt(PromptBuilder.BuildSalesOrderContext(Rec));
                        Messages := PromptBuilder.ComposeMessages('You are a helpful assistant for sales orders.', UserPrompt);
                        Connector.SendChat(Messages, ResponseText, ConversationId, Page::"Sales Order", Rec.RecordId());
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
    HistoryEnabled: Boolean;
}
