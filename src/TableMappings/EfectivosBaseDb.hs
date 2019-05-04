module TableMappings.EfectivosBaseDb
(
  getOne,
  save,
  update,
  delete,

  selOneCmd,
  savCmd,
  updateCmd,
  deleteCmd
  
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.PageResult
import DataAccess.Entities
import TableMappings.Types.Efectivo
import Data.UUID

instance ToType Efectivo where
  toType row =
    Efectivo { idCuenta = fromSql (row!!0)::Int,
               guidCuenta = read (fromSql (row!!1)::String),
               nombre = fromSql (row!!7)::String,
               beneficiario = fromSql (row!!5)::String,
               emailNotificacion = fromSql (row!!6)::Maybe String,
               activo = fromSql (row!!9)::Bool }

instance FromType Efectivo where
  fromType e =
    [toSql $ nombre e,
     toSql $ beneficiario e,
     toSql $ emailNotificacion e,
     toSql $ activo e,
     toSql $ toString (guidCuenta e),
     toSql $ idCuenta e]
  
selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM cuentas where id = ?" [toSql key]

savCmd :: Efectivo -> Command
savCmd b =
  Command "INSERT INTO cuentas \
  \ (banco, clabe, nocuenta, nombre, beneficiario, emailnotificacion, efectivo, activo, guid) \
  \ values ('','','',?,?,?,true,?,?)" (init $ fromType b)

updateCmd :: Efectivo -> Command
updateCmd b =
  Command "UPDATE cuentas SET \
  \ nombre=?, beneficiario=?, emailnotificacion=?, activo=? \
  \ where guid=? and id=?" (fromType b)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE cuentas SET activo=? where id=?" [toSql False, toSql key]

getOne :: Int -> IO (Maybe Efectivo)
getOne = selectOne . selOneCmd

save :: (Maybe Efectivo) -> IO Integer
save = persist savCmd

update :: (Maybe Efectivo) -> IO Integer
update = persist updateCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . deleteCmd
