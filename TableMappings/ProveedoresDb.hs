module TableMappings.ProveedoresDb
(
  getAll,
  save
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Proveedor

toType :: [SqlValue] -> Proveedor
toType sqlVal =
  Proveedor { idProveedor = fromSql (sqlVal!!0)::Int,
    empresa = fromSql (sqlVal!!1)::String,
    contacto = fromSql (sqlVal!!2)::String,
    domicilio = fromSql (sqlVal!!3)::String,
    telefono = fromSql (sqlVal!!4)::String,
    email = fromSql (sqlVal!!5)::String,
    comentarios = fromSql (sqlVal!!6)::String,
    activo = fromSql (sqlVal!!7)::Bool }

fromType :: Proveedor -> [SqlValue]
fromType p =
  [toSql $ empresa p,
  toSql $ contacto p,
  toSql $ domicilio p,
  toSql $ telefono p,
  toSql $ email  p,
  toSql $ comentarios p,
  toSql $ activo p]

getSelCmd :: Command
getSelCmd =
  Command "SELECT * FROM public.\"Proveedores\"" []

getAll :: IO [Proveedor]
getAll = execSelQuery (getSelCmd) >>= (\rows -> return (map toType rows))

getSavCmd :: Proveedor -> Command
getSavCmd p =
    Command "INSERT INTO public.\"Proveedores\" (empresa, contacto, domicilio, telefono, email, comentarios, activo) values (?,?,?,?,?,?,?)" (fromType p)

save :: Proveedor -> IO Integer
save p =
  execNonSelQuery (getSavCmd p)
