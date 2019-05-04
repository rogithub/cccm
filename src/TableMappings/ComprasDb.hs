module TableMappings.ComprasDb
(
  getOne,
  save,
  update,
  delete,

  selOneCmd,
  savCmd,
  updateCmd,
  deleteCmd
  
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.Entities
import DataAccess.PageResult
import TableMappings.Types.Compra
import Data.UUID
import Data.Time.Calendar
import Data.Aeson

instance ToType Compra where
  toType r =
    Compra { idCompra = fromSql (r!!0)::Int,
             guidCompra = read (fromSql (r!!1)::String),
             proveedorId = read (fromSql (r!!2)::String),
             fecha = read (fromSql (r!!3)::String),
             docIdFacturaPdf = read (fromSql (r!!4)::String),
             docIdFacturaXml = read (fromSql (r!!5)::String),
             iva = fromSql (r!!6)::Double,
             activo = fromSql (r!!7)::Bool }

instance FromType Compra where
  fromType t =
    [toSql $ toString (proveedorId t),
     toSql $ show (fecha t),
     toSql $ "", --docIdFacturaPdf t
     toSql $ "", --docIdFacturaXml t
     toSql $ iva t,
     toSql $ activo t,
     toSql $ toString (guidCompra t),
     toSql $ idCompra t]


selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM compras where id = ?" [toSql key]

savCmd :: Compra -> Command
savCmd p =
  Command "INSERT INTO compras \
  \ (proveedorId, fecha, docidfacturapdf, docidfacturaxml, ivaporcien, activo, guid)\
  \ values (?,?,?,?,?,?,?)" (init $ fromType p)

updateCmd :: Compra -> Command
updateCmd p =
  Command "UPDATE compras SET \
  \ proveedorId=?, fecha=?, docidfacturapdf=?, docidfacturaxml=?, ivaporcien=?, activo=?\
  \ where guid=? and id=?" (fromType p)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE compras SET activo=? where id=?" [toSql False, toSql key]

getOne :: Int -> IO (Maybe Compra)
getOne = selectOne . selOneCmd

save :: (Maybe Compra) -> IO Integer
save = persist savCmd 

update :: (Maybe Compra) -> IO Integer
update = persist updateCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . deleteCmd
