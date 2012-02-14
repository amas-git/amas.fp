-module(amas_simple_cache).

-export([
         insert/2,
         delete/1,
         lookup/1
        ]).

insert(Key, Value) ->
    case amas_sc_store:lookup(Key) of
        {ok, Pid} ->
            amas_sc_element:replace(Pid, Value);
        {error, _Reason} ->
            {ok, Pid} = amas_sc_element:create(Value),
            amas_sc_store:insert(Key, Pid)
    end.


lookup(Key) ->
    try
        {ok, Pid}   = amas_sc_store:lookup(Key),    %% 根据Key得到对应的PID
        {ok, Value} = amas_sc_element:fetch(Pid),   %% 利用PID取得对应值
        {ok, Value}
    catch
        _Class:_Exception ->
            {error, not_found}
    end.


delete(Key) ->
    case amas_sc_store:lookup(Key) of
        {ok, Pid} ->
            amas_sc_element:delete(Pid);
        {error, _Reason} ->
            ok
    end.

