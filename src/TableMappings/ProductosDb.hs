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

toType :: [SqlValue] -> Producto
toType sqlVal =
  Producto { idProducto = fromSql (sqlVal!!0)::Int,
    nombre = fromSql (sqlVal!!1)::String,
    color = fromSql (sqlVal!!2)::String,
    unidad = fromSql (sqlVal!!3)::String,
    marca = fromSql (sqlVal!!4)::String,
    modelo = fromSql (sqlVal!!5)::String,
    comentarios = fromSql (sqlVal!!6)::String,
    activo = fromSql (sqlVal!!7)::Bool }

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

selCmd :: Command
selCmd =
  Command "SELECT * FROM public.\"Productos\" where activo = ? ORDER BY id" [toSql True]

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

getAll :: IO [Producto]
getAll = map toType <$> execSelQuery selCmd

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