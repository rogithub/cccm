module TableMappings.StocksDb
(
  getAll,
  save
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL
import ConfeccionesColombia.Db
import ConfeccionesColombia.Tipos

toType :: [SqlValue] -> Stock
toType sqlVal =
  Stock { stockId = fromSql (sqlVal!!0)::Int,
    idProducto = fromSql (sqlVal!!1)::Int,
    idProveedor = fromSql (sqlVal!!2)::Int,
    cantidad = fromSql (sqlVal!!3)::Double,
    precio = fromSql (sqlVal!!4)::Double,
    fecha = fromSql (sqlVal!!5)::Day,
    movimiento = fromSql (sqlVal!!6)::Movimiento }

fromType :: Stock -> [SqlValue]
fromType p =
  [toSql $ idProducto p,
  toSql $ idProveedor p,
  toSql $ cantidad p,
  toSql $ precio p,
  toSql $ fecha p,
  toSql $ movimiento p]

getSelCmd :: Command
getSelCmd =
  Command "SELECT * FROM public.\"Stocks\"" []

getAll :: IO [Stock]
getAll = execSelQuery (getSelCmd) >>= (\rows -> return (map toType rows))

getSavCmd :: Stock -> Command
getSavCmd s =
    Command "INSERT INTO public.\"Stocks\" (\"productoId\", \"proveedorId\", cantidad, precio, fecha, movimiento) values (?,?,?,?,?,?)" (fromType s)

save :: Stock -> IO Integer
save p =
  execNonSelQuery (getSavCmd p)
