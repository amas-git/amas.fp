-module(amas_sc_app).

-export([
         start/2,
         stop/1
        ]).

%% 启动, '_'前缀表示该参数我们并不使用
start(_Type, _StartArgs) ->
    %% 建立数据库(默认使用ETS表)
    amas_sc_store:init(),
    case amas_sc_sup:start_link() of
        {ok, Pid} ->
            {ok, Pid};
        Error ->
            Error
    end.

%% 关闭
stop(_State) ->
    ok.
