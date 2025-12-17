codeunit 50101 "ChatGPT Prompt Builder"
{
    /// <summary>Creates a user role message containing the provided prompt.</summary>
    procedure BuildUserMessage(Prompt: Text): JsonObject
    var
        Message: JsonObject;
    begin
        Message.Add('role', 'user');
        Message.Add('content', Prompt);
        exit(Message);
    end;

    /// <summary>Creates a system role message to steer model behavior with context.</summary>
    procedure BuildSystemMessage(Context: Text): JsonObject
    var
        Message: JsonObject;
    begin
        Message.Add('role', 'system');
        Message.Add('content', Context);
        exit(Message);
    end;

    /// <summary>Builds a concise textual context for the current customer record.</summary>
    procedure BuildCustomerContext(var Customer: Record Customer): Text
    begin
        exit(StrSubstNo('Customer %1 (%2) located in %3 with balance %4.', Customer.Name, Customer."No.", Customer.City, Customer.Balance));
    end;

    /// <summary>Builds a concise textual context for the current sales order record.</summary>
    procedure BuildSalesOrderContext(var SalesHeader: Record "Sales Header"): Text
    begin
        exit(StrSubstNo('Sales order %1 for customer %2 dated %3 with total amount %4.', SalesHeader."No.", SalesHeader."Sell-to Customer Name", SalesHeader."Order Date", SalesHeader."Amount Including VAT"));
    end;

    /// <summary>Produces a user prompt asking for a short summary of the provided entity context.</summary>
    procedure BuildSummaryPrompt(EntityContext: Text): Text
    begin
        exit(StrSubstNo('Provide a short summary and key insights for: %1', EntityContext));
    end;

    /// <summary>Produces a user prompt requesting an explanation tailored for colleagues.</summary>
    procedure BuildExplanationPrompt(EntityContext: Text): Text
    begin
        exit(StrSubstNo('Explain the data for %1 in simple terms a new colleague can understand.', EntityContext));
    end;

    /// <summary>Produces a user prompt that asks for a list of actionable suggestions.</summary>
    procedure BuildSuggestionPrompt(EntityContext: Text): Text
    begin
        exit(StrSubstNo('Give three action suggestions based on %1', EntityContext));
    end;

    /// <summary>Creates a ready-to-send messages array containing system and user prompts.</summary>
    procedure ComposeMessages(SystemPrompt: Text; UserPrompt: Text): JsonArray
    var
        Messages: JsonArray;
    begin
        Messages.Add(BuildSystemMessage(SystemPrompt));
        Messages.Add(BuildUserMessage(UserPrompt));
        exit(Messages);
    end;
}
