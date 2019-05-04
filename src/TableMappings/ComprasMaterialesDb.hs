module TableMappings.ComprasMaterialesDb
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
import TableMappings.Types.CompraMaterial
import Data.UUID

instance ToType CompraMaterial where 
  toType row =
    CompraMaterial { idCompraMaterial = fromSql (row!!0) :: Int,
                     guidCompraMaterial = read (fromSql (row!!1) :: String),
                     compraId = read (fromSql (row!!2) :: String),
                     materialId = read (fromSql (row!!3) :: String),
                     cantidad = fromSql (row!!4) :: Double,
                     precio = fromSql (row!!5) :: Double }

instance FromType CompraMaterial where
  fromType m =
    [ toSql $ toString (compraId m),
      toSql $ toString (materialId m),
      toSql $ cantidad m,
      toSql $ precio m,
      toSql $ toString (guidCompraMaterial m),
      toSql $ idCompraMaterial m ]

selOneSql :: SqlString
selOneSql = "SELECT * FROM comprasmateriales where id = ?"

selOneCmd :: Int -> Command
selOneCmd key =
  Command selOneSql [toSql key]

savSql :: SqlString
savSql = "INSERT INTO comprasmateriales (compraid, materialid, cantidad, precio, guid) values (?,?,?,?,?)"

savCmd :: CompraMaterial -> Command
savCmd c =
  Command savSql (init $ fromType c)

updSql :: SqlString
updSql = "UPDATE comprasmateriales SET compraid=?, materialid=?, cantidad=?, precio=? where guid=? and id=?"

updCmd :: CompraMaterial -> Command
updCmd c =
  Command updSql (fromType c)

delSql :: SqlString
delSql = "DELETE from comprasmateriales where id=?"

delCmd :: Int -> Command
delCmd key =
  Command delSql [toSql False, toSql key]

getOne :: Int -> IO (Maybe CompraMaterial)
getOne = selectOne . selOneCmd

save :: (Maybe CompraMaterial) -> IO Integer
save = persist savCmd 

update :: (Maybe CompraMaterial) -> IO Integer
update = persist updCmd

delete :: Int -> IO Integer
delete = execNonSelQuery . delCmd
