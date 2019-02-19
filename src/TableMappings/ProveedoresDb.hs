module TableMappings.ProveedoresDb
(
  getAll,
  getOne,
  save,
  update,
  delete,
  getByName
) where

import Database.HDBC
import DataAccess.Commands
import TableMappings.Types.Proveedor
import TableMappings.Types.PageResult
import TableMappings.BaseDb as BaseDb

toType :: [SqlValue] -> Proveedor
toType row =
  Proveedor { idProveedor = fromSql (row!!0)::Int,
    empresa = fromSql (row!!1)::String,
    contacto = fromSql (row!!2)::String,
    domicilio = fromSql (row!!3)::Maybe String,
    telefono = fromSql (row!!4)::String,
    email = fromSql (row!!5)::String,
    comentarios = fromSql (row!!6)::Maybe String,
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

getByNameCmd :: String -> Command
getByNameCmd name =
  Command "SELECT * FROM proveedores where empresa like ? and activo = ?  ORDER BY empresa" [toSql name, toSql True]

selCmd :: Int -> Int -> String -> Command
selCmd offset pageSize name =
  Command "SELECT *, count(*) OVER() as TOTAL_ROWS FROM proveedores WHERE activo = ? and empresa ~* ? ORDER BY empresa OFFSET ? FETCH NEXT ? ROWS ONLY" [toSql True, toSql name, toSql offset, toSql pageSize]

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM proveedores where id = ?" [toSql key]

savCmd :: Proveedor -> Command
savCmd p =
  Command "INSERT INTO proveedores (empresa, contacto, domicilio, telefono, email, comentarios, activo) values (?,?,?,?,?,?,?)" (init $ fromType p)

updateCmd :: Proveedor -> Command
updateCmd p =
  Command "UPDATE proveedores SET empresa=?, contacto=?, domicilio=?, telefono=?, email=?, comentarios=?, activo=? where id=?" (fromType p)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE proveedores SET activo=? where id=?" [toSql False, toSql key]

getByName :: String -> IO [Proveedor]
getByName name = do
  let cmd = getByNameCmd name
  BaseDb.rowsToType cmd toType

getAll :: Int -> Int -> String -> IO (PageResult Proveedor)
getAll offset pageSize name = do
  let cmd = selCmd offset pageSize name
  BaseDb.getPageResult cmd toType

getOne :: Int -> IO (Maybe Proveedor)
getOne key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd toType

save :: (Maybe Proveedor) -> IO Integer
save Nothing  = return 0
save (Just p) = execNonSelQuery (savCmd p)

update :: (Maybe Proveedor) -> IO Integer
update Nothing  = return 0
update (Just p) = execNonSelQuery (updateCmd p)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
