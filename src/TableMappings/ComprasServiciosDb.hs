module TableMappings.ComprasServiciosDb
(
  getOne,
  save,
  update,
  delete
) where

import Database.HDBC
import DataAccess.Commands
import TableMappings.Types.CompraServicio
import TableMappings.Types.PageResult
import TableMappings.Types.DbRowClass
import TableMappings.BaseDb as BaseDb
import Data.UUID

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM comprasservicios where id = ?" [toSql key]

savCmd :: CompraServicio -> Command
savCmd c =
  Command "INSERT INTO comprasservicios (compraid, descripcion, cantidad, precio, guid) values (?,?,?,?,?)" (init $ fromType c)

updateCmd :: CompraServicio -> Command
updateCmd c =
  Command "UPDATE comprasservicios SET compraid=?, descripcion=?, cantidad=?, precio=? where guid=? and id=?" (fromType c)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "DELETE from comprasservicios where id=?" [toSql False, toSql key]

getOne :: Int -> IO (Maybe CompraServicio)
getOne key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd toType

save :: (Maybe CompraServicio) -> IO Integer
save Nothing = return 0
save (Just c) = execNonSelQuery (savCmd c)

update :: (Maybe CompraServicio) -> IO Integer
update Nothing = return 0
update (Just c) = execNonSelQuery (updateCmd c)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
