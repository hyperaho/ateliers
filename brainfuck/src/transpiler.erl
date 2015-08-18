-module(transpiler).
-export([do/1]).
-include("macro.hrl").

%% IterateurZ

trad({loop, I}, Acc) -> 
    R = transpile(I),         
    Acc ++ [(?LOOP_C(R))] ;

trad({plus, I}, Acc) -> R = integer_to_binary(I), Acc ++ [(?ADD_C(R)) ] ;
trad({move, I}, Acc) -> R = integer_to_binary(I), Acc ++ [(?MOV_C(R)) ] ;
trad(tozero,    Acc) ->                           Acc ++ [(?TOZERO_C) ] ;
trad(input,     Acc) ->                           Acc ++ [(?INP_C)    ] ;
trad(output,    Acc) ->                           Acc ++ [(?OUT_C)    ] .


%% Transpile une séquence en C 
%% (Peut être que Erlang est plus rapide ceci dit :| mais j'en doute...
%% LA FOTE O ZARRé ABSEN *)

transpile(Parsed) -> 
    R = lists:foldl(fun trad/2, [], Parsed),
    list_to_binary(R).
        
%% Transpilation (comme dirait l'Africain qui a sué !) complètes
do(Parsed) ->
    R = transpile(Parsed), 
    <<?HEADER_C/binary, 
       ?INIT_C/binary, 
       R/binary, ?FOOTER_C/binary>>.
