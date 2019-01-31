module TableMappings.StockDb
(
  getAll,
  save
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Stock
import Data.Time.Calendar

toType :: [SqlValue] -> Stock
toType sqlVal =
  Stock { idStock = fromSql (sqlVal!!0)::Int,
    idProducto = fromSql (sqlVal!!1)::Int,
    idProveedor = fromSql (sqlVal!!2)::Int,
    cantidad = fromSql (sqlVal!!3)::Double,
    precio = fromSql (sqlVal!!4)::Double,
    fecha = fromSql (sqlVal!!5)::Day,
    movimiento = fromSql (sqlVal!!6)::Int }

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
