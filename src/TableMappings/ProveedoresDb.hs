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
  updCmd,
  delCmd,
  selByNameCmd,
  selPagCmd,

  selByNameSql,
  selPagSql,
  selOneSql,
  updSql,
  savSql,
  delSql
  
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


selByNameSql :: SqlString
selByNameSql = "SELECT * FROM proveedores where empresa like ? and activo = ?  ORDER BY empresa"

selByNameCmd :: String -> Command
selByNameCmd name =
  Command selByNameSql [toSql name, toSql True]

selPagSql :: SqlString
selPagSql = "SELECT *, count(*) OVER() as TOTAL_ROWS FROM proveedores WHERE activo = ? and empresa ~* ? ORDER BY empresa OFFSET ? FETCH NEXT ? ROWS ONLY"

selPagCmd :: Int -> Int -> String -> Command
selPagCmd offset pageSize name =
  Command selPagSql [toSql True, toSql name, toSql offset, toSql pageSize]

selOneSql :: SqlString
selOneSql = "SELECT * FROM proveedores where id = ?"
  
selOneCmd :: Int -> Command
selOneCmd key =
  Command selOneSql [toSql key]

savSql :: SqlString
savSql = "INSERT INTO proveedores (empresa, contacto, domicilio, telefono, email, comentarios, activo, guid) values (?,?,?,?,?,?,?,?)"

savCmd :: Proveedor -> Command
savCmd p =
  Command savSql (init $ fromType p)

updSql :: SqlString
updSql = "UPDATE proveedores SET empresa=?, contacto=?, domicilio=?, telefono=?, email=?, comentarios=?, activo=? where guid=? and id=?"

updCmd :: Proveedor -> Command
updCmd p =
  Command updSql (fromType p)

delSql :: SqlString
delSql = "UPDATE proveedores SET activo=? where id=?"

delCmd :: Int -> Command
delCmd key =
  Command delSql [toSql False, toSql key]

getByName :: String -> IO [Proveedor]
getByName = selectMany . selByNameCmd

getAll :: Int -> Int -> String -> IO (PageResult Proveedor)
getAll offset pageSize name = getPages $ selPagCmd offset pageSize name

getOne :: Int -> IO (Maybe Proveedor)
getOne = selectOne . selOneCmd

save :: (Maybe Proveedor) -> IO Integer
save = persist savCmd

update :: (Maybe Proveedor) -> IO Integer
update = persist updCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . delCmd
