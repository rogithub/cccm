module TableMappings.BaseDb
(
  getPageResult,
  rowToType,
  rowsToType
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.PageResult
import DataAccess.ValueHelpers

getPageResult :: Command -> ([SqlValue] -> a) -> IO (PageResult a)
getPageResult cmd toType = do
  rows <- execSelQuery cmd
  return (PageResult (map toType rows) (getTotalRows rows))

fstRowToType :: [[SqlValue]] -> ([SqlValue] -> a) -> Maybe a
fstRowToType rows toType =
  case rows of [x] -> Just (toType x)
               _   -> Nothing

rowToType :: Command -> ([SqlValue] -> a) -> IO (Maybe a)
rowToType cmd toType = do
  rows <- execSelQuery cmd
  return (fstRowToType rows toType)

rowsToType :: Command -> ([SqlValue] -> a) -> IO [a]
rowsToType cmd toType = do
  map toType <$> execSelQuery cmd
