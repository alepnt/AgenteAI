codeunit 50104 Assert
{
    Subtype = Test;

    procedure AreEqual(Expected: Text; Actual: Text; Message: Text)
    begin
        if Expected <> Actual then
            Error(Message);
    end;

    procedure IsTrue(Condition: Boolean; Message: Text)
    begin
        if not Condition then
            Error(Message);
    end;
}
