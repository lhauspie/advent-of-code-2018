With Ada.Text_IO;
With Ada.Containers.Indefinite_Vectors;
With Ada.Strings.Fixed;
With Ada.Containers;
 
procedure tokenize is
  package String_Vector is new Ada.Containers.Indefinite_Vectors (Natural, String); use String_Vector;

  Procedure Split (Source, Pattern : in String; Accumulator: in out Vector) is
    Index : Integer := Ada.Strings.Fixed.Index (Source => Source, Pattern => Pattern);
  begin
    if Index = 0 then
      Accumulator.append (Source);
    else
      Accumulator.append (Source(Source'First..Source'First+Index-1));
      Split (
        Source => Source(Source'First+Index+1..Source'Last),
        Pattern => Pattern,
        Accumulator => Accumulator);
    end if;
  end Split;

  v : Vector;
begin
  Split ("coucou beuh", " ", v);
  for s of v loop
    Ada.Text_IO.Put_Line (s);
  end loop;
end tokenize;