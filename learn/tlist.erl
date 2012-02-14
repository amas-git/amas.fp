-module(tlist).
-export([average/1,double/1,member/2, allbutlast/1]).

average(X) -> sum(X) / len(X).
        
sum([H|T]) -> H + sum(T);
sum([]) -> 0.
        
len([_|T]) -> 1 + len(T);
len([]) -> 0.

double([H|T]) -> [2*H|double(T)];
double([]) -> [].
        
member(H, [H|_]) -> true;
member(H, [_|T]) -> member(H, T);
member(_, []) -> false.

allbutlast ([]) ->
    [];
allbutlast ([_|T]) when T == [] ->
    [];
allbutlast ([H|T]) ->
    [H|allbutlast(T)].
