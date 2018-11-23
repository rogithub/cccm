module ConfeccionesColombia.Database
(
  getCon,
  execNonSel,
  execSel,
  execQuery,
  listarProveedores
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

-- don't forguet to call: disconnect conn
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
  result <- fetchAllRows select
  return result

execQuery :: (Connection -> IO ()) -> IO ()
execQuery f = do
  c <- getCon
  f c
  disconnect c
  return ()

listarProveedores :: Connection -> IO ()
listarProveedores c = do
  proveedores <- execSel c "select * from public.\"Proveedores\"" []
  putStrLn $ show proveedores
  return ()
