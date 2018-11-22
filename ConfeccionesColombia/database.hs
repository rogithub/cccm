module ConfeccionesColombia.Database
(
  execNonSel,
  execSel
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL

defaultConnStr :: String
defaultConnStr = "host=localhost dbname=cc user=postgres"

--TODO: Consider using bracket to close connection.
-- The bracket functions are useful for making sure that
-- resources are released properly by code that may raise exceptions:
-- https://downloads.haskell.org/~ghc/5.00/docs/set/sec-exception.html

--tryCatch :: a -> b
--tryCatch =
    --catchDyn (do f)
              --handler
    --where handler :: CustomError -> IO ()
          --handler err = putStrLn (show err)

execNonSel :: String -> [SqlValue] -> IO Integer
execNonSel sqlCmdStr sqlVals = do
    c <- connectPostgreSQL defaultConnStr
    state <- prepare c sqlCmdStr
    rowCount <- execute state sqlVals
    disconnect c
    return rowCount

execSel :: String -> [SqlValue] -> IO [[SqlValue]]
execSel sqlCmdStr sqlVals = do
    c <- connectPostgreSQL defaultConnStr
    select <- prepare c sqlCmdStr
    execute select sqlVals
    result <- fetchAllRows select
    disconnect c
    return result
