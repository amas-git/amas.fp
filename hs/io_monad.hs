import System.Environment
import System.IO
import Control.Monad.Error
import System.IO.Error
import Control.Exception

translateString []   _  s = s
translateString _    [] s = s
translateString from to s = [ tr c | c <- s]
                            where dict = zip from to
                                  tr c = case (lookup c dict) of
                                         Nothing   -> c
                                         (Just c') -> c'
usage e = do
  putStrLn "Usage: "
  
doTranslate :: IO ()
doTranslate = do
  [from, to] <- getArgs
  input <- getLine
  print $ translateString from to input
  
{--
*Main> :set args "abc" "ABC"
*Main> doTranslate 
abcdefg
"ABCdefg

*Main> :set args "abc"
*Main> doTranslate 
*** Exception: user error (Pattern match failure in do expression at io_monad.hs:22:3-12)

--}
doTranslateSafe :: IO ()
doTranslateSafe = (do
  [from, to] <- getArgs
  input <- getLine
  print $ translateString from to input) `catchError` usage


cat2 :: FilePath -> IO ()
cat2 path = do
  h <- readFile path
  print h



cat path = do
  h <- openFile path ReadMode
  hCat h
    where hCat h = do
            eof <- hIsEOF h
            if eof then return ""
            else do 
                 c <- hGetChar h
                 putChar c
                 hCat h

cat3 path = do
  h <- openFile path ReadMode 
  hCat h
    where hCat h = do
            eof <- hIsEOF h
            if eof then return ""
            else do 
                 c <- hGetChar h
                 putChar c
                 hCat h

writerLine path = do
  line <- getLine
  hT   <- openFile path WriteMode
  hPutStrLn hT line 
  hClose hT




x f = do
  catch (openFile f ReadMode) (\e -> hPutStr stderr ("Couldn't open "++f++": " ++ show e))
  return ""
      
