%%
%% A Simple (very!) ping client/server
%% Deryk Barker
%% May 2006.
%%

-module(ping).

-export([start_ping/0, server/1,  ping/0, ping/1]).

%%
%% The client
%% Sends messages to locahost
%%

ping() ->
    pinger (node(),10,0,0).

ping (Node) ->					%need to check that remote node is up
    monitor_node (Node, true),
    receive
	{nodedown, Node} ->			%they're not there
	    io:format ("Remote node ~w is down~n", [Node])
    after 0 ->					%they are there
	    pinger (Node, 10, 0, 0),
	    monitor_node (Node, false),
	    ok
    end.

%%
%% Connect to ping server and ping specified times
%% Calculate and return average round-trip time.
%%

pinger (_, Count, Count, Time)->
    io:format ("~w messages sent, average round-trip time ~w seconds~n", [Count, Time/(Count*1000000)]),
    ok;

pinger (Node, Count, Sofar, Time)->
    Line = ping,
    Before = now(),
    {ping, Node} ! {self(), ping, Line},	% Send the ping message
    receive
	{nodedown, Node} ->			%they're not there (any more)
	    io:format ("Remote node ~w has died~n", [Node]);
	{Seq, ping, Message}->
	    After = now(),
	    Diff = time:diff (Before, After),
	    io:format ("ping: ~B, ~w~n", [Seq, Message]),
	    pinger (Node, Count, Sofar+1, Time + Diff)				% Send another
    end.


%%
%% The server - keeps a message sequence number
%%

server(N) ->
    receive

        {Ping_PID, ping, Message} ->		% A plain old message to ping
            Ping_PID ! {N, ping, Message},	% Respond with sequence number
            io:format("ping server rev. 7 received  ~w from ~w~n", [Message, node (Ping_PID)]),
            server(N+1)				% Recurse and up seq no.
    end.

start_ping() ->					% Start our server and register its name
    register(ping, spawn(ping, server, [1])).
