module TableMappings.ProveedoresDb
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
import Tipos.Proveedor
import Tipos.PageResult

toType :: [SqlValue] -> Proveedor
toType row =
  Proveedor { idProveedor = fromSql (row!!0)::Int,
    empresa = fromSql (row!!1)::String,
    contacto = fromSql (row!!2)::String,
    domicilio = fromSql (row!!3)::String,
    telefono = fromSql (row!!4)::String,
    email = fromSql (row!!5)::String,
    comentarios = fromSql (row!!6)::String,
    activo = fromSql (row!!7)::Bool }

fromType :: Proveedor -> [SqlValue]
fromType p =
  [toSql $ empresa p,
  toSql $ contacto p,
  toSql $ domicilio p,
  toSql $ telefono p,
  toSql $ email  p,
  toSql $ comentarios p,
  toSql $ activo p,
  toSql $ idProveedor p]

selCmd :: Int -> Int -> Command
selCmd offset pageSize =
  Command "SELECT *, count(*) OVER() as TOTAL_ROWS FROM public.\"Proveedores\" where activo = ? ORDER BY id OFFSET ? FETCH NEXT ? ROWS ONLY" [toSql True, toSql offset, toSql pageSize]

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM public.\"Proveedores\" where id = ?" [toSql key]

savCmd :: Proveedor -> Command
savCmd p =
  Command "INSERT INTO public.\"Proveedores\" (empresa, contacto, domicilio, telefono, email, comentarios, activo) values (?,?,?,?,?,?,?)" (init $ fromType p)

updateCmd :: Proveedor -> Command
updateCmd p =
  Command "UPDATE public.\"Proveedores\" SET empresa=?, contacto=?, domicilio=?, telefono=?, email=?, comentarios=?, activo=? where id=?" (fromType p)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE public.\"Proveedores\" SET activo=? where id=?" [toSql False, toSql key]

getAll :: Int -> Int -> IO (PageResult Proveedor)
getAll offset pageSize = do
  rows <- execSelQuery (selCmd offset pageSize)
  return (PageResult (map toType rows) (getFstIntOrZero rows 8))

getProveedor :: [[SqlValue]] -> Maybe Proveedor
getProveedor rows =
  case rows of [x] -> Just (toType x)
               _  -> Nothing

getOne :: Int -> IO (Maybe Proveedor)
getOne key = getProveedor <$> execSelQuery (selOneCmd key)

save :: (Maybe Proveedor) -> IO Integer
save Nothing  = return 0
save (Just p) = execNonSelQuery (savCmd p)

update :: (Maybe Proveedor) -> IO Integer
update Nothing  = return 0
update (Just p) = execNonSelQuery (updateCmd p)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
