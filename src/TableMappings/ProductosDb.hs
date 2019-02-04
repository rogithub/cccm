module TableMappings.ProductosDb
(
  getAll,
  getOne,
  save,
  update,
  delete
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Producto
import Tipos.PageResult
import DataAccess.ValueHelpers

toType :: [SqlValue] -> Producto
toType row =
  Producto { idProducto = fromSql (row!!0)::Int,
    nombre = fromSql (row!!1)::String,
    color = fromSql (row!!2)::String,
    unidad = fromSql (row!!3)::String,
    marca = fromSql (row!!4)::Maybe String,
    modelo = fromSql (row!!5)::Maybe String,
    comentarios = fromSql (row!!6)::Maybe String,
    activo = fromSql (row!!7)::Bool }

fromType :: Producto -> [SqlValue]
fromType p =
  [toSql $ nombre p,
  toSql $ color p,
  toSql $ unidad p,
  toSql $ marca p,
  toSql $ modelo p,
  toSql $ comentarios p,
  toSql $ activo p,
  toSql $ idProducto p]

selCmd :: Int -> Int -> Command
selCmd offset pageSize =
  Command "SELECT *, count(*) OVER() as TOTAL_ROWS FROM public.\"Productos\" WHERE activo=? ORDER BY ID OFFSET ? FETCH NEXT ? ROWS ONLY" [toSql True, toSql offset, toSql pageSize]

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM public.\"Productos\" where id = ?" [toSql key]

savCmd :: Producto -> Command
savCmd p =
  Command "INSERT INTO public.\"Productos\" (nombre, color, unidad, marca, modelo, comentarios, activo) values (?,?,?,?,?,?,?)" (init $ fromType p)

updateCmd :: Producto -> Command
updateCmd p =
  Command "UPDATE public.\"Productos\" SET nombre=?, color=?, unidad=?, marca=?, modelo=?, comentarios=?, activo=? where id=?" (fromType p)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE public.\"Productos\" SET activo=? where id=?" [toSql False, toSql key]

getAll :: Int -> Int -> IO (PageResult Producto)
getAll offset pageSize = do
  rows <- execSelQuery (selCmd offset pageSize)
  return (PageResult (map toType rows) (getFstIntOrZero rows 8))

getProducto :: [[SqlValue]] -> Maybe Producto
getProducto rows =
  case rows of [x] -> Just (toType x)
               _  -> Nothing

getOne :: Int -> IO (Maybe Producto)
getOne key = getProducto <$> execSelQuery (selOneCmd key)

save :: (Maybe Producto) -> IO Integer
save Nothing  = return 0
save (Just p) = execNonSelQuery (savCmd p)

update :: (Maybe Producto) -> IO Integer
update Nothing  = return 0
update (Just p) = execNonSelQuery (updateCmd p)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
