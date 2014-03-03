-module(amas_es_app).
-behaviour(application).

-export([
         start/2,
         stop/1
        ]).

-define(DEFAULT_PORT, 9999).

%% 启动
start(_Type, _StartArgs) ->
    io:format("application[~p]: start ... ~n",[self()]),
    %% 获取端口
    Port = case application:get_env(amas_echo_server, port) of
               {ok, P} -> P;
               undefined -> ?DEFAULT_PORT
           end,
    
    {ok, LSock} = gen_tcp:listen(Port, [{active, true}]),
    io:format("application[~p]: LSoket created as (~p) ... ~n", [self(), LSock]),

    case amas_es_sup:start_link(LSock) of
        {ok, Pid} ->
            amas_es_sup:start_child(),
            {ok, Pid};
        Other ->
            {error, Other}
    end.

%% 关闭
stop(State) ->
    ok.
