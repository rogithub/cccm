module TableMappings.ProveedoresDb
(
  getAll,
  getOne,
  save
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
  toSql $ activo p]

selCmd :: Command
selCmd =
  Command "SELECT * FROM public.\"Proveedores\"" []

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM public.\"Proveedores\" where id = ?" [toSql key]

savCmd :: Proveedor -> Command
savCmd p =
  Command "INSERT INTO public.\"Proveedores\" (empresa, contacto, domicilio, telefono, email, comentarios, activo) values (?,?,?,?,?,?,?)" (fromType p)

getAll :: IO [Proveedor]
getAll = map toType <$> execSelQuery selCmd

getProveedor :: [[SqlValue]] -> Maybe Proveedor
getProveedor rows =
  case rows of [x] -> Just (toType x)
               _  -> Nothing

getOne :: Int -> IO (Maybe Proveedor)
getOne key = getProveedor <$> execSelQuery (selOneCmd key)

save :: Proveedor -> IO Integer
save p =
  execNonSelQuery (savCmd p)
