= 变量
haskell中的变量不过是表达式的名字而已。 一旦某个变量绑定到止跌嗯的表达式，它的值就是不能改变的了。 无论这个名字在哪里出现，都代表同样的表达式，其作用是纯净的，其结果是防止四海儿皆准的。


在ImpreativeProgrammingLanguages中，变量是一种内存的标识。 其状态可以随时改变。

比方说:
{{{
int x = 1
printf("%d",x);
x = 2;
printf("%d",x);
x = 3;
printf("%d",x);
}}}
结果显而易见。

在haskell中，一旦将某个符号绑定到指定表达式之上，则这个符号或者变量就无法再改变。

bind.hs:
{{{
x = 1
x = 2
}}}

{{{
ghci> :l bind.hs
bind.hs:2:1:
    Multiple declarations of `x'
    Declared at: bind.hs:1:1
                 bind.hs:2:1
Failed, modules loaded: none.
}}}
