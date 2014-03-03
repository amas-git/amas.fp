-module(amas_es_sup).
-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    Server = {amas_es_server,
              {amas_es_server, start_link, []},
              permanent,
              2000,
              worker,
              [amas_es_server]},
    {ok,{{one_for_one, 10, 1000}, [Server]}}. %% RETURN

