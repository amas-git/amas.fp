-module(chargen).
-author('Jesse E.I. Farmer <jesse@20bits.com>').

-export([listen/1]).

-define(START_CHAR, 33).
-define(END_CHAR, 127).
-define(LINE_LENGTH, 72).

-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).

% Call chargen:listen(Port) to start the service.
listen(Port) ->
	{ok, LSocket} = gen_tcp:listen(Port, ?TCP_OPTIONS),
	accept(LSocket).

% Wait for incoming connections and spawn the chargen loop when we get one.
accept(LSocket) ->
	{ok, Socket} = gen_tcp:accept(LSocket),
	spawn(fun() -> loop(Socket) end),
	accept(LSocket).

loop(Socket) ->
	loop(Socket, ?START_CHAR).

loop(Socket, ?END_CHAR) ->
	loop(Socket, ?START_CHAR);
loop(Socket, StartChar) ->
	Line = make_line(StartChar),
	case gen_tcp:send(Socket, Line) of
		{error, _Reason} ->
			exit(normal);
		ok ->
			loop(Socket, StartChar+1)
	end.


make_line(StartChar) ->
	make_line(StartChar, 0).

% Generate a new chargen line -- [13, 10] is CRLF.
make_line(_, ?LINE_LENGTH) ->
	[13, 10];
make_line(?END_CHAR, Pos) ->
	make_line(?START_CHAR, Pos);
make_line(StartChar, Pos) ->
	[StartChar | make_line(StartChar + 1, Pos + 1)].