-module(parser).
-export([do/1]).

%% Représente une séquence de code brainfuck en quelque chose 
%% de lisible (et d'exécutable)

do(Str)                           -> parse([], Str).
parse(Acc,   <<>>)                -> lists:reverse(Acc);
parse(Acc,   <<$+, Rest/binary>>) -> parse(merge({plus,   1}, Acc), Rest); 
parse(Acc,   <<$-, Rest/binary>>) -> parse(merge({plus, -1},  Acc), Rest);
parse(Acc,   <<$<, Rest/binary>>) -> parse(merge({move,  -1}, Acc), Rest);
parse(Acc,   <<$>, Rest/binary>>) -> parse(merge({move,   1}, Acc), Rest);
parse(Acc,   <<$,, Rest/binary>>) -> parse(merge(input,       Acc), Rest);
parse(Acc,   <<$., Rest/binary>>) -> parse(merge(output,      Acc), Rest);
parse(Acc,   <<$], Rest/binary>>) -> { lists:reverse(Acc),          Rest};
parse(Acc,   <<$[, Rest/binary>>) -> 
    case parse([], Rest) of 
        {[{plus, -1}], Tail}      -> parse(merge(tozero, Acc), Tail);
        {Loop, Tail}              -> parse(merge({loop, Loop}, Acc), Tail);
        _                         -> {error, unclosed_loop}
    end;
parse(Acc, <<_ ,Rest/binary>>)    -> parse(Acc, Rest).

%% Fusionne une valeur avec l'accumulateur
merge({plus, X}, [{plus, Y}|Xs]) when X + Y == 0 -> Xs; 
merge({plus, X}, [{plus, Y}|Xs])                 -> [{plus, X+Y}|Xs];
merge({plus, X}, [Y|Xs])                         -> [{plus, X},Y|Xs];
merge({move, X}, [{move, Y}|Xs]) when X + Y == 0 -> Xs; 
merge({move, X}, [{move, Y}|Xs])                 -> [{move, X+Y}|Xs];
merge({move, X}, [Y|Xs])                         -> [{move, X},Y|Xs];
merge(Op,        [A|Xs])                         -> [Op,A|Xs];
merge(R, [])                                     -> [R].
