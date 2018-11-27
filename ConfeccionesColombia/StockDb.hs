module ConfeccionesColombia.StocksDb
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
    cantidad = fromSql (sqlVal!!2)::Double,
    precio = fromSql (sqlVal!!3)::Double,
    fecha = fromSql (sqlVal!!4)::Day,
    movimiento = fromSql (sqlVal!!5)::Movimiento }

fromType :: Stock -> [SqlValue]
fromType p =
  [toSql $ idProducto p,
  toSql $ cantidad p,
  toSql $ precio p,
  toSql $ fecha p,
  toSql $ movimiento p]

allQ :: Connection -> IO [[SqlValue]]
allQ c =
  execSel c "SELECT * FROM public.\"Stocks\"" []

getAll :: ([Stock] -> IO a) -> IO a
getAll f =
  execQuery (\c -> allQ c >>= (\rows -> f $ map toType rows))

savQ :: Connection -> [SqlValue] -> IO Integer
savQ c v =
    execNonSel c "INSERT INTO public.\"Stocks\" (productoId, cantidad, precio, fecha, movimiento) values (?,?,?,?,?)" v

save :: Stock -> IO Integer
save p =
  execQuery (\c -> savQ c (fromType p))
