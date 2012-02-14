-module(amas_es_sup).
-behaviour(supervisor).

%% API
-export([start_link/1,start_child/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(LSock) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSock]).

start_child() -> 
    io:format("start_child",[]),
    supervisor:start_child(?SERVER, []).

init([LSock]) ->
    Server = {amas_es_server,
              {amas_es_server, start_link, [LSock]},
              temporary,
              brutal_kill,
              worker,
              [amas_es_server]},
    Children = [Server],
    {ok,{{one_for_one, 0, 1}, Children}}. %% RETURN
