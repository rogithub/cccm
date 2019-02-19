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
import TableMappings.BaseDb as BaseDb

toType :: [SqlValue] -> Efectivo
toType row =
  Efectivo { idCuenta = fromSql (row!!0)::Int,
    nombre = fromSql (row!!6)::String,
    beneficiario = fromSql (row!!4)::String,
    emailNotificacion = fromSql (row!!5)::Maybe String,
    activo = fromSql (row!!8)::Bool }

fromType :: Efectivo -> [SqlValue]
fromType e =
  [toSql $ nombre e,
  toSql $ beneficiario e,
  toSql $ emailNotificacion e,
  toSql $ activo e,
  toSql $ idCuenta e]


selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM cuentas where id = ?" [toSql key]

savCmd :: Efectivo -> Command
savCmd b =
  Command "INSERT INTO cuentas \
  \ (banco, clabe, nocuenta, nombre, beneficiario, emailnotificacion, efectivo, activo) \
  \ values ('','','',?,?,?,true,?)" (init $ fromType b)

updateCmd :: Efectivo -> Command
updateCmd b =
  Command "UPDATE cuentas SET \
  \ nombre=?, beneficiario=?, emailnotificacion=?, activo=? \
  \ where id=?" (fromType b)

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
