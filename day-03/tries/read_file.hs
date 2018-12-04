import System.Environment

main = do
    [file] <- getArgs
    content <- readFile file
    let linesOfFiles = lines content
    putStrLn (show (countLines linesOfFiles))

countLines :: [String] -> Integer
countLines [] = 0
countLines (x:xs) = 1 + (countLines xs)

-- printLines :: [IO Char] -> String
-- printLines [] = ""
-- printLines (x:xs) =
--     putStrLn (show (x))
--     printLines xs
-- println (x:xs) = 
--     putStrLn (show x)
--     println xs