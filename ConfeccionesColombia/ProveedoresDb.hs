module ConfeccionesColombia.ProveedoresDb
(
  getAll,
  save
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL
import ConfeccionesColombia.Db
import ConfeccionesColombia.Tipos

toType :: [SqlValue] -> Proveedor
toType sqlVal =
  Proveedor { proveedorId = fromSql (sqlVal!!0)::Int,
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

allQ :: Connection -> IO [[SqlValue]]
allQ c =
  execSel c "SELECT * FROM public.\"Proveedores\"" []

getAll :: ([Proveedor] -> IO a) -> IO a
getAll f =
  execQuery (\c -> allQ c >>= (\rows -> f $ map toType rows))

savQ :: Connection -> [SqlValue] -> IO Integer
savQ c v =
    execNonSel c "INSERT INTO public.\"Proveedores\" values (?,?,?,?,?,?,?)" v

save :: Proveedor -> IO Integer
save p =
  execQuery (\c -> savQ c (fromType p))
