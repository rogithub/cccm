module TableMappings.QueryHelpers
(
  getTotalRows,
  getByColName
) where

import Database.HDBC
import Data.List

getByColName :: [(String, SqlValue)] -> String -> Maybe (String, SqlValue)
getByColName row name = find (\t -> (fst t) == name) row

--getValOrDefault :: [(String, SqlValue)] -> String -> a -> a
--getValOrDefault row name def =
--  case getByColName row name of Nothing -> def
--                                Just col-> fromSql (snd col)::a

getTotalRows :: [[(String, SqlValue)]] -> Int
getTotalRows [[]]   = 0
getTotalRows (x:xs) =
  case getByColName x "TOTAL_ROWS" of Nothing -> 0
                                      Just col-> fromSql (snd col)::Int
