-module(amas_sc_element).

-behaviour(gen_server).

%% API
-export([
         start_link/2,
         create/1,
         fetch/1,
         replace/2,
         delete/1
        ]).

%% Gen Server Callbacks
-export([init/1, 
         handle_call/3, 
         handle_cast/2, 
         terminate/2, 
         code_change/3
        ]).



-define(SERVER, ?MODULE).
-define(DEFAULT_LEASE_TIME, 60 * 60 * 24). % 1 day default (最大缓存时间,过期后移除缓存).

-record(state, {value, lease_time, start_time}).


create(Value, LeaseTime) ->
    amas_sc_sup:start_child(Value, LeaseTime).

create(Value) ->
    create(Value, ?DEFAULT_LEASE_TIME).

start_link(Value, LeaseTime) ->
    gen_server:start_link(?MODULE, [Value, LeaseTime], []).

init([Value, LeaseTime]) ->
    StartTime = calendar:datetime_to_gregorian_seconds(calendar:local_time()),
    {ok,
     #state{value = Value, lease_time = LeaseTime, start_time = StartTime},
     time_left(StartTime, LeaseTime)}.

%% 永久缓存
time_left(_StartTime, infinity) ->
    infinity;

%% 临时缓存
time_left(StartTime, LeaseTime) ->
    CurrentTime = calendar:datetime_to_gregorian_seconds(calendar:local_time()),
    TimeElapsed = CurrentTime - StartTime,
    case LeaseTime - TimeElapsed of
        Time when Time =< 0 -> 0;
        Time                -> Time * 1000
    end.

%% 更新元素值
replace(Pid, Value) ->
    gen_server:cast(Pid, {replace, Value}).


handle_cast({replace, Value}, State) ->
    #state{lease_time = LeaseTime,
           start_time = StartTime} = State,
    TimeLeft = time_left(StartTime, LeaseTime),
    {noreply, State#state{value = Value}, TimeLeft};

handle_cast(delete, State) ->
    {stop, normal, State}.

%% 获得元素值
fetch(Pid) ->
    gen_server:call(Pid, fetch).

handle_call(fetch, _From, State) ->
    #state{value = Value,
           lease_time = LeaseTime,
           start_time = StartTime} = State,
    TimeLeft = time_left(StartTime, LeaseTime),
    {reply, {ok, Value}, State, TimeLeft}.

%% 删除元素值
delete(Pid) ->
    gen_server:cast(Pid, delete).


%% 'normal' :　SASL will automatically log the shutdown of any behaviour that shuts down with anything but a normal reason.


terminate(_Reason, _State) ->
    %% 结束前,从DB中清除和自己相关的数据
    amas_sc_store:delete(self()),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
