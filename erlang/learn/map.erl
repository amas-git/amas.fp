-module (map).
-export ([map/2]).

map (Fun, [H|T]) ->
    [Fun (H) | map (Fun, T)];
map (_, []) ->
    [].

