
-- http://julio.meroh.net/2006/08/split-function-in-haskell.html
split :: [Char] -> String -> [String]
split delim [] = [""]
split delim (c:cs)
    | elem c delim = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = split delim cs

-- toSomething :: String -> [String]
-- toSomething "" = []
-- toSomething str = 
--     let byAt = split '@' str
--     putStrLn (show byAt)
--     [byAt]
--     -- let byComma = split ',' byAt !! 1
--     -- let x = byComma !! 0
    

-- import System.Environment
main = do
    let strings = split ",@:" "123,  1 @   3434: 0"
    putStrLn (show (map trimAndConvert strings))

trimAndConvert :: String -> Integer
trimAndConvert s = read (filter (/=' ') s)::Integer