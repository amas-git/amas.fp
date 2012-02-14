-module (dbserver).
-export ([start/0, server/1]).

%%
%% The server - Parameter is the database
%%

server(Database) ->
    receive
        {_, dbase, finished} ->			% Time to shut down
            io:format("dbase server: finished~n", []),
	    ok;
	
	{Client_PID, dbase, reload} ->		% Reload server - fresh copy  
	    io:format ("dbase server: reloading~n", []),
	    Client_PID ! reloaded,		% Tell client
	    dbserver:server (Database);			% Reload

        {Client_PID, dbase, {insert, Data}} ->		% Insert new key/data
	    NewDatabase = db:insert (Data, Database),
	    Client_PID ! {dbase, {inserted, Data}},	% Respond
	    io:format("dbase server version 6 inserted  ~w from ~w~n", [Data, node (Client_PID)]),
	    server(NewDatabase);				% Recurse with updated DB

        {Client_PID, dbase, {delete, Key}} ->		% Insert new key/data
	    NewDatabase = db:delete (Key, Database),
	    Client_PID ! {dbase, {deleted, Key}},	% Respond
	    io:format("dbase server version 6 deleted  ~w from ~w~n", [Key, node (Client_PID)]),
	    server(NewDatabase);			% Recurse with updated DB

        {Client_PID, dbase, {lookup, Key}} ->		% Insert new key/data
	    Value = db:lookup (Key, Database),
	    Client_PID ! {dbase, {lookup, Value}},	% Respond
	    io:format("dbase server version 6 looked up  ~w from ~w~n", [Key, node (Client_PID)]),
	    server(Database);				% Recurse with same DB

	{Client_PID, dbase, list} ->		%list db contents
	    io:format("dbase server version 6 list dbase for ~w~n", [node (Client_PID)]),
	    list (Client_PID, Database),
	    server (Database);

	{Client_PID, dbase, Any} ->		%don't recognise this
	    Client_PID ! {dbase, {error, Any}},	% Respond
	    io:format("dbase server version 6 unknown request  ~w from ~w~n", [Any, node (Client_PID)]),
	    server(Database)				% Recurse with same DB
    end.

start() ->					% Start our server and register its name
    register(dbase, spawn(dbserver, server, [db:new ()])).

list (Client_PID, []) ->
    Client_PID ! {dbase, {list, ok}};

list (Client_PID, Database) ->
    Client_PID ! {dbase, {list, db:first (Database)}},
    list (Client_PID, db:rest (Database)).

