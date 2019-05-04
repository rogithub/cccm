module TableMappings.MaterialesDb
(
  selByNameSql,
  selPagSql,
  selOneSql,
  updSql,
  savSql,
  delSql,
  
  getAll,
  getOne,
  save,
  update,
  delete,
  getByName,


  selByNameCmd,
  selPagCmd,
  selOneCmd,
  savCmd,
  updCmd,
  delCmd
  
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.Entities
import DataAccess.PageResult
import TableMappings.Types.Material
import Data.UUID

instance ToType Material where
  toType r =
    Material { idMaterial = fromSql (r!!0)::Int,
               guidMaterial = read (fromSql (r!!1)::String),
               nombre = fromSql (r!!2)::String,
               color = fromSql (r!!3)::String,
               unidad = fromSql (r!!4)::String,
               marca = fromSql (r!!5)::Maybe String,
               modelo = fromSql (r!!6)::Maybe String,
               comentarios = fromSql (r!!7)::Maybe String,
               activo = fromSql (r!!8)::Bool }



instance FromType Material where
  fromType t =
    [toSql $ nombre t,
     toSql $ color t,
     toSql $ unidad t,
     toSql $ marca t,
     toSql $ modelo t,
     toSql $ comentarios t,
     toSql $ activo t,
     toSql $ toString (guidMaterial t),
     toSql $ idMaterial t]


selByNameSql :: SqlString
selByNameSql = "SELECT * FROM materiales where nombre like ? and activo = ? \
  \ORDER BY nombre"

selByNameCmd :: String -> Command
selByNameCmd name = Command selByNameSql [toSql name, toSql True]

selPagSql :: SqlString
selPagSql = "SELECT *, count(*) OVER() as TOTAL_ROWS FROM materiales \
  \ WHERE activo=? AND \
  \ concat_ws(' ', nombre, color, unidad, marca, modelo) ~* ? \
  \ ORDER BY nombre OFFSET ? FETCH NEXT ? ROWS ONLY"
  
selPagCmd :: Int -> Int -> String -> Command
selPagCmd offset pageSize name =
  Command selPagSql [toSql True, toSql name, toSql offset, toSql pageSize]

selOneSql :: SqlString
selOneSql = "SELECT * FROM materiales where id = ?"

selOneCmd :: Int -> Command
selOneCmd key =
  Command selOneSql [toSql key]

savSql :: SqlString
savSql = "INSERT INTO materiales \
  \ (nombre, color, unidad, marca, modelo, comentarios, activo, guid)\
  \ values (?,?,?,?,?,?,?,?)"
  
savCmd :: Material -> Command
savCmd p =
  Command savSql (init $ fromType p)

updSql :: SqlString
updSql = "UPDATE materiales SET \
  \ nombre=?, color=?, unidad=?, marca=?, modelo=?, comentarios=?, activo=?\
  \ where guid=? and id=?"

updCmd :: Material -> Command
updCmd p =
  Command updSql (fromType p)

delSql :: SqlString
delSql = "UPDATE materiales SET activo=? where id=?"
  
delCmd :: Int -> Command
delCmd key =
  Command delSql [toSql False, toSql key]

getByName :: String -> IO [Material]
getByName = selectMany . selByNameCmd

getAll :: Int -> Int -> String -> IO (PageResult Material)
getAll offset pageSize name = getPages $ selPagCmd offset pageSize name

getOne :: Int -> IO (Maybe Material)
getOne = selectOne . selOneCmd

save :: (Maybe Material) -> IO Integer
save = persist savCmd 

update :: (Maybe Material) -> IO Integer
update = persist updCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . delCmd
