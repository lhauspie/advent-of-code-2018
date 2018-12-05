with Ada.Text_IO;
With Ada.Text_IO.Unbounded_IO;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Compare_Unbounded_String is
    A : Ada.Strings.Unbounded.Unbounded_String;
    B : Ada.Strings.Unbounded.Unbounded_String;
    gt : Boolean;
begin
    Ada.Text_IO.Put("Enter a string A: ");
    A := Ada.Strings.Unbounded.To_Unbounded_String(Ada.Text_IO.Get_Line);
    Ada.Text_IO.Put("Enter a string B: ");
    B := Ada.Strings.Unbounded.To_Unbounded_String(Ada.Text_IO.Get_Line);

    Ada.Text_IO.Put("For A variable: ");
    Ada.Text_IO.Unbounded_IO.Put_Line(A);

    Ada.Text_IO.Put("For B variable: ");
    Ada.Text_IO.Unbounded_IO.Put_Line(B);

    gt := A < B;
    Ada.Text_IO.Put_Line("Is A < B ? " & Boolean'Image(gt));
end Compare_Unbounded_String;