-module (lab3).
-export ([start/0, server/0,monitor_server/1]).

%%
%% The server
%%

server() ->
    receive
        {_, lab3, finished} ->				% Time to shut down
            io:format("lab3 server (~w): finished~n", [node()]),
	    ok;
	
	{Echo_PID, lab3, reload} ->			% Reload server - fresh copy  
	    io:format ("lab3 server (~w): reloading~n", [node()]),
	    Echo_PID ! reloaded,		% Tell client
	    lab3:server ();			% Reload and don't up seq number
        {Echo_PID, lab3, {Function, List}} ->	% A function and a list to apply it to
	    Reply = do_process (Function, List),
            Echo_PID ! {lab3, Reply},	% Respond with processed list
            io:format("lab3 server (~w) v2: sent ~w to ~w~n", [node(),Reply, node (Echo_PID)]),
            server()				% Recurse
    end.

start () ->					% Start our server and register its name
    SPid = spawn(lab3, server, []),
    register(lab3, SPid),
    spawn (lab3, monitor_server, [SPid]).

monitor_server (Pid)->				%keep tabs on server, restart if it crashes
    process_flag (trap_exit, true),		%get notified it if crashes
    link (Pid),					%link to server
    receive
	{'EXIT', _, normal} ->			%normal termination, don't restart
	    io:format("Server terminated normally~n"),
	    ok;
	{'EXIT', From, Reason} ->		%crash - restart, reregister, report and recurse
	    SPid = spawn(lab3, server, []),
	    register(lab3, SPid),
	    io:format("Server restarted: ~p~n", [{'EXIT', From, Reason}]),
	    monitor_server (SPid)
    end.

    
do_process (Function, List)->
    case Function of
	remove_dups ->
	    {ok, lab2:remove_dups (List)};
	non_repeats ->
	    {ok, lab2:non_repeats (List)};
	repeats_only ->
	    {ok, lab2:repeats_only (List)};
	error ->
	    lab3:error (error);
	_ ->
	    {error, 'unknown function'}
    end.
