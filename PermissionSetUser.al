namespace DefaultPublisher.CH_Platform_AI;

permissionset 50131 "CHATGPT-USER"
{
    Assignable = true;
    Caption = 'ChatGPT Users';
    Permissions =
        table "ChatGPT Setup" = R,
        tabledata "ChatGPT Setup" = R,
        table "ChatGPT Log" = X,
        tabledata "ChatGPT Log" = RIMD,
        codeunit "ChatGPT Connector" = X,
        codeunit "ChatGPT Prompt Builder" = X,
        page "ChatGPT Setup" = R,
        page "ChatGPT Log List" = X,
        page "ChatGPT Log Card" = X,
        page "ChatGPT Log FactBox" = X,
        pageextension CustomerChatGPT = X,
        pageextension SalesOrderChatGPT = X;
}
