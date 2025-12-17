page 50100 "ChatGPT Log Setup"
{
    PageType = Card;
    SourceTable = "ChatGPT Log";
    ApplicationArea = All;
    Caption = 'ChatGPT Log Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Conversation Id"; Rec."Conversation Id")
                {
                    ApplicationArea = All;
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = All;
                }
                field("Source Page Id"; Rec."Source Page Id")
                {
                    ApplicationArea = All;
                }
                field("Source Record Id"; Rec."Source Record Id")
                {
                    ApplicationArea = All;
                }
            }
            group(Payload)
            {
                field("Request"; Rec."Request")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Response"; Rec."Response")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
    }
}
