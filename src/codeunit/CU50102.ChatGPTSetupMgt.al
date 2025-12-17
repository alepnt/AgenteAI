codeunit 50102 "ChatGPT Setup Mgt"
{
    SingleInstance = true;

    /// <summary>Ensures the singleton setup record exists and returns it.</summary>
    procedure GetSetup(var Setup: Record "ChatGPT Setup")
    begin
        if not Setup.Get('SETUP') then begin
            Setup.Init();
            Setup."Primary Key" := 'SETUP';
            Setup.Insert();
        end;
    end;

    /// <summary>Retrieves the API key from the setup record or raises an error when missing.</summary>
    procedure GetApiKey(): Text
    var
        Setup: Record "ChatGPT Setup";
    begin
        GetSetup(Setup);
        if Setup."API Key" = '' then
            Error('API key is not configured.');

        exit(Setup."API Key");
    end;

    /// <summary>Checks whether an API key has been stored.</summary>
    procedure HasApiKey(): Boolean
    var
        Setup: Record "ChatGPT Setup";
    begin
        GetSetup(Setup);
        exit(Setup."API Key" <> '');
    end;

    /// <summary>Stores the API key and marks setup accordingly.</summary>
    procedure SetApiKey(ApiKey: Text)
    var
        Setup: Record "ChatGPT Setup";
    begin
        if ApiKey = '' then
            Error('The API key cannot be empty.');

        GetSetup(Setup);
        Setup."API Key" := ApiKey;
        Setup."API Key Stored" := true;
        Setup.Modify(true);
    end;

    /// <summary>Removes the stored API key and updates the setup flag.</summary>
    procedure ClearApiKey()
    var
        Setup: Record "ChatGPT Setup";
    begin
        if Setup.Get() then begin
            Setup."API Key" := '';
            Setup."API Key Stored" := false;
            Setup.Modify(true);
        end;
    end;
}
