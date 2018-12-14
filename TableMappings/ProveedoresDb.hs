module TableMappings.ProveedoresDb
(
  getAll,
  getOne,
  save,
  update
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Proveedor

toType :: [SqlValue] -> Proveedor
toType sqlVal =
  Proveedor { idProveedor = fromSql (sqlVal!!0)::Int,
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
  toSql $ activo p,
  toSql $ idProveedor p]

selCmd :: Command
selCmd =
  Command "SELECT * FROM public.\"Proveedores\" where activo = ? ORDER BY id" [toSql True]

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM public.\"Proveedores\" where id = ?" [toSql key]

savCmd :: Proveedor -> Command
savCmd p =
  Command "INSERT INTO public.\"Proveedores\" (empresa, contacto, domicilio, telefono, email, comentarios, activo) values (?,?,?,?,?,?,?)" (init $ fromType p)

updateCmd :: Proveedor -> Command
updateCmd p =
  Command "UPDATE public.\"Proveedores\" SET empresa=?, contacto=?, domicilio=?, telefono=?, email=?, comentarios=?, activo=? where id=?" (fromType p)

getAll :: IO [Proveedor]
getAll = map toType <$> execSelQuery selCmd

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
