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
         stop/0
        ]).

%% Gen Server Callbacks
-export([init/1,
         handle_cast/2, 
         handle_info/2,
         handle_call/3,
         terminate/2, 
         code_change/3
        ]).

-define(SERVER, ?MODULE).

%% 你可以使用如下方法产生一条记录:
%% State = #state{port = 80},
%% 你可以使用如下方法读出记录中的数据:
%% State#state.port,
-record(state, {port, lsock, request_count=0}).


%%---------------------------------------------------------------[ API.IMPL ]
%% 启动服务
start_link(LSock) -> 
    io:format("gen_server[~p]: start link ...~n",[self()]),
    gen_server:start_link(?MODULE, [LSock], []).

%get_count() ->
%    gen_server:call(?SERVER, get_count).

stop() ->
    gen_server:cast(?SERVER, stop).

%%---------------------------------------------------------------[ gen_server.callback ]
%% 1. init/1
init([LSock]) ->
    io:format("gen_server[~p]: init/1 ...~n",[self()]),
    {ok, #state{lsock = LSock}, 0}.

%% 2. handle_call/3
handle_call(get_count, _From, State) ->
    {reply, {ok, State#state.request_count}, State}.

%% 3. handle_cast/2
handle_cast(stop, State) ->
    {stop, ok, State}.

%% 4. handle_info/2
handle_info({tcp, Socket, RawData}, State) ->
    io:format("gen_server[~p]: handle_info : tcp ~n",[self()]),
    NewState = handle_data(Socket, RawData, State),
    {noreply, NewState};

%% 5. handle_info
handle_info(timeout, #state{lsock = LSock} = State) ->
    io:format("gen_server[~p]: handle_info : timeout.accept ~n",[self()]),
    {ok, _Sock} = gen_tcp:accept(LSock),
    io:format("gen_server[~p]: handle_info : timeout.accpeded incoming connection...",[self()]),
    amas_es_sup:start_child(),
    {noreply, State};

handle_info({tcp_closed, _Socket}, State) ->
    io:format("gen_server[~p]: handle_info : tcp closed ~n",[self()]),
    {stop, normal, State}.

terminate(_Reason, _State) ->
    io:format("terminate",[]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------------[ internal.functions ]
handle_data(Socket,RawData,State) ->
    try
        io:format("gen_server[~p]: handle_data : [~p] ~n",[self(), RawData]),
        gen_tcp:send(Socket, io_lib:fwrite("~p~n", [RawData]))
    catch
        _C:E ->
            gen_tcp:send(Socket, io_lib:fwrite("~p~n", [E]))
    end,
    State.
