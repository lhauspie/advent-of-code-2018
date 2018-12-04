-- https://stackoverflow.com/questions/28624408/equal-vs-left-arrow-symbols-in-haskell

import System.Environment

main = do
    [file1, file2] <- getArgs
    --copy file contents
    str <- readFile file1
    writeFile file2 str




-- https://stackoverflow.com/questions/17525149/create-list-of-strings-in-haskell

-- board :: [[]] -> [[]]
-- board = map lines [1..1000]
--   where lines l = map columns [1..1000]
--       where columns c = 0

-- main = do
--     board



-- http://julio.meroh.net/2006/08/split-function-in-haskell.html
split :: -> Char String -> [String]
split delim [] = []
split delim (x:xs)
    | x == delim = "" : rest
    | otherwise = (x : head rest) : tail rest
    where
        rest = split delim xs

-- import System.Environment
main = do
    let strings = split "my,comma,separated,list" ','
    putStrLn (strings !! 0)




-- main = do
--     [file] <- getArgs
--     -- read content of file
--     content <- readFile file
--     let linesOfFiles = lines content
--     printLines linesOfFiles

-- printLines :: [IO String] -> IO String
-- printLines (lines) = do
--     line <- lines !! 0
--     line
