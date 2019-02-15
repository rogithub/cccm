module TableMappings.BancosProveedorDb
(
  getAll,
  getOne,
  save,
  update,
  delete
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Cuenta
import Tipos.PageResult
import DataAccess.ValueHelpers

toType :: [SqlValue] -> Cuenta
toType row =
  Banco { idCuenta = fromSql (row!!0)::Int,
    banco = fromSql (row!!1)::String,
    clabe = fromSql (row!!2)::Maybe String,
    nocuenta = fromSql (row!!3)::Maybe String,
    beneficiario = fromSql (row!!4)::String,
    emailNotificacion = fromSql (row!!5)::Maybe String,
    activo = fromSql (row!!7)::Bool }

fromType :: Cuenta -> [SqlValue]
fromType p =
  [toSql $ banco p,
  toSql $ clabe p,
  toSql $ nocuenta p,
  toSql $ beneficiario p,
  toSql $ emailNotificacion p,
  toSql $ activo p,
  toSql $ idCuenta p]

selCmd :: Int -> Command
selCmd proveedorId =
  Command "SELECT *, count(*) OVER() as TOTAL_ROWS FROM materiales \
  \ WHERE activo=? AND \
  \ concat_ws(' ', nombre, color, unidad, marca, modelo) ~* ? \
  \ ORDER BY nombre OFFSET ? FETCH NEXT ? ROWS ONLY"
  [toSql True, toSql proveedorId]

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM materiales where id = ?" [toSql key]

savCmd :: Cuenta -> Command
savCmd p =
  Command "INSERT INTO materiales \
  \ (nombre, color, unidad, marca, modelo, comentarios, activo)\
  \ values (?,?,?,?,?,?,?)" (init $ fromType p)

updateCmd :: Cuenta -> Command
updateCmd p =
  Command "UPDATE materiales SET \
  \ nombre=?, color=?, unidad=?, marca=?, modelo=?, comentarios=?, activo=?\
  \ where id=?" (fromType p)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE materiales SET activo=? where id=?" [toSql False, toSql key]

getAll :: Int -> IO (PageResult Cuenta)
getAll proveedorId = do
  rows <- execSelQuery (selCmd proveedorId)
  return (PageResult (map toType rows) (getFstIntOrZero rows 8))

getCuenta :: [[SqlValue]] -> Maybe Cuenta
getCuenta rows =
  case rows of [x] -> Just (toType x)
               _  -> Nothing

getOne :: Int -> IO (Maybe Cuenta)
getOne key = getCuenta <$> execSelQuery (selOneCmd key)

save :: (Maybe Cuenta) -> IO Integer
save Nothing  = return 0
save (Just p) = execNonSelQuery (savCmd p)

update :: (Maybe Cuenta) -> IO Integer
update Nothing  = return 0
update (Just p) = execNonSelQuery (updateCmd p)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
