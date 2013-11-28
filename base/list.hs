head' [] = error "Empty list"
head' (x:xs) = x

last' [] = error "Empty list"
last' (x:[]) = x
last' (x:xs) =  last' xs

init' :: [a] -> [a]
init' [] = []
init' (x:[]) = []
init' (x:xs) = x:(init' xs)

tail' :: [a] -> [a]
tail' [] = []
tail' (x:xs) = xs

-- oops
listAdd :: [a] -> [a] -> [a]
listAdd xs [] = xs
listAdd [] xs = xs


null' :: [a] -> Bool
null' [] = True
null' _  = False

-- 玩具，效率很低
length' :: [a] -> Int
length' [] = 0
length' (x:xs) = 1 + length' xs


lengthAcc [] acc = acc
lengthAcc (x:xs) acc = lengthAcc xs (acc+1)

length'' xs = lengthAcc xs 0

{-- LIST TRANSFORMATION --}
map' :: (a -> b) -> [a] -> [b]
map' f [] = []
map' f (x:xs) = (f x) : (map' f xs)

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = (reverse' xs)++[x]

intersperse' :: a -> [a] -> [a]
intersperse' _ [] = []
intersperse' a (x:[]) = [x]
intersperse' a (x:xs) = [x,a] ++ (intersperse' a xs)


concat' :: [[a]] -> [a]
concat' [] = []
concat' (xs:xss) = xs ++ (concat' xss)


intercalate' :: [a] -> [[a]] -> [a]
intercalate' xs xss = (concat (intersperse' xs xss))

-- The transpose function transposes the rows and columns of its argument. For example,
-- transpose [[1,2,3],[4,5,6]] == [[1,4],[2,5],[3,6]]
-- transpose' ::  [[a]] -> [[a]]
-- transpose' 






{-- Reducing lists (folds) --}
-- foldr:: (a -> b -> a) -> a -> [b] -> a
{-
foldr
(1(2(3(4(5 - 0)))))
-}
foldr f a [] = a

