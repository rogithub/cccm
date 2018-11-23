module ConfeccionesColombia.ProveedoresDb
(
  getProveedores
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL
import ConfeccionesColombia.Database as Db
import ConfeccionesColombia.Tipos

toProveedor :: [SqlValue] -> Proveedor
toProveedor sqlVal =
  Proveedor { proveedorId = fromSql (sqlVal!!0)::Int,
    empresa = fromSql (sqlVal!!1)::String,
    contacto = fromSql (sqlVal!!2)::String,
    domicilio = fromSql (sqlVal!!3)::String,
    telefono = fromSql (sqlVal!!4)::String,
    email = fromSql (sqlVal!!5)::String,
    comentarios = fromSql (sqlVal!!6)::String,
    activo = fromSql (sqlVal!!7)::Bool }

getAll :: Connection -> IO [Proveedor]
getAll c = do
  rows <- execSel c "select * from public.\"Proveedores\"" []
  return (map toProveedor rows)


getProveedores :: (IO [Proveedor] -> IO a) -> IO a
getProveedores f = do
  Db.execQuery (f . getAll)
