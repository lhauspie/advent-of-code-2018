import Data.Array
import System.Environment


data Point = Empty | Visited | Collide
    deriving (Enum, Eq)

instance Show Point where
    show (Empty) = "."
    show (Visited) = "#"
    show (Collide) = "X"

incPoint :: Point -> Point
incPoint Empty = Visited
incPoint Visited = Collide
incPoint Collide = Collide



matrix :: (Ix k) => k -> k -> v -> Array k v
matrix i j val = listArray (i,j) (repeat val)

incMatrix :: (Ix k) => Array k Point -> k -> k -> Array k Point
incMatrix mat i j = mat//[(n, incPoint (mat!n)) | n <- range (i,j)]

-- count number of Point in the [Point]
countNumberOf :: Point -> [Point] -> Integer
countNumberOf _ [] = 0
countNumberOf p (x:xs)
    | x == p = 1 + rest
    | otherwise = rest
    where
        rest = countNumberOf p xs


-- split a String by several char separators
-- split ",@" "1234,678@9876" => ["1234", "678", "9876"]
split :: [Char] -> String -> [String]
split delim [] = [""]
split delim (c:cs)
    | elem c delim = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = split delim cs


trimAndConvert :: String -> Integer
trimAndConvert s = read (filter (/=' ') s)::Integer


getElveFrom :: String -> [Integer]
getElveFrom str = map trimAndConvert (split "@,:x" str)



main = do
    [file] <- getArgs
    content <- readFile file
    let linesOfFiles = lines content
    let linesWithoutDiese = map tail linesOfFiles
    let elves = map getElveFrom linesWithoutDiese

    let initialBoard = matrix (0,0) (1000, 1000) Empty
    let finalBoard = calculateBoard initialBoard elves

    let count = countNumberOf Collide (elems finalBoard)
    putStrLn (show count)

    -- let initialBoard = matrix (0,0) (10, 10) Empty
    -- let board_add1 = incMatrix initialBoard (2,2) (4,4)
    -- let result = incMatrix board_add1 (2,2) (3,3)
    -- putStrLn (show result)
    -- let count = countNumberOf Collide (elems result)
    -- putStrLn (show count) -- should 4 collides


calculateBoard :: Array (Integer, Integer) Point -> [[Integer]] -> Array (Integer, Integer) Point
calculateBoard board [] = board
calculateBoard board (x:xs) = calculateBoard (incMatrix board (x!!1, x!!2) (x!!1+x!!3-1, x!!2+x!!4-1)) xs
    -- let nextBoard = incMatrix board (x!1, x!2) (x!1+x!3-1, x!2+x!4-1)
    -- putStrLn (show xs)
    