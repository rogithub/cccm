module DataAccess.Db
(
  getCon,
  execNonSel,
  execSel,
  execQuery
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL

defaultConnStr :: String
defaultConnStr = "host=localhost dbname=cc user=postgres"

getCon :: IO Connection
getCon = connectPostgreSQL defaultConnStr

execNonSel :: Connection -> String -> [SqlValue] -> IO Integer
execNonSel conn sqlCmdStr sqlVals = do
  state <- prepare conn sqlCmdStr
  rowCount <- execute state sqlVals
  return rowCount

execSel :: Connection -> String -> [SqlValue] -> IO [[SqlValue]]
execSel conn sqlCmdStr sqlVals = do
  select <- prepare conn sqlCmdStr
  execute select sqlVals
  result <- fetchAllRows' select
  return result

execQuery :: (Connection -> IO a) -> IO a
execQuery f = do
  bracket
    getCon
    (\c -> disconnect c)
    (\c -> do
        result <- f c
        commit c
        return result)
