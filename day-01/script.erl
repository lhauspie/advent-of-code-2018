#!/usr/bin/env escript

% main(_) -> hello_world("input.txt").
% hello_world() -> io:fwrite("hello, world!\n").




% main([What]) -> io:format("~p\n", say_hello(What)).

% say_hello(What) ->
%     case What of
%         Value when Value == "hello" ->
%             Result = foo(Value),
%             ok; 
%         Value when Value == "goodbye" ->
%             Result = foo(Value),
%             ok  
%     end,
%     [Result].

% foo("hello") ->
%     "ohai";

% foo("goodbye") ->
%     "cya".




main(_) -> 
    io:format("~p\n", [calculate("input.txt")]).

calculate(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try calculate_all_lines(Device)
      after file:close(Device)
    end.

calculate_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> 0; % 0 because the frequency starts with 0
        Line -> list_to_integer(string:strip(Line, right, $\n)) + calculate_all_lines(Device)
    end.

