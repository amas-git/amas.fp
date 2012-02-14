-module(amas_es_sup).
-behaviour(supervisor).

%% API
-export([start_link/1,start_child/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(LSock) ->
    io:format("supervisor[~p]: start link ...~n",[self()]),
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSock]).

start_child() -> 
    io:format("supervisor[~p]: start child ...~n",[self()]),
    supervisor:start_child(?SERVER, []).

init([LSock]) ->
    io:format("supervisor[~p]: init/1 ...~n",[self()]),
    Server = {amas_es_server,
              {amas_es_server, start_link, [LSock]},
              temporary,
              brutal_kill,
              worker,
              [amas_es_server]},
    Children = [Server],
    {ok,{{simple_one_for_one, 0, 1}, Children}}. %% RETURN
