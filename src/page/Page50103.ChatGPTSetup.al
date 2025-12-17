page 50103 "ChatGPT Setup"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "ChatGPT Setup";
    Caption = 'ChatGPT Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Default Model"; Rec."Default Model")
                {
                    ToolTip = 'Default OpenAI model to use for requests.';
                }
                field(Temperature; Rec.Temperature)
                {
                    ToolTip = 'Set the creativity of the response between 0 and 2.';
                }
                field("Max Tokens"; Rec."Max Tokens")
                {
                    ToolTip = 'Maximum number of tokens requested from the service.';
                }
                field("Endpoint"; Rec."Endpoint")
                {
                    ToolTip = 'HTTP endpoint for Chat Completions.';
                }
                field("Logging Enabled"; Rec."Logging Enabled")
                {
                    ToolTip = 'Enable logging of prompts and responses.';
                }
                field("History Enabled"; Rec."History Enabled")
                {
                    ToolTip = 'Show conversation history on pages when enabled.';
                }
                field("API Key"; Rec."API Key")
                {
                    ToolTip = 'Secret API key used to authenticate against ChatGPT.';
                    ExtendedDatatype = Masked;
                }
                field("API Key Stored"; Rec."API Key Stored")
                {
                    Editable = false;
                    ToolTip = 'Indicates whether an API key is stored in the setup record.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SetApiKey)
            {
                Caption = 'Imposta API Key';
                Image = Key;
                ApplicationArea = All;
                /// <summary>Prompts the user for a new API key and stores it securely.</summary>
                trigger OnAction()
                var
                    ApiKey: Text;
                    SetupMgt: Codeunit "ChatGPT Setup Mgt";
                    Dialog: Dialog;
                begin
                    if not Confirm('Do you want to set or replace the stored API key?', false) then
                        exit;

                    if not Dialog.Input('API Key', ApiKey) then
                        exit;

                    if ApiKey = '' then
                        Error('API key must be provided.');

                    SetupMgt.SetApiKey(ApiKey);
                    CurrPage.Update(false);
                end;
            }
            action(ClearApiKey)
            {
                Caption = 'Rimuovi API Key';
                Image = Delete;
                ApplicationArea = All;
                /// <summary>Removes the stored API key from setup.</summary>
                trigger OnAction()
                var
                    SetupMgt: Codeunit "ChatGPT Setup Mgt";
                begin
                    if not Confirm('Remove the stored API key?', false) then
                        exit;

                    SetupMgt.ClearApiKey();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    /// <summary>Ensures a setup record exists before the page renders.</summary>
    trigger OnOpenPage()
    var
        SetupMgt: Codeunit "ChatGPT Setup Mgt";
    begin
        SetupMgt.GetSetup(Rec);
    end;
}
