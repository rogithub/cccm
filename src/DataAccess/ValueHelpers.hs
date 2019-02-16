module DataAccess.ValueHelpers
(
  getIntOrDefault,
  getIntOrZero,
  getTotalRows
) where

import Database.HDBC
import Data.List

getIntOrDefault :: Int -> [SqlValue] -> Int -> Int
getIntOrDefault def [] _ = def
getIntOrDefault _ row i = fromSql (row!!i) :: Int

getIntOrZero :: [SqlValue] -> Int -> Int
getIntOrZero row i = getIntOrDefault 0 row i

getTotalRows :: [[SqlValue]] -> Int
getTotalRows [] = 0
getTotalRows (r:rs) = getIntOrZero r ((length r) - 1)
