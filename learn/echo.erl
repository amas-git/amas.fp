%%
%% A Simple (very!) echo server
%% Deryk Barker
%% May 2006.
%%

-module(echo).

-export([start_echo/0, server/1,  echo/0, echo/1]).

%%
%% The client
%% Sends messages to locahost
%%

echo() ->
    echoclient (node()).

echo(Node) ->			% is remote up?
    monitor_node (Node, true),
    receive
	{nodedown, Node} ->			%they're not there at all
	    io:format ("Remote node ~w is down~n", [Node])
    after 0 ->					%they are there
	    echoclient (Node),			%do the business
	    monitor_node (Node, false),		%stop checking
	    ok
    end.

echoclient (Node) ->
    Line = list_to_atom(strip_nl (io:get_line('echo> '))),
    case Line of
	quit ->					%time to go - but leave server alone
	    ok;
	finished ->				%tell server to quit - don't expect a reply
	    {echo, Node} ! {self(), echo, finished},
	    ok;
	Message ->				%keep sending
	    {echo, Node} ! {self(), echo, Message},	% Send a message
	    receive
		{nodedown, Node} ->			%they're not there at all
		    io:format ("Remote node ~w is down~n", [Node]);
		reloaded ->
		    io:format ("Server has reloaded~n", []),
		    echoclient (Node);		% Send another
		{Seq, echo, Message}->
		    io:format ("echo: ~B, ~w~n", [Seq, Message]),
		    echoclient (Node)		% Send another

	    end
    end.


%%
%% The server - keeps a message sequence number
%%

server(N) ->
    receive
        {_, echo, 'finished'} ->				% Time to shut down
            io:format("echo server: finished~n", []),
	    ok;
	
	{Echo_PID, echo, 'reload'} ->			% Reload server - fresh copy  
	    io:format ("echo server: reloading~n", []),
	    Echo_PID ! reloaded,		% Tell client
	    echo:server (N);			% Reload and don't up seq number

        {Echo_PID, echo, Message} ->		% A plain old message to echo
            Echo_PID ! {N, echo, Message},	% Respond with sequence number
            io:format("echo server rev. 7 received  ~w from ~w~n", [Message, node (Echo_PID)]),
            server(N+1)				% Recurse and up seq no.
    end.

start_echo() ->					% Start our server and register its name
    register(echo, spawn(echo, server, [1])).

%%
%% This function stips the newline (which is the final item) from a string list
%%
%% The obvious:
%%	strip_nl (String) ->
%%	    lists:sublist (String, length (String) - 1).
%% Involves traversing the list twice, so this is hopefully more efficient

strip_nl ([]) ->					%shouldn't happen
    [];
strip_nl ([_|T]) when T == [] ->
    [];
strip_nl ([H|T]) ->
    [H|strip_nl(T)].

