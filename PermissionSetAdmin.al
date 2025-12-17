namespace DefaultPublisher.CH_Platform_AI;

permissionset 50130 "CHATGPT-ADMIN"
{
    Assignable = true;
    Caption = 'ChatGPT Administrators';
    Permissions =
        table "ChatGPT Setup" = X,
        tabledata "ChatGPT Setup" = RIMDX,
        table "ChatGPT Log" = X,
        tabledata "ChatGPT Log" = RIMD,
        codeunit "ChatGPT Connector" = X,
        codeunit "ChatGPT Prompt Builder" = X,
        codeunit "ChatGPT Setup Mgt" = X,
        page "ChatGPT Setup" = X,
        page "ChatGPT Log List" = X,
        page "ChatGPT Log Card" = X,
        page "ChatGPT Log FactBox" = X,
        pageextension CustomerChatGPT = X,
        pageextension SalesOrderChatGPT = X;
}
