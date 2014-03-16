
getS1 "S0" = Just "S1"
getS1 _ = Nothing


getS2 "S1" = Just "S2"
getS2 _ = Nothing


getS3 "S2" = Just "S3"
getS3 _ = Nothing


doSomething a =
  case (getS1 a) of
    Nothing -> Nothing
    Just a  -> case (getS2 a) of
      Nothing -> Nothing
      Just a  -> case (getS3 a) of
        Nothing -> Nothing
        Just a  -> Just a

comb ::  Maybe a -> (a -> Maybe b) -> Maybe b
comb Nothing _ = Nothing
comb (Just a) f = f a

doSomething1 a = comb (comb (comb (Just a) getS1) getS2) getS3

doSomething11 a = comb (comb (getS1 a) getS2) $ getS3

-- 
doSomething2 a = (Just a) `comb` getS1 `comb` getS2 `comb` getS3

doSomething3 a = (((Just a) >>= getS1) >>= getS2) >>= getS3

-- 可能你发现了,(Just a)完全是多余的
doSomething33 a = ((getS1 a >>= getS2) >>= getS3)

doSomething4 a = getS1 a  >>= (\s1 -> getS2 s1 >>= (\s2 -> getS3 s2))

doSomething5 a =
  getS1 a  >>= \s1 ->
  getS2 s1 >>= \s2 ->
  getS3 s2
 
-- 好了,该请出do-notation了:
doSomething6 a = do
  s1 <- getS1 a
  s2 <- getS2 s1
  getS3 s2
  
doSomething7 a = do
  s1 <- getS1 a
  s2 <- getS2 s1
  s3 <- getS3 s2
  return s3


  
  

doSomething9 a = do
  x <- getS1 a
  y <- getS1 a
  getS2 x

doSomething99 a =
  getS1 a >>= \x ->
  getS1 a >>= \y ->
  getS2 x

doSomething999 a = getS1 a >>= (\x -> getS1 a >>= (\y -> getS2 x))


data Maybe a = Nothing | Just a

instance Monad Maybe where
  return         = Just
  fail           = Nothing
  Nothing  >>= f = Nothing
  (Just x) >>= f = f x

instance MonadPlus Maybe where
  mzero             = Nothing
  Nothing `mplus` x = x
  x `mplus` _       = x
  
class Error a where
  noMsg  :: a
  strMsg :: String -> a

class (Monad m) => MonadError e m | m -> e where
  throwError :: e -> m a
  catchError :: m a -> (e -> m a) -> m  a
  --getS3 s2
{--
== do notaion
do notaion语法糖做了以下事情:

x <- expr1
被翻译成:
expr1 >>= \x ->

expr2
被翻译成:
expr2 >>= \_ ->

s1 <- getS1 m
s2 <- getS2 s1
getS3 s2

等价于:
getS1 m  >>= \s1 ->
getS2 s1 >>= \s2 ->
getS3 s2 >>= \
--}


return' x = Just x  
doSomething''''' m = do
  s1 <- getS1 m
  s2 <- getS2 s1
  s3 <- getS3 s2
  return' s3

--f = fromJust
--getFromMaybe Nothing _ = 0
--getFromMaybe Just x  = 1
instance Monad [] where
  m >>= f  = concatMap f m
  return x = [x]
  fail   s = []

instance MonadPlus [] where
  mzero = []
  mplus = (++)
{-
Zeor and Plus
 1. mzero >>= f == mzero
 2. m >>= (\x -> mzero) == mzero
 3. mzero `mplus` m == m
 4. m `mplus` mzero == m

 * mzero 相当于 0
 * mplus 相当于 +
 * >>=   相当于 x

 1. 0 * _ == 0
 2. m * 0 == 0
 3. 0 + m == m
 5. m + 0 == m


class (Monad m) => MonadPlus m where
mzero :: m a
mplus :: m a -> m a -> m a

instance MonadPlus Maybe where
mzero = Nothing
Nothing `mplus` x = x
x `mplus` _ = x
-}

mzero = Nothing
x `mplus` _ = x
--Nothing `mplus` x = x
{--

*Main> (mzero >>= (\x -> (Just x))) == mzero
True


对于List来说:
 * mzero 相当于 []
 * mplus 相当于 `++`
--}

fromJust' (Just x) = x

data Term = Con Int | Add Term Term
          deriving (Show)
                   
eval :: Term -> Int
eval (Con x) = x
eval (Add x y) = (eval x) + (eval y)
{--
*Main> sequence [putChar 'a', putChar 'b']
ab[(),()]

*Main> sequence_ [putChar 'a', putChar 'b']
ab


*Main> sequence [getS1 "S0", getS2 "S1"]
Just ["S1","S2"]
--}

putString_ :: [Char] -> IO ()
putString_ s = mapM_ putChar s

putString s = mapM putChar s

{--
与map类比:
map :: (a -> b) -> [a] -> [b]
mapM :: Monad m => (a -> m b) -> [a] -> m [b]

mapM可以在do-block中直接使用
--}


getName :: String -> Maybe String
getName name = do let db = [("John", "Smith, John"), ("Mike", "Caine, Michael")]
                  tempName <- lookup name db
                  return (tempName)


-- f x = x + 1
-- 等价于
f = \x -> x + 1
-- f x = \y + 1
