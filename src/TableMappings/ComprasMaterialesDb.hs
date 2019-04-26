module TableMappings.ComprasMaterialesDb
(
  getOne,
  save,
  update,
  delete
) where

import Database.HDBC
import DataAccess.Commands
import TableMappings.Types.CompraMaterial
import TableMappings.Types.PageResult
import TableMappings.Types.DbRow
import TableMappings.BaseDb as BaseDb
import Data.UUID

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM comprasmateriales where id = ?" [toSql key]

savCmd :: CompraMaterial -> Command
savCmd c =
  Command "INSERT INTO comprasmateriales (compraid, materialid, cantidad, precio, guid) values (?,?,?,?,?)" (init $ fromType c)

updateCmd :: CompraMaterial -> Command
updateCmd c =
  Command "UPDATE comprasmateriales SET compraid=?, materialid=?, cantidad=?, precio=? where guid=? and id=?" (fromType c)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "DELETE from comprasmateriales where id=?" [toSql False, toSql key]

getOne :: Int -> IO (Maybe CompraMaterial)
getOne key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd toType

save :: (Maybe CompraMaterial) -> IO Integer
save Nothing = return 0
save (Just c) = execNonSelQuery (savCmd c)

update :: (Maybe CompraMaterial) -> IO Integer
update Nothing = return 0
update (Just c) = execNonSelQuery (updateCmd c)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
