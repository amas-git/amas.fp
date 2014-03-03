-module(amas_es_app).
-behaviour(application).

-export([
         start/2,
         stop/1
        ]).

%% 启动
start(Type, StartArgs) ->
    case amas_es_sup:start_link() of
        {ok, Pid} ->
            {ok, Pid};
        Error ->
            Error
    end.

%% 关闭
stop(State) ->
    ok.
