

{-
== 
-}

howMany :: (Show a) => [a] -> String
howMany [] = "None"
howMany (_:[]) = "One"


{-
== As-patterns
As-patterns可以按模式分解数据，同时又可以定义一个对原始数据的引用.
{{{
*Main> hiList [1,2,3,4]
"HEAD=1 TAIL=[2,3,4] all=[1,2,3,4]"
*Main> hiList []
"No Head , No Tail"
}}}
-}
hiList :: (Show a) => [a] -> String
hiList [] = "No Head , No Tail"
hiList all@(head:tail) = "HEAD=" ++ (show head) ++ " TAIL=" ++ (show tail) ++ " all=" ++ (show all)
