= 元组
固定长度，可以是不同类型。
{{{
ghci> :t ()
() :: ()
ghci> :t (1,2,3)
(1,2,3) :: (Num t, Num t1, Num t2) => (t, t1, t2)
}}}

== ()
这是一个特殊类型， 表示空元组，这个类型只有一个值，就是`()`
== 2-tuple: pair
== 3-tuple: triple
== n-tuple: 你疯了么，n不能太大，可读性会变差。

== 函数
{{{
ghci> fst (1,2)
1
ghci> snd (1,2)
2

}}}


{{{#!div class=note
Haskell的元组不等于ImmutableLists
Python世界中的元祖是Immutable的，它可以像list一样使用下标操作。同样一些使用于list的函数也可以用于tuple.但是在haskell中完全不同，list就是list, tuple就是tuple.是截然不同的两种类型。


}}}
