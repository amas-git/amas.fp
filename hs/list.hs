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


-- nth 0 xs = x
nth n xs = _nth xs n 1 
  where _nth [] _ _    = error "not found"
        _nth (x:xs) n m
          | (n == m)  = x
          | otherwise = _nth xs n (m+1)
        
butlast [] = error "empty list"
butlast [_] = error "less than 2 element" 
butlast (x:(_:[])) = x
butlast (x:xs) = butlast xs

butlast' = last.init

palindrome [] = True
palindrome [_] = True
palindrome [x,y] = x == y
palindrome (x:xs)
  | (x == (last xs)) = palindrome (init xs)
  | otherwise = False


uniq :: Ord a => [a] -> [a]
uniq xs = _uniq xs []
  where _uniq [] ys   = reverse ys
        _uniq (x:xs) ys
          | x `elem` ys = _uniq xs ys
          | otherwise = _uniq xs (x:ys)


-- pack :: Eq a => [a] -> [[a]]
--takeEq [x] = [x]
pack [] = []
pack xs = [ys] ++ (pack (drop (length ys) xs))
  where ys = takeEq xs
        takeEq [x] = [x]
        takeEq (x:xs)
          | x == (head xs) = x:(takeEq xs)
          | otherwise = [x]


encode xss = map (\xs->(length xs, xs)) (pack xss)
-- encode xss = [(length xs,xs) | xs<-(pack xss)] 


{- 11. run-length -}
lengthx xs = l xs 0  
  where
    l [] n = n
    l (x:xs) n = l xs $! (n+1)

encode' xss = map (\xs->(length xs, xs)) (pack xss)
-- encode' xss = [(length xs,xs) | xs<-(pack xss)] 


duplicate [] = []
duplicate (x:xs) = x:(x:duplicate xs)

-- duplicate = foldr (\x xs -> x:x:xs) []

-- 1. 在haskell中已经有replicate函数, 但跟这个意思不太一样
-- 2. 注意标准函数的实现方式，一般都将list放置在最后一个参数
replicate' _ []  = []
replicate' n (x:xs) = (take n (repeat x)) ++ (replicate' n xs) 


replicate'' _ [] = []
replicate'' n xs = foldr (\x xs -> (take n (repeat x)) ++ xs) [] xs


dropEvery xs 0 = xs
dropEvery [] _ = []
dropEvery xs n = (take (n-1) xs) ++ (dropEvery (drop n xs) n)


-- Data.List中有个 splitAt
splite xs n = [ (take n xs) , (drop n xs) ]


split' n xs = acc 0 [] xs
  where
    acc _ rs [] = [reverse rs,[]]
    acc i rs (x:xs)
      | i < n = acc (i+1) (x:rs) xs
      | otherwise = [reverse rs, x:xs]

slice l r xs = acc l r l [] (drop l xs)
  where
    acc _ _ _ rx [] = reverse rx
    acc l r i rx (x:xs)
      | i < r = acc l r (i+1) (x:rx) xs
      | otherwise = reverse rx


-- a mod b + (-a) mod b = b
-- [1,2,3,4,5,6]
-- [3,4,5,6,1,2] 左移2 OR 右移(6-2)
rotate 0 xs = xs
rotate n xs = (drop n' xs) ++ (take n' xs)
  where n' = n `mod` (length xs)


-- 根据split修改而成
removeAt' n xs = acc 0 [] xs
  where
    acc _ xs1 [] = reverse xs1
    acc i xs1 (x:xs)
      | i < n = acc (i+1) (x:xs1) xs
      | otherwise = reverse xs1 ++  xs

removeAt n xs = acc [] 1 xs
  where
    acc rx _ [] = reverse rx
    acc rx i (x:xs)
        | i == n = acc rx (i+1) xs 
        | otherwise = acc (x:rx) (i+1) xs 

-- 语法糖
range l r = [l..r]

