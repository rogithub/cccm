module TableMappings.ComprasDb
(
  getOne,
  save,
  update,
  delete
) where

import Database.HDBC
import DataAccess.Commands
--import DataAccess.ConverterUUID as Converter
import TableMappings.Types.Compra
import TableMappings.Types.PageResult
import TableMappings.BaseDb as BaseDb
import Data.UUID
import Data.Time.Calendar

toType :: [SqlValue] -> Compra
toType row =
  Compra { idCompra = fromSql (row!!0) :: Int,
           guidCompra = read (fromSql (row!!1) :: String),
           proveedorId = read (fromSql (row!!2) :: String),
           fecha = fromSql (row!!3) :: Day,
           docIdFacturaPdf = read (fromSql (row!!4) :: String),
           docIdFacturaXml = read (fromSql (row!!5) :: String),
           iva = fromSql (row!!6) :: Double,
           activo = fromSql (row!!7) :: Bool }

fromType :: Compra -> [SqlValue]
fromType c =
  [ toSql $ toString (proveedorId c),
  toSql $ fecha c,
  toSql $ show (docIdFacturaPdf c),
  toSql $ show (docIdFacturaXml c),
  toSql $ iva c,
  toSql $ activo c,
  toSql $ toString (guidCompra c),
  toSql $ idCompra c ]

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM compras where id = ?" [toSql key]

savCmd :: Compra -> Command
savCmd c =
  Command "INSERT INTO compras (proveedorid, fecha, docidfacturapdf, docidfacturaxml, ivaporcien, activo, guid) values (?,?,?,?,?,?,?)" (init $ fromType c)

updateCmd :: Compra -> Command
updateCmd c =
  Command "UPDATE compras SET proveedorid=?, fecha=?, docidfacturapdf=?, docidfacturaxml=?, ivaporcien=?, activo=? where guid=? and id=?" (fromType c)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE compras set activo=? where id=?" [toSql False, toSql key]

getOne :: Int -> IO (Maybe Compra)
getOne key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd toType

save :: (Maybe Compra) -> IO Integer
save Nothing = return 0
save (Just c) = execNonSelQuery (savCmd c)

update :: (Maybe Compra) -> IO Integer
update Nothing = return 0
update (Just c) = execNonSelQuery (updateCmd c)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
