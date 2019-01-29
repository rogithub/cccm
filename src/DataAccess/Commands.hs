module DataAccess.Commands
( Command(..)
, execSelQuery
, execNonSelQuery
, PageResult(..)
) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import DataAccess.Db

data Command = Command String [SqlValue] deriving (Show)
data PageResult a = PageResult { rows :: a[] , totalRows :: Int }

execSelQuery :: Command -> IO [[SqlValue]]
execSelQuery (Command sql params) =
  execQuery (\conn -> execSel conn sql params)

execNonSelQuery :: Command -> IO Integer
execNonSelQuery (Command sql params) =
  execQuery (\conn -> execNonSel conn sql params)
