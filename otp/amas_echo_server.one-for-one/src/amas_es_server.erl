%%%-------------------------------------------------------------------
%%% @author amas<zhoujb.cn@gmail.com>
%%% @copyright 2011 amas
%%% @doc  学习Erlang/Otp之用
%%% @end
%%%-------------------------------------------------------------------
-module(amas_es_server).
-behaviour(gen_server).

%% API
-export([
         start_link/1,
         start_link/0,
         get_count/0,
         stop/0
        ]).

%% Gen Server Callbacks
-export([init/1, 
         handle_call/3, 
         handle_cast/2, 
         handle_info/2,
         terminate/2, 
         code_change/3
        ]).

-define(SERVER, ?MODULE).
-define(DEFAULT_PORT, 9999).

%% 你可以使用如下方法产生一条记录:
%% State = #state{port = 80},
%% 你可以使用如下方法读出记录中的数据:
%% State#state.port,
-record(state, {port, lsock, request_count=0}).


%%---------------------------------------------------------------[ API.IMPL ]
%% 启动服务
start_link(Port) ->
    gen_server:start_link({local,?SERVER}, ?MODULE, [Port], []).


%% @spec start_link() -> {ok, Pid}
%% @equiv start_link(Port::integer())
start_link() ->
    start_link(?DEFAULT_PORT).


get_count() ->
    gen_server:call(?SERVER, get_count).

stop() ->
    gen_server:cast(?SERVER, stop).

%%---------------------------------------------------------------[ gen_server.callback ]
%% 1. init/1
init([Port]) ->
    {ok, LSock} = gen_tcp:listen(Port,[{active,true}]),
                                 {ok, #state{port=Port, lsock=LSock}, 0}.
%% 2. handle_call/3
handle_call(get_count, _From, State) ->
    {reply, {ok, State#state.request_count}, State}.

%% 3. handle_cast/2
handle_cast(stop, State) ->
    {stop, ok, State}.

%% 4. handle_info/2
handle_info({tcp, Socket, RawData}, State) ->
    RequestCount = State#state.request_count,
    try
        io:format("[RECV]:~p~n", [RawData]),
        gen_tcp:send(Socket, io_lib:fwrite("~p~n", [RawData]))
     catch
         _C:E ->
             gen_tcp:send(Socket, io_lib:fwrite("~p~n", [E]))
     end,
    {noreply, State#state{request_count = RequestCount + 1}};

%% 5. handle_info
handle_info(timeout, #state{lsock = LSock} = State) ->
    try
        {ok, _Sock} = gen_tcp:accept(LSock)
    catch 
        _C:E ->
            io:format("[ERROR]")
    end,
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
