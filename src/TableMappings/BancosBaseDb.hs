module TableMappings.BancosBaseDb
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
import DataAccess.Entities
import TableMappings.Types.Banco
import DataAccess.PageResult
import Data.UUID

instance ToType Banco where
  toType row =
    Banco { idCuenta = fromSql (row!!0)::Int,
            guidCuenta = read (fromSql (row!!1)::String),
            banco = fromSql (row!!2)::String,
            clabe = fromSql (row!!3)::Maybe String,
            nocuenta = fromSql (row!!4)::Maybe String,
            beneficiario = fromSql (row!!5)::String,
            emailNotificacion = fromSql (row!!6)::Maybe String,
            activo = fromSql (row!!9)::Bool }

instance FromType Banco where
  fromType p =
    [toSql $ banco p,
     toSql $ clabe p,
     toSql $ nocuenta p,
     toSql $ beneficiario p,
     toSql $ emailNotificacion p,
     toSql $ activo p,
     toSql $ toString (guidCuenta p),
     toSql $ idCuenta p]

selOneSql :: SqlString
selOneSql = "SELECT * FROM cuentas where id = ?"

selOneCmd :: Int -> Command
selOneCmd key =
  Command selOneSql [toSql key]

savSql :: SqlString
savSql = "INSERT INTO cuentas \
  \ (banco, clabe, nocuenta, beneficiario, emailnotificacion, nombre, efectivo, activo, guid) \
  \ values (?,?,?,?,?,'',false,?,?)"
  
savCmd :: Banco -> Command
savCmd b =
  Command savSql (init $ fromType b)


updSql :: SqlString
updSql = "UPDATE cuentas SET \
  \ banco=?, clabe=?, nocuenta=?, beneficiario=?, emailnotificacion=?, activo=? \
  \ where guid=? and id=?"

updCmd :: Banco -> Command
updCmd b =
  Command updSql (fromType b)

delSql :: SqlString
delSql = "UPDATE cuentas SET activo=? where id=?"

delCmd :: Int -> Command
delCmd key =
  Command delSql [toSql False, toSql key]

getOne :: Int -> IO (Maybe Banco)
getOne = selectOne . selOneCmd

save :: (Maybe Banco) -> IO Integer
save = persist savCmd

update :: (Maybe Banco) -> IO Integer
update = persist updCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . delCmd
