max' a b
  | a > b     = a
  | a == b    = a
  | otherwise = b



firstLetter :: String -> String
firstLetter "" = "Empty string, whoops!"
firstLetter all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]

en 1 = "ONE"
en 2 = "TWO"


waterMark x
  | x < 50 = "GOOD"
  | x < 60 && x > 50 = "BAD"
  | otherwise = "UNKNOW"

centerRect (l,t,b,r) = (width/2, height/2)
    where width  = r - l
          height = b - t

circleArea r = pi * r * r
  where pi=3.141592653

-- let <bindings> in <expr>
circleArea' r =
  let pi = 3.1415926
  in pi * r * r

-- 是直角三角形?
isTri (x,y,z) =
  let max = max x (max y z)
      min = min x (min y z)
      mid = x + y + z - min - max
  in  (min * min + mid * mid == max * max)
