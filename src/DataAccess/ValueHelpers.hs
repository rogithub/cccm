module DataAccess.ValueHelpers
(
  getIntOrDefault,
  getIntOrZero,
  getFstIntOrZero
) where

import Database.HDBC
import Data.List

getIntOrDefault :: Int -> [SqlValue] -> Int -> Int
getIntOrDefault def [] _ = def
getIntOrDefault _ row i = fromSql (row!!i) :: Int

getIntOrZero :: [SqlValue] -> Int -> Int
getIntOrZero row i = getIntOrDefault 0 row i

getFstIntOrZero :: [[SqlValue]] -> Int -> Int
getFstIntOrZero [] _ = 0
getFstIntOrZero (row:_) i = getIntOrZero row i
