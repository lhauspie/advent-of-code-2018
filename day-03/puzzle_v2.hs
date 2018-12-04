import Data.Array
import System.Environment

main = do
    [file] <- getArgs
    content <- readFile file
    let linesOfFiles = lines content
    let linesWithoutDiese = map tail linesOfFiles
    let elves = map getElveFrom linesWithoutDiese
    
    let boardCoords = range ((0,0),(1000, 1000))

    let collidesCount = nbCollides boardCoords elves
    putStrLn (show collidesCount)


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
getElveFrom str = do
    let elveInfo = map trimAndConvert (split "@,:x" str)
    [elveInfo!!1, elveInfo!!2, (elveInfo!!3 + elveInfo!!1 - 1), (elveInfo!!4 + elveInfo!!2 - 1)]


isIn :: (Integer, Integer) -> [Integer] -> Bool
isIn (x, y) e = (x >= e!!0) && (x <= e!!2) && (y >= e!!1) && (y <= e!!3)


-- input params : coord(x,y), elves / output : nbElvesOnCoord
nbElves :: (Integer, Integer) -> [[Integer]] -> Integer
nbElves _ [] = 0
nbElves coord (e:es)
--    putStrLn (show ((x >= e!!0) && (x <= (e!!1)) && (y >= e!!2) && (y <= (e!!3))))
    | isIn coord e = 1 + rest
    | otherwise = rest
    where
        rest = nbElves coord es


-- input params : coords, elves / output : nbCoordsWithCollides
nbCollides :: [(Integer, Integer)] -> [[Integer]] -> Integer
nbCollides _ [] = 0
nbCollides [] _ = 0
nbCollides (c:cs) e 
    | (nbElves c e) > 1 = 1 + rest
    | otherwise = rest
    where
        rest = nbCollides cs e