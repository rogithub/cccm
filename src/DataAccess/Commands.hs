module DataAccess.Commands
(
  Command(..)
  , SqlString
  , execSelQuery
  , execNonSelQuery
  , execManySql
) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import DataAccess.Db

type SqlString = String

data Command = Command SqlString [SqlValue] deriving (Show)

execSelQuery :: Command -> IO [[SqlValue]]
execSelQuery (Command sql params) =
  execQuery (\conn -> execSel conn sql params)

execNonSelQuery :: Command -> IO Integer
execNonSelQuery (Command sql params) =
  execQuery (\conn -> execNonSel conn sql params)

execManySql :: String -> [[SqlValue]] -> IO ()
execManySql sql rows =
  execQuery (\conn -> execMany conn sql rows) 

  
