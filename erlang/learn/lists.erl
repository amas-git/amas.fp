-module (lists).
-export ([start/0, server/1,monitor_server/1]).
%%
%% The server - keeps a message sequence number
%%

server(N) ->
    receive
        {_, lists, finished} ->				% Time to shut down
            io:format("lists server: finished~n", []),
	    ok;
	
	{Echo_PID, lists, reload} ->			% Reload server - fresh copy  
	    io:format ("lists server: reloading~n", []),
	    Echo_PID ! reloaded,		% Tell client
	    lists:server (N);			% Reload and don't up seq number
	{Echo_PID, lists, error} ->		% case an error (deliberately)
	    error * 2;
        {Echo_PID, lists, Message} ->		% A plain old message to echo
            Echo_PID ! {N, lists, Message},	% Respond with sequence number
            io:format("lists server rev. 1 received  ~w from ~w~n", [Message, node (Echo_PID)]),
            server(N+1)				% Recurse and up seq no.
    end.

start () ->					% Start our server and register its name
    SPid = spawn(lists, server, [1]),
    register(lists, SPid),
    spawn (lists, monitor_server, [SPid]).

monitor_server (Pid)->				%keep tabs on server, restart if it crashes
    process_flag (trap_exit, true),		%get notified it if crashes
    link (Pid),					%link to server
    receive
	{'EXIT', _, normal} ->			%normal termination, don't restart
	    io:format("Server terminated normally~n"),
	    ok;
	{'EXIT', From, Reason} ->		%crash - restart, reregister, report and recurse
	    SPid = spawn(lists, server, [1]),
	    register(lists, SPid),
	    io:format("Server restarted: ~p~n", [{'EXIT', From, Reason}]),
	    monitor_server (SPid)
    end.

    
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

