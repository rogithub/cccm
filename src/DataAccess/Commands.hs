module DataAccess.Commands
(
  Command(..)
  , execSelQuery
  , execNonSelQuery
  , getPageResult
  , fstRowToType
  , rowToType
  , rowsToType
) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import DataAccess.Db
import DataAccess.PageResult
import DataAccess.ValueHelpers

data Command = Command String [SqlValue] deriving (Show)

cmdSepparator :: String -> String -> String
cmdSepparator [] [] = []
cmdSepparator s1 [] = s1
cmdSepparator [] s2 = s2
cmdSepparator s1 s2 = s1 ++ ";" ++ s2

joinCmd :: Command -> Command -> Command
joinCmd (Command sql1 params1) (Command sql2 params2) =
  Command (cmdSepparator sql1 sql2) (params1 ++ params2) 

instance Semigroup Command where
  (<>) = joinCmd 

instance Monoid Command where
  mempty = Command "" []
  mappend = joinCmd


execSelQuery :: Command -> IO [[SqlValue]]
execSelQuery (Command sql params) =
  execQuery (\conn -> execSel conn sql params)

execNonSelQuery :: Command -> IO Integer
execNonSelQuery (Command sql params) =
  execQuery (\conn -> execNonSel conn sql params)


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
