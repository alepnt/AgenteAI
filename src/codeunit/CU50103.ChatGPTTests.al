codeunit 50103 "ChatGPT Tests"
{
    Subtype = Test;

    [Test]
    /// <summary>Verifies that sending chat without setup raises an error.</summary>
    procedure FailsWhenSetupMissing()
    var
        Connector: Codeunit "ChatGPT Connector";
        Messages: JsonArray;
        ResponseText: Text;
        ConversationId: Guid;
    begin
        DeleteSetup();
        Messages := BuildSimpleMessage();
        asserterror Connector.SendChat(Messages, ResponseText, ConversationId, 0, 0);
    end;

    [Test]
    /// <summary>Ensures the parser extracts message content from the API response.</summary>
    procedure ParsesResponseContent()
    var
        Connector: Codeunit "ChatGPT Connector";
        ResponseText: Text;
        Assert: Codeunit Assert;
    begin
        ResponseText := Connector.ParseResponse('{"choices":[{"message":{"content":"hello"}}]}');
        Assert.AreEqual('hello', ResponseText, 'Response content should be parsed.');
    end;

    [Test]
    /// <summary>Checks that payload creation includes core model and token fields.</summary>
    procedure BuildPayloadAddsCoreFields()
    var
        Connector: Codeunit "ChatGPT Connector";
        Messages: JsonArray;
        PayloadText: Text;
        PayloadObj: JsonObject;
        ModelValue: JsonValue;
        TokensValue: JsonValue;
        Assert: Codeunit Assert;
    begin
        Messages := BuildSimpleMessage();
        PayloadText := Connector.BuildPayload('gpt-4o-mini', Messages, 0.5, 1000);
        PayloadObj.ReadFrom(PayloadText);
        Assert.IsTrue(PayloadObj.Get('model', ModelValue), 'Model is missing.');
        Assert.IsTrue(PayloadObj.Get('max_tokens', TokensValue), 'Max tokens missing.');
    end;

    /// <summary>Builds a minimal messages array for use in test scenarios.</summary>
    local procedure BuildSimpleMessage(): JsonArray
    var
        Builder: Codeunit "ChatGPT Prompt Builder";
        Messages: JsonArray;
    begin
        Messages := Builder.ComposeMessages('system', 'user');
        exit(Messages);
    end;

    /// <summary>Removes the setup record to simulate missing configuration.</summary>
    local procedure DeleteSetup()
    var
        Setup: Record "ChatGPT Setup";
    begin
        if Setup.Get() then
            Setup.Delete();
    end;
}
