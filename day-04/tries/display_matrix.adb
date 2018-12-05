with Ada.Text_IO; use Ada.Text_IO;


Procedure Display_Matrix is
    Procedure Print_Lines(Num_Lines, Num_Chars: Natural; c: Character) is
    begin
        for i in 1 .. Num_Lines loop
            for j in 1 .. Num_Chars loop
                Put (c);
            end loop;
            New_Line;
        end loop;
    end Print_Lines;
begin
    Print_Lines (2, 20, '-');
    Put_Line ("===============");
    Print_Lines (3, 20, '*');
end Display_Matrix;