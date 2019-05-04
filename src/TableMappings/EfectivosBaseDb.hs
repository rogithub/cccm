module TableMappings.EfectivosBaseDb
(
  getOne,
  save,
  update,
  delete,

  selOneSql,
  savSql,
  updSql,
  delSql,
  
  selOneCmd,
  savCmd,
  updCmd,
  delCmd
  
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

selOneSql :: SqlString
selOneSql = "SELECT * FROM cuentas where id = ?"

selOneCmd :: Int -> Command
selOneCmd key =
  Command selOneSql [toSql key]

savSql :: SqlString
savSql = "INSERT INTO cuentas \
  \ (banco, clabe, nocuenta, nombre, beneficiario, emailnotificacion, efectivo, activo, guid) \
  \ values ('','','',?,?,?,true,?,?)"
  
savCmd :: Efectivo -> Command
savCmd b =
  Command savSql (init $ fromType b)

updSql :: SqlString
updSql = "UPDATE cuentas SET \
  \ nombre=?, beneficiario=?, emailnotificacion=?, activo=? \
  \ where guid=? and id=?"
  
updCmd :: Efectivo -> Command
updCmd b =
  Command updSql (fromType b)

delSql :: SqlString
delSql = "UPDATE cuentas SET activo=? where id=?"

delCmd :: Int -> Command
delCmd key =
  Command delSql [toSql False, toSql key]

getOne :: Int -> IO (Maybe Efectivo)
getOne = selectOne . selOneCmd

save :: (Maybe Efectivo) -> IO Integer
save = persist savCmd

update :: (Maybe Efectivo) -> IO Integer
update = persist updCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . delCmd
