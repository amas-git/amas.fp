[[TOC]]
= 求值
== Strict Evaluation
严格求值是这样一种行为，即在调用函数之前，这个函数所接受的表达式必须实现被求值完毕，这样函数实际上并不关心表达式本身，因为它只是得到一个计算结果。

== No-strict Evaluation , Lazy Evaluation, Call-by-need
非严格求值恰好相反。它的表达式不过是一种承诺，只有当需要兑现承诺的时候，表达式才会被求值。

== Thunk : 丧克
非严格求值不是免费的早餐，Haskell中使用Thunk保存未被求值的表达式，因此未被求值的表达式会占据一定的内存，因此如果Thunk够大，就会用尽堆内存，从而导致程序OOM。

{{{
-- 无论||后面的表达式是什么都不会被求值，
ghci>  True || (1/0 == 1)
True
ghci> (1/0)
Infinity
}}}
