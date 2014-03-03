= Conditional Evaluation
Haskell中也有if-then-else语句，本质上它们也是表达式。

{{{
passtive x = if x > 0 
    then True
    else False

ghci> passtive 1
True
ghci> passtive (-1)
False
}}}

我们把then/else关键字后面的表达式称为branches, 各个分支的类型必须相同，否则编译器会报错。
{{{
> ghci if 1 > 0 then 1 else "0"

<interactive>:11:15:
    No instance for (Num [Char]) arising from the literal `1'
    Possible fix: add an instance declaration for (Num [Char])
    In the expression: 1
    In the expression: if 1 > 0 then 1 else "0"
    In an equation for `it': it = if 1 > 0 then 1 else "0
}}}


== 操作符没什么特别之处，其实全部是函数。
如果函数名中可以使用操作符，那么我们就不需要额外处理操作符了，它们通过函数即可实现。

{{{
-- 注意这个括号
(+++) x = x + 2

ghci> :t (+++)
(+++) :: Num a => a -> a
}}}
