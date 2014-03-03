%% 1. 存储key到pid的对应关系
%% 2. 存储容器为[wiki:Erlang/Ets]
-module(amas_sc_store).


%% CRUD: CREATE / READ / UPDATE / DELETE
-export([
         init/0,
         insert/2,
         delete/1,
         lookup/1
        ]).


-define(TABLE_ID, ?MODULE).

init() ->
    ets:new(?TABLE_ID, 
            [
             public,            %% 允许该表可以被任何Erlang进程访问
             named_table        %% 有名表
            ]
           ),
    ok.

insert(Key, Pid) ->
    ets:insert(?TABLE_ID, {Key, Pid}).


lookup(Key) ->
    case ets:lookup(?TABLE_ID, Key) of
        [{Key, Pid}] -> {ok, Pid};    %% ETS是允许单键多值的, 如果需要单键单值需在建表时指定
        [] -> {error, not_found}
    end.


delete(Pid) ->
    ets:match_delete(?TABLE_ID, {'_', Pid}).
