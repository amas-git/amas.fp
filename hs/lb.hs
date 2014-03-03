--
import Foreign
f1 x y = x
f2 x y = x


comp a b = do 
  pa <- newStablePtr a
  pb <- newStablePtr b
  let res = pa == pb
  freeStablePtr pa
  freeStablePtr pb
  return res

true x y = x
false x y = y
not = false . true

id x = x

apply f a = f a


