module TableMappings.ComprasServiciosDb
(
  selOneCmd,
  savCmd,
  updCmd,
  delCmd,

  selOneSql,
  savSql,
  updSql,
  delSql,
  
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

instance FromType CompraServicio where
  fromType c =
    [ toSql $ toString (compraId c),
      toSql $ descripcion c,
      toSql $ cantidad c,
      toSql $ precio c,
      toSql $ toString (guidCompraServicio c),
      toSql $ idCompraServicio c ]

selOneSql :: SqlString
selOneSql = "SELECT * FROM comprasservicios where id = ?"

selOneCmd :: Int -> Command
selOneCmd key =
  Command selOneSql [toSql key]

savSql :: SqlString
savSql = "INSERT INTO comprasservicios (compraid, descripcion, cantidad, precio, guid) values (?,?,?,?,?)"

savCmd :: CompraServicio -> Command
savCmd c =
  Command savSql (init $ fromType c)

updSql :: SqlString
updSql = "UPDATE comprasservicios SET compraid=?, descripcion=?, cantidad=?, precio=? where guid=? and id=?"

updCmd :: CompraServicio -> Command
updCmd c =
  Command updSql (fromType c)

delSql :: SqlString
delSql = "DELETE from comprasservicios where id=?"

delCmd :: Int -> Command
delCmd key =
  Command delSql [toSql False, toSql key]

getOne :: Int -> IO (Maybe CompraServicio)
getOne = selectOne . selOneCmd

save :: (Maybe CompraServicio) -> IO Integer
save = persist savCmd 

update :: (Maybe CompraServicio) -> IO Integer
update = persist updCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . delCmd
