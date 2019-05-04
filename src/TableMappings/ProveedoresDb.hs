module TableMappings.ProveedoresDb
(
  getAll,
  getOne,
  save,
  update,
  delete,
  getByName,

  selOneCmd,
  savCmd,
  updateCmd,
  deleteCmd
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.PageResult
import DataAccess.Entities
import TableMappings.Types.Proveedor
import Data.UUID

instance ToType Proveedor where
  toType r =
    Proveedor { idProveedor = fromSql (r!!0)::Int,
                guidProveedor = read (fromSql (r!!1)::String),
                empresa = fromSql (r!!2)::String,
                contacto = fromSql (r!!3)::String,
                domicilio = fromSql (r!!4)::Maybe String,
                telefono = fromSql (r!!5)::String,
                email = fromSql (r!!6)::String,
                comentarios = fromSql (r!!7)::Maybe String,
                activo = fromSql (r!!8)::Bool }

instance FromType Proveedor where
  fromType p =
    [toSql $ empresa p,
     toSql $ contacto p,
     toSql $ domicilio p,
     toSql $ telefono p,
     toSql $ email  p,
     toSql $ comentarios p,
     toSql $ activo p,
     toSql $ toString (guidProveedor p),
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
  Command "INSERT INTO proveedores (empresa, contacto, domicilio, telefono, email, comentarios, activo, guid) values (?,?,?,?,?,?,?,?)" (init $ fromType p)

updateCmd :: Proveedor -> Command
updateCmd p =
  Command "UPDATE proveedores SET empresa=?, contacto=?, domicilio=?, telefono=?, email=?, comentarios=?, activo=? where guid=? and id=?" (fromType p)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE proveedores SET activo=? where id=?" [toSql False, toSql key]

getByName :: String -> IO [Proveedor]
getByName = selectMany . getByNameCmd

getAll :: Int -> Int -> String -> IO (PageResult Proveedor)
getAll offset pageSize name = getPages $ selCmd offset pageSize name

getOne :: Int -> IO (Maybe Proveedor)
getOne = selectOne . selOneCmd

save :: (Maybe Proveedor) -> IO Integer
save = persist savCmd

update :: (Maybe Proveedor) -> IO Integer
update = persist updateCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . deleteCmd
