module ConfeccionesColombia.ProductosDb
(
  getAll,
  save
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL
import ConfeccionesColombia.Db
import ConfeccionesColombia.Tipos

toType :: [SqlValue] -> Producto
toType sqlVal =
  Producto { productoId = fromSql (sqlVal!!0)::Int,
    nombre = fromSql (sqlVal!!1)::String,
    color = fromSql (sqlVal!!2)::String,
    unidad = fromSql (sqlVal!!3)::String,
    idProveedor = fromSql (sqlVal!!4)::Int }

fromType :: Producto -> [SqlValue]
fromType p =
  [toSql $ nombre p,
  toSql $ color p,
  toSql $ unidad p,
  toSql $ idProveedor p]

allQ :: Connection -> IO [[SqlValue]]
allQ c =
  execSel c "SELECT * FROM public.\"Productos\"" []

getAll :: ([Producto] -> IO a) -> IO a
getAll f =
  execQuery (\c -> allQ c >>= (\rows -> f $ map toType rows))

savQ :: Connection -> [SqlValue] -> IO Integer
savQ c v =
    execNonSel c "INSERT INTO public.\"Productos\" (nombre, color, unidad, proveedorId) values (?,?,?,?)" v

save :: Producto -> IO Integer
save p =
  execQuery (\c -> savQ c (fromType p))
