module TableMappings.QueryHelpers
(
  getTotalRows
) where

import Database.HDBC
import Data.List

getTotalRows :: [[SqlValue]] -> Int -> Int
getTotalRows [[]] _   = 0
getTotalRows (x:xs) i = fromSql (x!!i)::Int
