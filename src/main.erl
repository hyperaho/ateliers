-module(main).
-export([run/1]).

run(File) ->
    case file:read_file(File) of 
        {ok, Code} ->
            Parsed = parser:do(Code),
            Transpiled = transpiler:do(Parsed),
            io:format("~s~n", [Transpiled]);
        _ -> throw(unexecpted_file)
    end, 
    init:stop().
        
