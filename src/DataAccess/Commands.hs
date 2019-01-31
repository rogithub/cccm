module DataAccess.Commands
( Command(..)
, execSelQuery
, execNonSelQuery
) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import DataAccess.Db

data Command = Command String [SqlValue] deriving (Show)

execSelQuery :: Command -> IO [[(String, SqlValue)]]
execSelQuery (Command sql params) =
  execQuery (\conn -> execSel conn sql params)

execNonSelQuery :: Command -> IO Integer
execNonSelQuery (Command sql params) =
  execQuery (\conn -> execNonSel conn sql params)
