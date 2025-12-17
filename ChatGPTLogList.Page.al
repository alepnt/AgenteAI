namespace DefaultPublisher.CH_Platform_AI;

page 50111 "ChatGPT Log List"
{
    PageType = List;
    SourceTable = "ChatGPT Log";
    ApplicationArea = All;
    Caption = 'ChatGPT Log';
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
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
                field("Request"; Rec."Request")
                {
                    ApplicationArea = All;
                }
                field("Response"; Rec."Response")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenCard)
            {
                Caption = 'Card';
                Image = Card;
                RunObject = page "ChatGPT Log Card";
                RunPageLink = "Entry No." = field("Entry No.");
                ApplicationArea = All;
            }
        }
    }
}
