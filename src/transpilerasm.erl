-module(transpilerasm).
-export([do/1]).

-include("macro-asm.hrl").


trad({loop, I}, {Acc, Lbl}) -> 
    A = integer_to_binary(Lbl + 1),
    B = integer_to_binary(Lbl + 2),
    R = transpile(I),
    {Acc ++ [(?LOOP_ASM(A, B, R))], Lbl + 37};

   
trad({plus, I}, {Acc, Lbl}) -> 
    R = integer_to_binary(I), 
    {Acc ++ [(?ADD_ASM(R))], Lbl};

trad({move, I}, {Acc, Lbl}) when I < 0 ->         
    R = integer_to_binary(abs(I)), 
    {Acc ++ [(?DECREASE_ASM(R))], Lbl};

trad({move, I}, {Acc, Lbl}) -> 
    R = integer_to_binary(I), 
    {Acc ++ [(?INCREASE_ASM(R))], Lbl};

trad(output, {Acc, Lbl}) ->  {Acc ++ [(?PUTCHAR_ASM)], Lbl} ;
trad(tozero, {Acc, Lbl}) ->  {Acc ++ [(?TOZERO_ASM) ], Lbl} ;
trad(input,  {Acc, Lbl}) ->  {Acc ++ [(?GETCHAR_ASM)], Lbl} .
 

transpile(Parsed) -> 
    {R, _} = lists:foldl(fun trad/2, {[], 42}, Parsed),
    list_to_binary(R).
        
do(Parsed) ->
    R = transpile(Parsed), 
    <<?ENTRY_POINT_ASM/binary, 
       R/binary, ?CLOSED_POINT_ASM/binary>>.
