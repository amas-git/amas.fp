import Data.Char
import Control.Monad

data Parsed = Digit Integer | Hex Integer | Word String deriving Show


parseWord :: Parsed -> Char -> [Parsed]
parseWord (Word s) c
  | isAlpha c = return (Word (s ++ [c]))
  | otherwise = mzero
parseWord _ _ = mzero

parseDigit:: Parsed -> Char -> [Parsed]
parseDigit (Digit n) c
  | isDigit c = return (Digit ((n*10) + (toInteger (digitToInt c))))
  | otherwise = mzero
parseDigit _ _ = mzero


parse p c = (parseDigit p c) `mplus` (parseWord p c)


--parseArg :: String -> [Parsed]
parseArg s = do init <- ((return (Digit 0)) `mplus` (return (Word "")))
                foldM parse init s
