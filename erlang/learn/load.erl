-module(load).
-export ([load_remote/2,start_remote/3,stop_remote/1]).

load_remote (Node, Module)->
    {Module, Bin, File} = code:get_object_code(Module),
    rpc:call (Node,code,load_binary,[Module,File,Bin]).

start_remote (Node, Module, Func)->
    start_remote (Node, Module, Func, []).

start_remote (Node, Module, Func, Args)->
    rpc:call (Node,Module,Func,Args). 

stop_remote (Node)-> 
    rpc:call(Node,erlang,halt,[]).
    
