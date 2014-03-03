-module(amas_sc_sup).
-behaviour(supervisor).

%% API
-export([
         start_link/0,
         start_child/2
        ]).

%% Supervisor callbacks
-export([init/1]).
-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Key, Value) ->
    supervisor:start_child(?SERVER, [Key, Value]).

init([]) ->
    RestartStrategy = simple_one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    Restart = temporary,    %% 如果child死掉,不必重启它
    Shutdown = brutal_kill, %% 强杀, Supervisor不必等到child进程终止
    Type = worker,
    AChild = {amas_sc_element, {amas_sc_element, start_link, []},
              Restart, Shutdown, Type, [amas_sc_element]},
    {ok, {SupFlags, [AChild]}}.

