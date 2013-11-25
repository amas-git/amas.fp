{- Think Recurcive -}
max' :: (Ord a) => [a] -> a
max' []  = error "empty list"
max' [x] = x
max' (x:xs) = max x (max' xs)


nxs :: Int -> a -> [a]
nxs n x
 | n <= 0 = []
 | otherwise = x : nxs (n-1) x



take' :: Int -> [a] -> [a]
take' n _
      | n <= 0 = []
take' n [] = []
take' n (x:xs) = x : (take' (n-1) xs)


zip' :: [a] -> [a] -> [(a,a)]
zip' [] [] = []
zip' _  [] = []
zip' [] _  = []
zip' (x:xs) (y:ys) = (x,y):(zip xs ys)


elem' :: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' a (x:xs)
  | (a == x) = True
  | otherwise = (elem' a xs)

elem'' :: (Eq a) => a -> [a] -> Bool
elem'' a [] = False
elem'' a (x:xs)
  | (a == x) = True
  | otherwise = a `elem''` xs

qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x:xs) = (qsort [l| l<-xs, l<x]) ++ [x] ++ (qsort [g|g<-xs, g>=x])


-- bsort :: (Ord a) => [a] -> [a]
-- bsort [] = []
-- bsort (x:[]) = [x]
-- bsort (x:y:xs)
--   | x < y      = x:(bsort (y:xs))
--   | otherwise  = y:(bsort (x:xs))





splite [] = []
splite (x:[]) = [[x]]
splite (x:y:[])
  | x < y = [[x,y]]
  | otherwise = [[y,x]]
splite (x:y:xs) = [[x,y]] ++ (splite xs)

-- merge [] = []
-- merge (xs:[]) = xs
-- merge (xs:ys:[]) = 

{-
 3 2 1
 2 3 1 swap
 2 1 3 swap
 1 2 3 swap
-}


{- 对于长度为n的列表，只要冒n-1次泡就可以得到正确顺序了 -}
bsort xs = bsort' xs (length xs)
  where
    bsort' xs 1 = xs
    bsort' xs n = bsort' (bubble xs) (n-1)
    
    bubble [] = []
    bubble (x:[]) = [x]
    bubble (x:y:[])
      | x < y = [x,y]
      | otherwise = [y,x]
    bubble (x:y:xs)
      | x < y = x:(bubble (y:xs))
      | otherwise = y:(bubble (x:xs))


reverse' [] = []
reverse' (x:[]) = [x]
reverse' (x:xs) = reverse' xs ++ [x]

drop' _ [] = []
drop' 0 xs = xs
drop' n (x:xs) = drop (n-1) xs 
