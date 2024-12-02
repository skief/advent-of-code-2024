import Data.List ( inits, tails )


isMonotonic :: [Int] -> Bool
isMonotonic diffs = all (> 0) diffs || all (< 0) diffs

isInRange :: [Int] -> Bool
isInRange diffs = all((<= 3) . abs) diffs

isSafe :: [Int] -> Bool
isSafe levels = (isMonotonic diffs) && (isInRange diffs) 
    where diffs = zipWith (-) levels (drop 1 levels)

isTolerated :: [Int] -> Bool
isTolerated levels = any isSafe combinations
    where combinations = zipWith (++) (inits levels) (map (drop 1) $ tails levels)


part1 :: [[Int]] -> Int
part1 reports = length $ filter isSafe reports

part2 :: [[Int]] -> Int
part2 reports = length $ filter isTolerated reports


main :: IO() 
main = do
    inputFile <- readFile "inputs/day02"
    let reports = map(map read . words) (lines inputFile)

    print $ part1 reports
    print $ part2 reports