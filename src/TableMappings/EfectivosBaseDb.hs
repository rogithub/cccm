module TableMappings.EfectivosBaseDb
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
import TableMappings.Types.Efectivo
import TableMappings.Types.PageResult
import TableMappings.Types.DbRowClass
import TableMappings.BaseDb as BaseDb
import Data.UUID

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
getOne key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd toType

save :: (Maybe Efectivo) -> IO Integer
save Nothing  = return 0
save (Just b) = execNonSelQuery (savCmd b)

update :: (Maybe Efectivo) -> IO Integer
update Nothing  = return 0
update (Just b) = execNonSelQuery (updateCmd b)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
