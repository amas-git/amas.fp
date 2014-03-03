{-
== 什么是类型
某类元素构成的集合就是类型，比方说, 布尔类型是由真和假组成的.

== 怎么在ghci中查看类型?
{{{
Prelude> :t 1
1 :: Num a => a
Prelude> :t 'x'
'x' :: Char
Prelude> :t (+)
(+) :: Num a => a -> a -> a
Prelude> :t True
True :: Bool
 :t 3.14
3.14 :: Fractional a => a
}}}

 Num, Bool, Fractional这些都是类型名， 注意啊，她们必须都是以大写字母开头的.

== 类型变量(Type Variables)
{{{
Prelude> :t (+)
(+) :: Num a => a -> a -> a
}}}


== Type Classes
Type Classes是一个定义相同行为的接口集合。 如果某个Type是某个Type Classes的示例(instance), 那么它就可以实现TypeClasses中的接口。 这些接口就是些特定模式的函数。

{{{
:t (==)
(==) :: Eq a => a -> a -> Bool
}}}
 * 这个 `Eq`就是TypeClasses名，或者ClassConstraint
 * `=>` 这个符号的意思`==`这个函数可以接受类型a, 这个a类型必须是`Eq`Type Classes的实例.

== Eq Type Classes
额，除了IO类型，可能其他所有类型都是Eq TypeClasses的实例。咱们来观察一下Eq的定义:
{{{
Prelude> :info Eq
class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
        -- Defined in `GHC.Classes'
instance (Eq a, Eq b) => Eq (Either a b)
  -- Defined in `Data.Either'
instance Eq a => Eq [a] -- Defined in `GHC.Classes'
instance Eq Ordering -- Defined in `GHC.Classes'
instance Eq Int -- Defined in `GHC.Classes'
instance Eq Float -- Defined in `GHC.Classes'
instance Eq Double -- Defined in `GHC.Classes'
instance Eq Char -- Defined in `GHC.Classes'
instance Eq Bool -- Defined in `GHC.Classes'
...
instance Eq Integer -- Defined in `integer-gmp:GHC.Integer.Type'
}}}
 * Eq中包含两个接口
  * `==` : 相等
  * `/=` : 不等

== Ord Type Classes
{{{
class Eq a => Ord a where
  compare :: a -> a -> Ordering
  (<) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  (>) :: a -> a -> Bool
  (<=) :: a -> a -> Bool
  max :: a -> a -> a
  min :: a -> a -> a
        -- Defined in `GHC.Classes'
instance (Ord a, Ord b) => Ord (Either a b)
  -- Defined in `Data.Either'
instance Ord a => Ord [a] -- Defined in `GHC.Classes'
instance Ord Ordering -- Defined in `GHC.Classes'
...
}}}

== Show Type Classes
{{{
Prelude> :info Show
class Show a where
  showsPrec :: Int -> a -> ShowS
  show :: a -> String
  showList :: [a] -> ShowS
        -- Defined in `GHC.Show'
instance (Show a, Show b) => Show (Either a b)
  -- Defined in `Data.Either'
}}}

== Read Type Classes
{{{
Prelude> :info Read
class Read a where
  readsPrec :: Int -> ReadS a
  readList :: ReadS [a]
  GHC.Read.readPrec :: Text.ParserCombinators.ReadPrec.ReadPrec a
  GHC.Read.readListPrec ::
    Text.ParserCombinators.ReadPrec.ReadPrec [a]
        -- Defined in `GHC.Read'
instance (Read a, Read b) => Read (Either a b)
...
}}}

== Num
{{{
class Num a where
  (+) :: a -> a -> a
  (*) :: a -> a -> a
  (-) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a
  fromInteger :: Integer -> a
        -- Defined in `GHC.Num'
instance Num Integer -- Defined in `GHC.Num'
instance Num Int -- Defined in `GHC.Num'
instance Num Float -- Defined in `GHC.Float'
instance Num Double -- Defined in `GHC.Float'
}}}
-}

{-
== typeclass
RWH:
{{{
data Color = Red | Green | Blue

colorEq :: Color -> Color -> Bool
colorEq Red   Red   = True
colorEq Green Green = True
colorEq Blue  Blue  = True
colorEq _     _     = False

-- file: ch06/naiveeq.hs
stringEq :: [Char] -> [Char] -> Bool
-- Match if both are empty
stringEq [] [] = True
-- If both start with the same char, check the rest
stringEq (x:xs) (y:ys) = x == y && stringEq xs ys
-- Everything else doesn't match
stringEq _ _ = False
}}}

== 什么是TypeClasses
{{{
class BasicEq a where
    isEqual :: a -> a -> Bool
}}}
-}

class BasicEq a where
    isEqual :: a -> a -> Bool

instance BasicEq Bool where
    isEqual True  True  = True
    isEqual False False = True
    isEqual _     _     = False

class BasicEq2 a where
    isEqual2    :: a -> a -> Bool
    isNotEqual2 :: a -> a -> Bool
--  :type isEqual
