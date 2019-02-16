module TableMappings.MaterialesDb
(
  getAll,
  getOne,
  save,
  update,
  delete,
  getByName
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Material
import Tipos.PageResult
import TableMappings.BaseDb as BaseDb

toType :: [SqlValue] -> Material
toType row =
  Material { idMaterial = fromSql (row!!0)::Int,
    nombre = fromSql (row!!1)::String,
    color = fromSql (row!!2)::String,
    unidad = fromSql (row!!3)::String,
    marca = fromSql (row!!4)::Maybe String,
    modelo = fromSql (row!!5)::Maybe String,
    comentarios = fromSql (row!!6)::Maybe String,
    activo = fromSql (row!!7)::Bool }

fromType :: Material -> [SqlValue]
fromType p =
  [toSql $ nombre p,
  toSql $ color p,
  toSql $ unidad p,
  toSql $ marca p,
  toSql $ modelo p,
  toSql $ comentarios p,
  toSql $ activo p,
  toSql $ idMaterial p]

getByNameCmd :: String -> Command
getByNameCmd name =
  Command "SELECT * FROM materiales where nombre like ? and activo = ? \
  \ORDER BY nombre" [toSql name, toSql True]

selCmd :: Int -> Int -> String -> Command
selCmd offset pageSize name =
  Command "SELECT *, count(*) OVER() as TOTAL_ROWS FROM materiales \
  \ WHERE activo=? AND \
  \ concat_ws(' ', nombre, color, unidad, marca, modelo) ~* ? \
  \ ORDER BY nombre OFFSET ? FETCH NEXT ? ROWS ONLY"
  [toSql True, toSql name, toSql offset, toSql pageSize]

selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM materiales where id = ?" [toSql key]

savCmd :: Material -> Command
savCmd p =
  Command "INSERT INTO materiales \
  \ (nombre, color, unidad, marca, modelo, comentarios, activo)\
  \ values (?,?,?,?,?,?,?)" (init $ fromType p)

updateCmd :: Material -> Command
updateCmd p =
  Command "UPDATE materiales SET \
  \ nombre=?, color=?, unidad=?, marca=?, modelo=?, comentarios=?, activo=?\
  \ where id=?" (fromType p)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "UPDATE materiales SET activo=? where id=?" [toSql False, toSql key]

getByName :: String -> IO [Material]
getByName name = do
  let cmd = getByNameCmd name
  BaseDb.rowsToType cmd toType

getAll :: Int -> Int -> String -> IO (PageResult Material)
getAll offset pageSize name = do
  let cmd = selCmd offset pageSize name
  BaseDb.getPageResult cmd toType

getOne :: Int -> IO (Maybe Material)
getOne key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd toType

save :: (Maybe Material) -> IO Integer
save Nothing  = return 0
save (Just p) = execNonSelQuery (savCmd p)

update :: (Maybe Material) -> IO Integer
update Nothing  = return 0
update (Just p) = execNonSelQuery (updateCmd p)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
