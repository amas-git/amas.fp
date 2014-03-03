-module(lab2).
-export([remove_dups/1,non_repeats/1,repeats_only/1]).

%
% Reduce all repeated runs in a list to singletons
%

remove_dups ([]) ->
    [];
remove_dups ([H,H|T]) ->
    [H|remove_dups(strip (H,T))];
remove_dups ([H|T]) ->
    [H|remove_dups(T)].

%
% Completely remove all repeated runs from a list
%

non_repeats ([]) ->
    [];
non_repeats ([H,H|T]) ->
    non_repeats (strip (H, T));
non_repeats ([H|T]) ->
    [H|non_repeats (T)].

repeats_only ([])->
    [];
repeats_only ([H,H|T]) ->
    [H|repeats_only (strip (H, T))];
repeats_only ([_|T]) ->
    repeats_only (T).

strip (_, [])->
    [];
strip (E, [E|T]) ->
    strip (E, T);
strip (_, L) ->
    L.

