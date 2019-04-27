module DataAccess.Commands
( Command(..)
, execSelQuery
, execNonSelQuery
) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import DataAccess.Db

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
