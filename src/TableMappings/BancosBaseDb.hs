module TableMappings.BancosBaseDb
(
  getOne,
  save,
  update,
  delete,
  toType,
  fromType
) where

import Database.HDBC
import DataAccess.Commands
import TableMappings.Types.Banco
import TableMappings.Types.PageResult
import TableMappings.Types.DbRow
import TableMappings.BaseDb as BaseDb
import Data.UUID


selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM cuentas where id = ?" [toSql key]

savCmd :: Banco -> Command
savCmd b =
  Command "INSERT INTO cuentas \
  \ (banco, clabe, nocuenta, beneficiario, emailnotificacion, nombre, efectivo, activo, guid) \
  \ values (?,?,?,?,?,'',false,?,?)" (init $ fromType b)

updateCmd :: Banco -> Command
updateCmd b =
  Command "UPDATE cuentas SET \
  \ banco=?, clabe=?, nocuenta=?, beneficiario=?, emailnotificacion=?, activo=? \
  \ where guid=? and id=?" (fromType b)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE cuentas SET activo=? where id=?" [toSql False, toSql key]

getOne :: Int -> IO (Maybe Banco)
getOne key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd toType

save :: (Maybe Banco) -> IO Integer
save Nothing  = return 0
save (Just b) = execNonSelQuery (savCmd b)

update :: (Maybe Banco) -> IO Integer
update Nothing  = return 0
update (Just b) = execNonSelQuery (updateCmd b)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
