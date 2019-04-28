module TableMappings.ComprasServiciosDb
(
  getOne,
  save,
  update,
  delete
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.PageResult
import DataAccess.Entities
import TableMappings.Types.CompraServicio
import Data.UUID

instance ToType CompraServicio where
  toType row =
    CompraServicio { idCompraServicio = fromSql (row!!0) :: Int,
                     guidCompraServicio = read (fromSql (row!!1) :: String),
                     compraId = read (fromSql (row!!2) :: String),
                     descripcion = fromSql (row!!3) :: String,
                     cantidad = fromSql (row!!4) :: Double,
                     precio = fromSql (row!!5) :: Double }

fromType :: CompraServicio -> [SqlValue]
fromType c =
  [ toSql $ toString (compraId c),
    toSql $ descripcion c,
    toSql $ cantidad c,
    toSql $ precio c,
    toSql $ toString (guidCompraServicio c),
    toSql $ idCompraServicio c ]


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
getOne = selectOne . selOneCmd

save :: (Maybe CompraServicio) -> IO Integer
save = persist savCmd 

update :: (Maybe CompraServicio) -> IO Integer
update = persist updateCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . deleteCmd
