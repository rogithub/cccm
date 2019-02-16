module TableMappings.CuentasDb
(
  getOneBanco,
  saveBanco,
  updateBanco,
  delete,
  bancoToType,
  bancoFromType
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Banco
import Tipos.PageResult
import TableMappings.BaseDb as BaseDb

bancoToType :: [SqlValue] -> Banco
bancoToType row =
  Banco { idCuenta = fromSql (row!!0)::Int,
    banco = fromSql (row!!1)::String,
    clabe = fromSql (row!!2)::Maybe String,
    nocuenta = fromSql (row!!3)::Maybe String,
    beneficiario = fromSql (row!!4)::String,
    emailNotificacion = fromSql (row!!5)::Maybe String,
    activo = fromSql (row!!8)::Bool }

bancoFromType :: Banco -> [SqlValue]
bancoFromType p =
  [toSql $ banco p,
  toSql $ clabe p,
  toSql $ nocuenta p,
  toSql $ beneficiario p,
  toSql $ emailNotificacion p,
  toSql $ activo p,
  toSql $ idCuenta p]


selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM cuentas where id = ?" [toSql key]

savBancoCmd :: Banco -> Command
savBancoCmd b =
  Command "INSERT INTO cuentas \
  \ (banco, clabe, nocuenta, beneficiario, emailnotificacion, nombre, efectivo, activo) \
  \ values (?,?,?,?,?,'',false,?)" (init $ bancoFromType b)

updateBancoCmd :: Banco -> Command
updateBancoCmd b =
  Command "UPDATE cuentas SET \
  \ banco=?, clabe=?, nocuenta=?, beneficiario=?, emailnotificacion=?, activo=? \
  \ where id=?" (bancoFromType b)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE cuentas SET activo=? where id=?" [toSql False, toSql key]

getOneBanco :: Int -> IO (Maybe Banco)
getOneBanco key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd bancoToType

saveBanco :: (Maybe Banco) -> IO Integer
saveBanco Nothing  = return 0
saveBanco (Just b) = execNonSelQuery (savBancoCmd b)

updateBanco :: (Maybe Banco) -> IO Integer
updateBanco Nothing  = return 0
updateBanco (Just b) = execNonSelQuery (updateBancoCmd b)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
