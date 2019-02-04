module TableMappings.StockDb
(
  getAll,
  getOne,
  save,
  update,
  delete
) where

import Database.HDBC
import DataAccess.Commands
import TableMappings.QueryHelpers
import Tipos.Stock
import Data.Time.Calendar
import Tipos.PageResult

toType :: [SqlValue] -> Stock
toType row =
  Stock { idStock = fromSql (row!!0)::Int,
    idProducto = fromSql (row!!1)::Int,
    idProveedor = fromSql (row!!2)::Int,
    cantidad = fromSql (row!!3)::Double,
    precio = fromSql (row!!4)::Double,
    fecha = fromSql (row!!5)::Day,
    movimiento = fromSql (row!!6)::Int,
    activo = fromSql (row!!7)::Bool }

fromType :: Stock -> [SqlValue]
fromType s =
  [toSql $ idProducto s,
  toSql $ idProveedor s,
  toSql $ cantidad s,
  toSql $ precio s,
  toSql $ fecha s,
  toSql $ movimiento s,
  toSql $ activo s,
  toSql $ idStock s]

selCmd :: Int -> Int -> Command
selCmd offset pageSize =
  Command "SELECT *, count(*) OVER() as TOTAL_ROWS FROM public.\"Stocks\" where activo = ? ORDER BY id OFFSET ? FETCH NEXT ? ROWS ONLY" [toSql True, toSql offset, toSql pageSize]

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM public.\"Stocks\" where id = ?" [toSql key]

savCmd :: Stock -> Command
savCmd s =
  Command "INSERT INTO public.\"Stocks\" (productoId, proveedorId, cantidad, precio, fecha, movimiento, activo) values (?,?,?,?,?,?,?)" (init $ fromType s)

updateCmd :: Stock -> Command
updateCmd p =
  Command "UPDATE public.\"Stocks\" SET productoId=?, proveedorId=?, cantidad=?, precio=?, fecha=?, movimiento=?, activo=? where id=?" (fromType p)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE public.\"Stocks\" SET activo=? where id=?" [toSql False, toSql key]

getAll :: Int -> Int -> IO (PageResult Stock)
getAll offset pageSize = do
  rows <- execSelQuery (selCmd offset pageSize)
  return (PageResult (map toType rows) (getFstIntOrZero rows 8))

getStock :: [[SqlValue]] -> Maybe Stock
getStock rows =
  case rows of [x] -> Just (toType x)
               _  -> Nothing

getOne :: Int -> IO (Maybe Stock)
getOne key = getStock <$> execSelQuery (selOneCmd key)

save :: (Maybe Stock) -> IO Integer
save Nothing  = return 0
save (Just p) = execNonSelQuery (savCmd p)

update :: (Maybe Stock) -> IO Integer
update Nothing  = return 0
update (Just p) = execNonSelQuery (updateCmd p)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
