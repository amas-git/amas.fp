%%
%% A *very* simple "database"
%% In fact a list of tuples, of the form {key, data}
%%
%%
%% Deryk Barker, May 26, 2006
%%

-module (db).
-export ([new/0, insert/2, lookup/2, delete/2, first/1, rest/1]).

new () ->
    [].

insert ({Key, Data}, []) ->
    [{Key, Data}];
insert ({Key, Datanew}, [{Key, _}|T]) ->	%replace old value
    [{Key, Datanew} | T];
insert (NewData, [H|T]) ->
    [H|insert (NewData, T)].

lookup (_, []) ->
    notfound;
lookup (Key, [{Key, Data}|_]) ->
    {ok, Data};
lookup (Key, [_|T]) ->
    lookup (Key, T).

delete (_, []) ->
    notfound;
delete (Key, [{Key, _}|T]) ->
    T;
delete (Key, [H|T]) ->
    [H|delete (Key, T)].

first ([]) ->
    [];
first ([H|_]) ->
    H.

rest ([]) ->
    error;
rest ([_|T]) ->
    T.
