
getS1 "S0" = Just "S1"
getS1 _ = Nothing


getS2 "S1" = Just "S2"
getS2 _ = Nothing


getS3 "S2" = Just "S3"
getS3 _ = Nothing


doSomething m = case (getS1 m) of
  Nothing -> Nothing
  Just m  -> case (getS2 m) of
    Nothing -> Nothing
    Just m  -> case (getS3 m) of
      Nothing -> Nothing
      Just m  -> Just m

comb ::  Maybe a -> (a -> Maybe b) -> Maybe b
comb Nothing _ = Nothing
comb (Just m) f = f m

doSomething' m = comb (comb (comb (Just m) getS1) getS2) getS3

doSomething'' m = (Just m) `comb` getS1 `comb` getS2 `comb` getS3

doSomething'''''' m = (Just m) >>= getS1 >>= getS2 >>= getS3

doSomething''' m = do
  s1 <- getS1 m
  s2 <- getS2 s1
  s3 <- getS3 s2
  return s3

doSomething'''' m = do
  s1 <- getS1 m
  s2 <- getS2 s1
  getS3 s2



return' x = Just x  
doSomething''''' m = do
  s1 <- getS1 m
  s2 <- getS2 s1
  s3 <- getS3 s2
  return' s3

--f = fromJust
--getFromMaybe Nothing _ = 0
--getFromMaybe Just x  = 1



fromJust' (Just x) = x

data Term = Con Int | Add Term Term
          deriving (Show)
                   
eval :: Term -> Int
eval (Con x) = x
eval (Add x y) = (eval x) + (eval y)
