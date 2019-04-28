module TableMappings.ComprasModelDb
(
  save
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.PageResult
import DataAccess.Entities
import TableMappings.Models.Compra
import Data.UUID
import Data.Time.Calendar

fromType :: Compra -> [SqlValue]
fromType c =
  [ toSql $ toString (guidProveedor c),
  toSql $ show (fecha c),
  toSql $ "",
  toSql $ "",
  toSql $ iva c,
  toSql $ activo c,
  toSql $ toString (guidCompra c),
  toSql $ idCompra c ]


savCmd :: Compra -> Command
savCmd c =
  Command "INSERT INTO compras (proveedorid, fecha, docidfacturapdf, docidfacturaxml, ivaporcien, activo, guid) values (?,?,?,?,?,?,?)" (init $ fromType c)

save :: (Maybe Compra) -> IO Integer
save = persist savCmd
