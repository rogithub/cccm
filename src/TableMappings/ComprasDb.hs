module TableMappings.ComprasDb
(
  getOne,
  save,
  update,
  delete,

  selOneSql,
  savSql,
  updSql,
  delSql,
  
  selOneCmd,
  savCmd,
  updCmd,
  delCmd
  
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


selOneSql :: SqlString
selOneSql = "SELECT * FROM compras where id = ?"

selOneCmd :: Int -> Command
selOneCmd key =
  Command selOneSql [toSql key]

savSql :: SqlString
savSql = "INSERT INTO compras \
  \ (proveedorId, fecha, docidfacturapdf, docidfacturaxml, ivaporcien, activo, guid)\
  \ values (?,?,?,?,?,?,?)"
  
savCmd :: Compra -> Command
savCmd p =
  Command savSql (init $ fromType p)

updSql :: SqlString
updSql = "UPDATE compras SET \
  \ proveedorId=?, fecha=?, docidfacturapdf=?, docidfacturaxml=?, ivaporcien=?, activo=?\
  \ where guid=? and id=?"
  
updCmd :: Compra -> Command
updCmd p =
  Command updSql (fromType p)

delSql :: SqlString
delSql = "UPDATE compras SET activo=? where id=?"

delCmd :: Int -> Command
delCmd key =
  Command delSql [toSql False, toSql key]

getOne :: Int -> IO (Maybe Compra)
getOne = selectOne . selOneCmd

save :: (Maybe Compra) -> IO Integer
save = persist savCmd 

update :: (Maybe Compra) -> IO Integer
update = persist updCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . delCmd
