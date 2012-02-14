-module(amas_es_app).
-behaviour(application).

-export([
         start/2,
         stop/1
        ]).

-define(DEFAULT_PORT, 9999).

%% 启动
start(_Type, _StartArgs) ->

    %% 获取端口
    Port = case application:get_env(amas_echo_server, port) of
               {ok, P} -> P;
               undefined -> ?DEFAULT_PORT
           end,
    
    {ok, LSock} = gen_tcp:listen(Port, [{active, true}]),
    case amas_es_sup:start_link(LSock) of
        {ok, Pid} ->
            io:format("amas_es_app: start new child pid=[~p~n]",[Pid]),
            amas_es_sup:start_child(),
            {ok, Pid};
        Other ->
            {error, Other}
    end.

%% 关闭
stop(State) ->
    ok.
