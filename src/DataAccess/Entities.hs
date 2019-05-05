module DataAccess.Entities
(
  ToType(..),
  FromType(..),
  selectOne,
  selectMany,
  getPages,
  persist,
  savMany
) where

import Database.HDBC
import DataAccess.PageResult
import DataAccess.Commands
import DataAccess.ValueHelpers

class ToType a where
  toType :: [SqlValue] -> a

class FromType a where
  fromType :: a -> [SqlValue]

fstRowToType :: ToType a => [[SqlValue]] -> Maybe a
fstRowToType rows =
  case rows of [x] -> Just (toType x)
               _   -> Nothing

selectOne :: ToType a => Command -> IO (Maybe a)
selectOne cmd = do
  rows <- execSelQuery cmd
  return (fstRowToType rows)

selectMany :: ToType a => Command -> IO [a]
selectMany cmd = do
  map toType <$> execSelQuery cmd

getPages :: ToType a => Command -> IO (PageResult a)
getPages cmd = do
  rows <- execSelQuery cmd
  return (PageResult (map toType rows) (getTotalRows rows))

persist :: (a -> Command) -> (Maybe a) -> IO Integer
persist f Nothing  = return 0
persist f (Just p) = execNonSelQuery (f p)

savMany :: FromType a => SqlString -> [a] -> IO ()
savMany sql rows =
  execManySql sql (map (\x -> fromType x) rows)
