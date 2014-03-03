

data  BinaryTree a = EmptyTree | Node a (BinaryTree a) (BinaryTree a)
                deriving (Eq)


-- 将元素a转化为BinaryTree
toBinaryTree :: a -> BinaryTree a
toBinaryTree x = Node x EmptyTree EmptyTree

binaryTreeInsert x EmptyTree = toBinaryTree x
binaryTreeInsert x (Node a left right)
  | x == a = Node a left right
  | x <  a = Node a (binaryTreeInsert x left) right
  | x >  a = Node a left (binaryTreeInsert x right)

binaryTreeElem x EmptyTree = False
binaryTreeElem x (Node a left right)
  | x == a = True
  | x <  a = binaryTreeElem x left
  | otherwise = binaryTreeElem x right


toList EmptyTree = []
toList (Node x left right) = (x:(toList left)) ++ (toList right)

-- fromList :: [a] -> BinaryTree a
fromList [] = EmptyTree
fromList xs = foldl (\tree x -> binaryTreeInsert x tree)  EmptyTree xs

treeLength :: BinaryTree a -> Int
treeLength EmptyTree = 0
treeLength (Node x left right) = 1 + (treeLength left) + (treeLength right)


treeHeight :: BinaryTree a -> Int
treeHeight EmptyTree = 0
treeHeight (Node x left right) = 1 + (max (treeHeight left) (treeHeight right))

instance (Show a) => Show (BinaryTree a) where
  show x = showNest x 0
    where
      showNest EmptyTree n = (intent ' ' n) ++ "+-- @\n"
      showNest (Node a left right) n =  (intent ' ' n) ++ "+-- " ++(show a) ++ "\n"
          ++ (showNest left (n+1)) ++ (showNest right (n+1)) ++ "\n"
      intent ch n = take (n*4) $ repeat ch
