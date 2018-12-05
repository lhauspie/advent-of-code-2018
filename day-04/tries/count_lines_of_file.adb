with Ada.Text_IO; use Ada.Text_IO;

-- with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
-- with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;

-- Unbounded_String

Procedure Count_Lines_Of_File is
    Count : Integer;

    Function Count_Lines (File_Name: in String) return Integer is
        Nb_Lines : Integer := 0;
        File : File_Type;
    begin
        Open (File => File,
              Mode => In_File,
              Name => File_Name);
        While not End_Of_File (File) Loop
            Skip_Line (File => File);
            Nb_Lines := Nb_Lines + 1;
        end loop;
        return Nb_Lines;
    end Count_Lines;

begin
    Count := Count_Lines("count_lines_of_file.adb");
    Put_Line (integer'Image(Count));
end Count_Lines_Of_File;
