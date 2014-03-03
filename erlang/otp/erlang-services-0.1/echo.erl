-module(echo).
-author('Jesse E.I. Farmer <jesse@20bits.com>').

-export([listen/1]).

% Call echo:listen(Port) to start the service.
listen(Port) ->
	{ok, LSocket} = gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]),
	accept(LSocket).

% Wait for incoming connections and spawn the echo loop when we get one.
accept(LSocket) ->
    io:format("accept: start [LSocket ~p]~n",[LSocket]),
	{ok, Socket} = gen_tcp:accept(LSocket),
    io:format("accepted...~n",[]),
	spawn(fun() -> loop(Socket) end),
	accept(LSocket).

% Echo back whatever data we receive on Socket.
loop(Socket) ->
	case gen_tcp:recv(Socket, 0) of
		{ok, Data} ->
			gen_tcp:send(Socket, Data),
			loop(Socket);
		{error, closed} ->
			ok
	end.
