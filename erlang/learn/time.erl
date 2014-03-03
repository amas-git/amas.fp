-module(time).
-export([diff/2]).

%%
%% Calculate the difference between two times.
%% Return as single microsecond value
%%

diff ({Mega, Secs1, Micro1}, {Mega, Secs1, Micro2})-> %only microseconds differ
    abs (Micro1 - Micro2);
diff ({Mega, Secs1, Micro1}, {Mega, Secs2, Micro2})-> %seconds and micro differ
    abs (Secs1 - Secs2) * 1000000 + abs (Micro1-Micro2);
diff ({Mega1, Secs1, Micro1}, {Mega2, Secs2, Micro2})-> % long time apart
    abs (Mega1 - Mega2) * 1000000000000 + abs (Secs1 - Secs2) * 1000000 + abs (Micro1-Micro2).
