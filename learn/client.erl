-module (client).
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
    Input = strip_nl (io:get_line('lab3> ')),
    Function = list_to_atom(string:sub_word(Input, 1)),
    RawArgs = [Cb || Cb <- string:sub_word(Input, 2), Cb /= $[, Cb /= $] ],
    ArgAtoms = [list_to_atom(A) || A <- string:tokens(RawArgs, ",")],
    case Function of
	quit ->					%time to go - but leave server alone
	    ok;
	finished ->				%tell server to quit - don't expect a reply
	    {lab3, Node} ! {self(), lab3, finished},
	    ok;
	reload ->				%tell server to reload
	    {lab3, Node} ! {self(), lab3, reload},
	    runclient (Node);
	Message ->				%a genuine (?) function  - send to server
	    {lab3, Node} ! {self(), lab3, {Message, ArgAtoms}},
	    receive
		{lab3, {ok, Result}} ->
		    io:format ("Received ~w~n", [Result]),
		    runclient (Node);		%recurse
		{lab3, {error, Error}}->
		    io:format ("Received error ~w~n", [Error]),
		    runclient (Node);
		Any ->
		    io:format ("Unexpected reply: ~w~n", Any)
	    end
    end.

%
% Function which we can use to strip the newline from an input string
%
    
strip_nl ([]) ->
    [];
strip_nl ([_|T]) when T == [] ->
    [];
strip_nl ([H|T]) ->
    [H|strip_nl(T)].
