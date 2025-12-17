page 50101 "ChatGPT Log FactBox"
{
    PageType = ListPart;
    SourceTable = "ChatGPT Log";
    ApplicationArea = All;
    Caption = 'ChatGPT History';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                }
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