range' l r
  | l > r  = []
  | l == r = [l]
  | otherwise = l:(range' (succ l) r)

-- splite' == splitAt (Data.List模块中)
insertAt x n xs = let xss = split (n-1) xs
                      xs1 = head xss
                      xs2 = last xss
                  in xs1 ++ (x:xs2)
  where split n xs = [ (take n xs) , (drop n xs) ]
    
    

data Color = Red Int | Green Int | Blue Int
instance Show Color
  where
    show (Red   x) = "R:" ++ show x
    show (Green x) = "G:" ++ show x
    show (Blue  x) = "B:" ++ show x

data Book = Book {
  name  :: [Char],
  price :: Double,
  isbn  :: [Char]
  }

-- deriving (Eq)

instance Show Book where
  show (Book name price isbn) =
    "Book\n"
    ++ " name  = " ++ show name  ++ "\n"
    ++ " price = " ++ show price ++ "\n"
    ++ " isbn  = " ++ show isbn  ++ "\n"

instance Eq Book where
  (==) (Book name1 _ _) (Book name2 _ _) = name1 == name2


-- combinations :: Integer -> [a] -> [[a]]
--combinations _ [] = [[]]
--combinations 0 _  = [[]]

--combinations n (x:xs) = (map (x:) (combinations (n-1) xs)) ++ (combinations n xs)
--combinations n xs = [ y:ys | y:xs <- tail xs, ys <- combinations (n-1) xs]


-- permutations

merge :: Ord a => [a] -> [a] -> [a]
merge [] xs = xs
merge xs [] = xs
merge (x:xs) (y:ys)
  | x < y = x:(merge xs (y:ys))
  | otherwise = y:(merge (x:xs) ys)

reversew [] = []



-- countWords :: [Char] -> Integer
-- join :: [Char] [[Char]] -> [Char]
join s (xs:[])  = xs
join s (xs:xss) = xs++s++(join s xss)


data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
         deriving (Show, Eq, Ord, Bounded, Enum)
         -- deriving (Eq, Ord, Show, Read, Bounded, Enum)


-- type StringMap = [(String, String)]
type Key   = String
type Value = String
type StringMap = [(Key, Value)]


type Map k v = [(k, v)]

contains :: Eq k => (Map k v) -> k -> Bool
contains [] _ = False
contains (x:xs) key
  | fst x == key = True
  | otherwise = contains xs key
  
-- data List a = Empty | Cons a (List a) deriving (Show, Read, Eq, Ord)
-- data List a = Empty | Cons { listHead :: a, listTail :: List a}
             -- deriving (Show, Read, Eq, Ord)


data Pair a b = Pair a b deriving Show

infixr 5 :::
data List a = Empty | a ::: (List a)
            deriving (Show, Read, Eq, Ord)

infix 5 +++
(+++) :: List a -> List a -> List a
Empty +++ xs = xs
xs +++ Empty = xs
(x ::: xs) +++ ys = x ::: (xs +++ ys)


listLength :: List a -> Int
listLength Empty = 0
listLength (x ::: xs) = 1 + (listLength xs)


zip' :: [a] -> [b] -> [(a,b)]
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = [(x,y)] ++ (zip' xs ys)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' f _ [] = []
zipWith' f [] _ = []
zipWith' f (x:xs) (y:ys) = [f x y] ++ (zipWith' f xs ys)


isLower :: Char -> Bool
isLower c =  n >= (fromEnum 'a') && n <= (fromEnum 'z')
  where n = (fromEnum c)

isLower' :: Char -> Bool
isLower' c = elem c ['a'..'z']

caesaEncoding :: Int -> String -> String
caesaEncoding n xs = [ shift n x | x <-xs ]
  where
    isLower c = elem c ['a'..'z']
    isUpper c = elem c ['A'..'Z']
    cch x n xs = let n' = (fromEnum x - fromEnum (head xs) + n) `mod` (length xs) in head $ rotate n' xs
    shift n c
      | isLower c = cch c n ['a'..'z']
      | isUpper c = cch c n ['A'..'Z']
      | otherwise = c



    -- | isUpper c = let s = n `mod` (length ['a'..'z']) in (toEnum (fromEnum 'a') + s) :: Char

caesaDecoding :: Int -> String -> String
caesaDecoding n = caesaEncoding (-n)

freqs xs = map (\x -> fromIntegral x / (fromIntegral $ length xs)) [ (count x xs) | x<-['a'..'z']]
  where count t xs = length [ x | x<-xs, x == t]
        
--factors :: Int -> [Int]
--factors 0 = []
factors n = [ x | x <-  [1..n], n `mod` x == 0 ]
-- factors n = [ x | x <- [1..(n/2)] , n `mod` x == 0 ]

perfects :: Int -> [Int]
perfects n = [ x | x <-[1..n], isPerfect x ]
  where isPerfect n = (sum $ factors n) == n
        
scalarproduct xs [] = 0        
scalarproduct [] xs = 0
scalarproduct xs ys = sum [ x*y | (x,y) <- (zip xs ys) ]


-- mutal recursion
evens [] = []
evens (x : xs) = x: odds xs

odds [] = []
odds (_: xs) = evens xs

and' :: [Bool] -> Bool
and' xs = foldl (\a b -> a && b) True xs

concat'' :: [[a]] -> [a]
concat'' xxs = foldl (\a b -> a ++ b) [] xxs

type Bit = Int

bin2int bits = sum [ w*b | (w,b) <- zip weights bits]
  where weights = iterate (*2) 1
        
type Function = Int -> Int

double :: Function
double n = 2 * n 

-- Functional Parser
-- What's Parser
--   * type Parser -> String -> Tree
-- 更常见的, parser不是总是消耗掉素有的输入String, 因此除了Parser生成的树, 余下的字符串也需要返回
--   * type Parser -> String -> (Tree, String)
-- 因为Parser并不一定返回Tree, 异常的情况下Parser可能不会产生任何结果, 为了方便我们可以将Parser改写成
--   * type Parser -> String -> [(Tree, String)]  -- 返回[]即代表Parser出了差子
-- 最后生成的这个树的类型可有变化
--   * type Parser -> [(a,String)]

-- 1. return
--return v input = [(v,input)] 
-- 但是我们更喜欢currying版本的return
-- type Parser -> [(a,String)]
type Parser a = String -> [(a,String)]

ret v = \input -> [(v,input)]

--failure input = []
failure = \input -> []

item = \input -> 
  case input of
    [] -> []
    (x:xs) -> [(x,xs)]

parse :: Parser a -> String -> [(a, String)]
parse p input = p input

(>>>=) :: Parser a -> (a -> Parser b) -> Parser b
p >>>= f = \input -> 
  case parse p input of
    []        -> []
    [(v,out)] -> parse f out
            

p = do 
  x = item
  return (x,y)