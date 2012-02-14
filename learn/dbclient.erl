-module (dbclient).
-export ([client/0, client/1]).

client () ->
    runclient (node()).				%% talk to our own node

client(Node) ->					% is remote up?
    monitor_node (Node, true),
    receive
	{nodedown, Node} ->			%they're not there at all
	    io:format ("Remote node ~w is down~n", [Node])
    after 0 ->					%they are there
	    runclient (Node),			%do the business
	    monitor_node (Node, false),		%stop checking
	    ok
    end.

runclient (Node) ->
    Input = strip_nl (io:get_line('dbclient> ')), 
    Function = list_to_atom(string:sub_word(Input, 1)),	%must be there
    Key = list_to_atom(string:sub_word(Input, 2)),	%might
    Value = list_to_atom(string:sub_word(Input, 3)),	%might
    case {Function, Key, Value} of
	{quit, _, _} ->					%we're out of here
	    ok;
	{finished, _, _} ->
	    {dbase, Node} ! {self (), dbase, finished}, %there's no reply
	    ok;
	{list, _, _} ->
	    {dbase, Node} ! {self (), dbase, list},
	    get_dblist (),
	    runclient (Node);
	{reload, _, _} ->
	    {dbase, Node} ! {self (), dbase, reload},
	    runclient (Node);
	{delete, [], _} ->
	    io:format ("Must provide a key to delete~n"),
	    runclient (Node);
	{delete, Key, __} ->
	    {dbase, Node} ! {self(), dbase, {delete, Key}},
	    get_response (),
	    runclient (Node);
	{insert, Key, Value} ->
	    {dbase, Node} ! {self(), dbase, {insert, {Key, Value}}},
	    get_response (),
	    runclient (Node);
	{lookup, Key, _} ->
	    {dbase, Node} ! {self(), dbase, {lookup, Key}},
	    get_response (),
	    runclient (Node);	
	{Any, _, _} ->
	    io:format ("Unknown command ~w~n", [Any]),
	    runclient (Node)
	end.

%%
%% Get and process response from server
%%

get_response () ->
    receive
	{dbase, {lookup, {ok, Value}}} ->
	    io:format ("~w~n", [Value]);
	{dbase, {lookup, notfound}} ->
	    io:format ("Key not found in database~n", []);
	Any ->
	    Any
    end.

get_dblist () ->
    receive
	{dbase, {list, {Key, Value}}} ->	%db listing - more (possibly) to come
	    io:format ("~w: ~w~n", [Key, Value]),
	    get_dblist ();
	{dbase, {list, ok}} ->
	    ok
    end.

%%
%% Function which we can use to strip the newline from an input string
%%

strip_nl ([]) ->
    [];
strip_nl ([_|T]) when T == [] ->
    [];
strip_nl ([H|T]) ->
    [H|strip_nl(T)].
