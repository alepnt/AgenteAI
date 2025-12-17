codeunit 50100 "ChatGPT Connector"
{
    SingleInstance = true;

    [IntegrationEvent(false, false)]
    /// <summary>Fires before the HTTP request is sent so extensions can adjust the payload or headers.</summary>
    local procedure OnBeforeSendRequest(var Request: HttpRequestMessage; RequestBody: Text; Setup: Record "ChatGPT Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    /// <summary>Fires after a response is received to allow subscribers to react to or inspect it.</summary>
    local procedure OnAfterReceiveResponse(RequestBody: Text; var Response: HttpResponseMessage; ResponseBody: Text)
    begin
    end;

    /// <summary>Builds the JSON payload for the Chat Completions API using the provided parameters.</summary>
    procedure BuildPayload(Model: Text; Messages: JsonArray; Temperature: Decimal; MaxTokens: Integer): Text
    var
        Payload: JsonObject;
    begin
        Payload.Add('model', Model);
        Payload.Add('messages', Messages);
        if Temperature <> 0 then
            Payload.Add('temperature', Temperature);
        if MaxTokens > 0 then
            Payload.Add('max_tokens', MaxTokens);

        exit(Format(Payload));
    end;

    /// <summary>Sends a chat request, validates setup, and optionally logs the interaction.</summary>
    procedure SendChat(Messages: JsonArray; var ResponseText: Text; var ConversationId: Guid; SourcePageId: Integer; SourceRecordId: RecordId)
    var
        Setup: Record "ChatGPT Setup";
        SetupMgt: Codeunit "ChatGPT Setup Mgt";
        HttpClient: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestHeaders: HttpHeaders;
        BodyText: Text;
        ResponseBody: Text;
        IsSuccess: Boolean;
    begin
        SetupMgt.GetSetup(Setup);
        if Setup."Default Model" = '' then
            Error('Default model must be configured.');
        if not SetupMgt.HasApiKey() then
            Error('API key is missing.');

        if IsNullGuid(ConversationId) then
            ConversationId := CreateGuid();

        BodyText := BuildPayload(Setup."Default Model", Messages, ChooseTemperature(Setup), Setup."Max Tokens");

        Request.SetRequestUri(Setup."Endpoint");
        Request.Method := 'POST';
        Content.WriteFrom(BodyText);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        Request.Content := Content;
        Request.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', StrSubstNo('Bearer %1', SetupMgt.GetApiKey()));

        OnBeforeSendRequest(Request, BodyText, Setup);

        IsSuccess := HttpClient.Send(Request, Response);
        if not IsSuccess then
            Error('Unable to reach ChatGPT service.');

        Response.Content().ReadAs(ResponseBody);
        OnAfterReceiveResponse(BodyText, Response, ResponseBody);

        if not Response.IsSuccessStatusCode() then
            HandleHttpError(Response, ResponseBody);

        ResponseText := ParseResponse(ResponseBody);

        if Setup."Logging Enabled" then
            LogRequest(ConversationId, BodyText, ResponseText, SourcePageId, SourceRecordId);
    end;

    /// <summary>Extracts the first message content from the ChatGPT JSON response.</summary>
    procedure ParseResponse(ResponseBody: Text): Text
    var
        JsonResponse: JsonObject;
        ChoicesToken: JsonToken;
        Choices: JsonArray;
        ChoiceToken: JsonToken;
        ChoiceObject: JsonObject;
        MessageToken: JsonToken;
        MessageObj: JsonObject;
        ContentToken: JsonToken;
    begin
        if not JsonResponse.ReadFrom(ResponseBody) then
            Error('Invalid response format.');

        if not JsonResponse.Get('choices', ChoicesToken) then
            Error('The service response does not contain choices.');

        Choices := ChoicesToken.AsArray();

        if not Choices.Get(0, ChoiceToken) then
            Error('The service response does not contain any choice.');

        ChoiceObject := ChoiceToken.AsObject();
        if not ChoiceObject.Get('message', MessageToken) then
            Error('The service response does not contain a message.');
        MessageObj := MessageToken.AsObject();
        if not MessageObj.Get('content', ContentToken) then
            Error('The service response does not contain content.');

        exit(ContentToken.AsValue().AsText());
    end;

    /// <summary>Returns the temperature configured in setup.</summary>
    local procedure ChooseTemperature(Setup: Record "ChatGPT Setup"): Decimal
    begin
        exit(Setup.Temperature);
    end;

    /// <summary>Raises an error containing HTTP status and response details when the service fails.</summary>
    local procedure HandleHttpError(var Response: HttpResponseMessage; ResponseBody: Text)
    var
        ErrorText: Text;
    begin
        ErrorText := StrSubstNo('ChatGPT returned an error (%1): %2', Response.HttpStatusCode(), ResponseBody);
        Error(ErrorText);
    end;

    /// <summary>Creates a log entry that captures the request, response, and originating context.</summary>
    local procedure LogRequest(ConversationId: Guid; RequestBody: Text; ResponseText: Text; SourcePageId: Integer; SourceRecordId: RecordId)
    var
        Log: Record "ChatGPT Log";
    begin
        Log.Init();
        Log."Conversation Id" := ConversationId;
        Log."Created At" := CurrentDateTime();
        Log."User Id" := UserSecurityId();
        Log."Request" := CopyStr(RequestBody, 1, MaxStrLen(Log."Request"));
        Log."Response" := CopyStr(ResponseText, 1, MaxStrLen(Log."Response"));
        Log."Source Page Id" := SourcePageId;
        Log."Source Record Id" := SourceRecordId;
        Log.Insert();
    end;
}
