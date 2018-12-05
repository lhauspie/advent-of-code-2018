With Ada.Text_IO;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
With Ada.Strings.Unbounded.Text_IO;

With Ada.Containers;
With Ada.Containers.Generic_Array_Sort; 
With Ada.Containers.Indefinite_Vectors;
With Ada.Strings.Fixed;


Procedure Puzzle is
    type File_Lines_Array is Array (Natural range <>) of Ada.Strings.Unbounded.Unbounded_String;
    Procedure Sort is new Ada.Containers.Generic_Array_Sort (Natural, Ada.Strings.Unbounded.Unbounded_String, File_Lines_Array);


    package String_Vector is new Ada.Containers.Indefinite_Vectors (Natural, String); use String_Vector;
    Procedure Split (Source, Pattern : in String; Accumulator: in out Vector) is
        Index : Constant Integer := Ada.Strings.Fixed.Index (Source => Source, Pattern => Pattern);
    begin
        if Index = 0 then
            Accumulator.append (Source);
        else
            Accumulator.append (Source(Source'First..Index-1));
            Split (
                Source => Source(Index+1..Source'Last),
                Pattern => Pattern,
                Accumulator => Accumulator);
        end if;
    end Split;
    

    type Sleeps_Array is Array (0..59) of Integer;
    type Guard is
        record
            Id : Integer;
            Sleeps : Sleeps_Array := (others => 0);
            Total : Integer := 0;
        end record;

    Function Get_Id_Of_Guard (Guard_Line: Ada.Strings.Unbounded.Unbounded_String) return Integer is
        v : Vector;
    begin
        -- Ada.Strings.Unbounded.Text_IO.Put_Line (Guard_Line);
        Split (Ada.Strings.Unbounded.To_String (Guard_Line), " ", v);
        return Integer'Value(v.Element(3));
    end Get_Id_Of_Guard;

    Function Get_Time (Sleep_Line: Ada.Strings.Unbounded.Unbounded_String) return Integer is
        v : Vector;
    begin
        -- Ada.Strings.Unbounded.Text_IO.Put_Line (Sleep_Line);
        Split (Ada.Strings.Unbounded.To_String (Sleep_Line), " ", v);
        return Integer'Value(v.Element(1));
    end Get_Time;


    Function Count_Lines (File_Name: in String) return Integer is
        Nb_Lines : Integer := 0;
        File : Ada.Text_IO.File_Type;
    begin
        Ada.Text_IO.Open (File => File,
            Mode => Ada.Text_IO.In_File,
            Name => File_Name);
        While not Ada.Text_IO.End_Of_File (File) Loop
            Ada.Text_IO.Skip_Line (File => File);
            Nb_Lines := Nb_Lines + 1;
        end loop;
        Ada.Text_IO.Close (File => File);
        return Nb_Lines;
    end Count_Lines;


    Function Get_Lines (File_Name: in String) return File_Lines_Array is
        File : Ada.Text_IO.File_Type;
        Count : Constant Integer := Count_Lines (File_Name);
        Lines : File_Lines_Array (1..Count);
    begin
        Ada.Text_IO.Open (File => File,
              Mode => Ada.Text_IO.In_File,
              Name => File_Name);

        for I in 1..Count loop
            Lines(I) := Ada.Strings.Unbounded.Text_IO.Get_Line (File => File);
        end loop;

        Ada.Text_IO.Close (File => File);
        return Lines;
    end Get_Lines;


    function Strip (Input_String: String; Characters_To_Remove: String) return Ada.Strings.Unbounded.Unbounded_String is
        Keep: array (Character) of Boolean := (others => True);
        Output_String: Ada.Strings.Unbounded.Unbounded_String;
    begin
        for I in Characters_To_Remove'Range loop
            Keep(Characters_To_Remove(I)) := False;
        end loop;
        for J in Input_String'Range loop
            if Keep(Input_String(J)) then
                Append (Output_String, Input_String(J));
            end if;
        end loop;
        return Output_String;
    end Strip;

    type Guard_Array is Array(Positive range <>) of Guard;
    Function Get_Guard (Guards: in Guard_Array; Guard_Id: in Integer; Guard_Index: out Integer) return Guard is
    begin
        for I in Guards'Range loop
            if Guard_Id = Guards(I).Id then
                Guard_Index := I;
                return Guards(I);
            end if;
        end loop;
        Guard_Index := -1;
        return (Id => 0, Sleeps => (others => 0), Total => 0);
    end Get_Guard;

    Function Contains (Input_String: Ada.Strings.Unbounded.Unbounded_String; Pattern: String) return Boolean is
    begin
        return 1 = Ada.Strings.Unbounded.Count (Input_String, Pattern);
    end Contains;

    File_Name : Constant String := "input.txt";
    Lines : File_Lines_Array := Get_Lines (File_Name); -- Read the file line by line
    Nb_Guards : Integer := 0;
begin

    for I in Lines'Range loop
        -- Ada.Strings.Unbounded.Text_IO.Put_Line (Lines(I));
        Lines(I) := Strip (Ada.Strings.Unbounded.To_String (Lines(I)), "[]#:");
        if Contains (Lines(I), "Guard") then
            Nb_Guards := Nb_Guards + 1;
        end if;
    end loop;

    Sort (Lines);

    declare
        Guards : Guard_Array(1..Nb_Guards);
        First_Line_Idx_Of_Guard : Integer := 0;
        Last_Line_Idx_Of_Guard : Integer := 0;
    begin

        -- Init the list of Guards
        declare
            Guard_Index : Integer := Guards'First;
        begin
            First_Line_Idx_Of_Guard := Lines'First;
            Last_Line_Idx_Of_Guard := 0;
            for I in Lines'Range loop
                if Contains (Lines(I), "Guard") then
                    -- Ada.Strings.Unbounded.Text_IO.Put_Line (Lines(First_Line_Idx_Of_Guard));
                    Last_Line_Idx_Of_Guard := I - 1;
                    Guards(Guard_Index) := (
                        Id => Get_Id_Of_Guard(Lines(First_Line_Idx_Of_Guard)),
                        Sleeps => (others => 0),
                        Total => 0
                    );
                    Guard_Index := Guard_Index + 1;
                    First_Line_Idx_Of_Guard := I;
                end if;
            end loop;
        end;

        -- loop over sleep/awake to count sleeping time by Guard and by Hours
        declare
            Guard_Id : Integer;
            Current_Guard: Guard;
            Sleeping : Boolean := False;
            Start_Sleep : Integer := 0;
            End_Sleep : Integer := 0;
            Guard_Index : Integer;
            Sleepiest_Guard : Guard := (Id => -1, Sleeps => (others => 0), Total => 0);
            Sleepiest_Hour : Integer := 0; -- amount of time asleep
            Sleepiest_Hour_Index : Integer := 0; -- index of the previsous amount
        begin
            First_Line_Idx_Of_Guard := Lines'First;
            Last_Line_Idx_Of_Guard := 0;
            for I in Lines'Range loop
                if Contains (Lines(I), "Guard") then
                    Last_Line_Idx_Of_Guard := I - 1;
                    Guard_Id := Get_Id_Of_Guard (Lines(First_Line_Idx_Of_Guard));
                    Current_Guard := Get_Guard (Guards, Guard_Id, Guard_Index);

                    -- loop over the instruction of the Current_Guard
                    for J in First_Line_Idx_Of_Guard+1..Last_Line_Idx_Of_Guard loop
                        -- Ada.Strings.Unbounded.Text_IO.Put_Line (Lines(J));
                        if Sleeping then
                            -- save end_time
                            End_Sleep := Get_Time (Lines(J));
                            -- loop over Guard.Sleep from start_time(included) to end_time(excluded) to add 1 on each cell
                            -- End_Sleep-1 because `Note that guards count as asleep on the minute they fall asleep, and they count as awake on the minute they wake up`
                            for Z in Start_Sleep..End_Sleep-1 loop
                                Current_Guard.Sleeps(Z) := Current_Guard.Sleeps(Z) + 1;
                                Current_Guard.Total := Current_Guard.Total +1;
                            end loop;
                            -- Ada.Text_IO.Put_Line (Integer'Image(Current_Guard.Id) & " has sleept during " & Integer'Image(Current_Guard.Total));
                        else
                            -- save start_time
                            Start_Sleep := Get_Time (Lines(J));
                        end if;
                        Sleeping := Not (Sleeping);
                    end loop;

                    Guards (Guard_Index) := Current_Guard;
                    First_Line_Idx_Of_Guard := I;
                end if;
            end loop;

            -- find the sleepiest Guard
            for I in Guards'Range loop
                if Sleepiest_Guard.Total < Guards(I).Total then
                    Sleepiest_Guard := Guards(I);
                end if;
            end loop;
            Ada.Text_IO.Put_Line ("Sleepiest Guard is" & Integer'Image(Sleepiest_Guard.Id) & " with asleep duration of" & Integer'Image(Sleepiest_Guard.Total));

            -- find the sleepiest Hour
            for I in Sleepiest_Guard.Sleeps'Range loop
                if Sleepiest_Hour < Sleepiest_Guard.Sleeps(I) then
                    Sleepiest_Hour := Sleepiest_Guard.Sleeps(I);
                    Sleepiest_Hour_Index := I;
                end if;
            end loop;
            Ada.Text_IO.Put_Line ("Sleepiest Hour is" & Integer'Image(Sleepiest_Hour_Index) & " with asleep number of" & Integer'Image(Sleepiest_Hour));

            Ada.Text_IO.Put_Line ("Final result is:" & Integer'Image(Sleepiest_Hour_Index * Sleepiest_Guard.Id));
        end;
    end;
end Puzzle;
