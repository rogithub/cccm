module TableMappings.ProductosDb
(
  getAll,
  save
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Producto

toType :: [SqlValue] -> Producto
toType sqlVal =
  Producto { id = fromSql (sqlVal!!0)::Int,
    nombre = fromSql (sqlVal!!1)::String,
    color = fromSql (sqlVal!!2)::String,
    unidad = fromSql (sqlVal!!3)::String,
    marca = fromSql (sqlVal!!4)::String,
    modelo = fromSql (sqlVal!!5)::String,
    comentarios = fromSql (sqlVal!!6)::String }

fromType :: Producto -> [SqlValue]
fromType p =
  [toSql $ nombre p,
  toSql $ color p,
  toSql $ unidad p,
  toSql $ marca p,
  toSql $ modelo p,
  toSql $ comentarios p]

getSelCmd :: Command
getSelCmd =
  Command "SELECT * FROM public.\"Productos\"" []

getAll :: IO [Producto]
getAll = execSelQuery (getSelCmd) >>= (\rows -> return (map toType rows))

getSavCmd :: Producto -> Command
getSavCmd p =
    Command "INSERT INTO public.\"Productos\" (nombre, color, unidad, marca, modelo, comentarios) values (?,?,?,?,?,?)" (fromType p)

save :: Producto -> IO Integer
save p =
  execNonSelQuery (getSavCmd p)
