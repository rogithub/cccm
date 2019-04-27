module TableMappings.ComprasMaterialesDb
(
  getOne,
  save,
  update,
  delete,
  
  toType,
  fromType,
  selOneCmd,
  savCmd,
  updateCmd,
  deleteCmd
) where

import Database.HDBC
import DataAccess.Commands
import TableMappings.Types.CompraMaterial
import TableMappings.Types.PageResult
import TableMappings.BaseDb as BaseDb
import Data.UUID

toType :: [SqlValue] -> CompraMaterial 
toType row =
  CompraMaterial { idCompraMaterial = fromSql (row!!0) :: Int,
                   guidCompraMaterial = read (fromSql (row!!1) :: String),
                   compraId = read (fromSql (row!!2) :: String),
                   materialId = read (fromSql (row!!3) :: String),
                   cantidad = fromSql (row!!4) :: Double,
                   precio = fromSql (row!!5) :: Double }

fromType :: CompraMaterial -> [SqlValue]
fromType m =
  [ toSql $ toString (compraId m),
    toSql $ toString (materialId m),
    toSql $ cantidad m,
    toSql $ precio m,
    toSql $ toString (guidCompraMaterial m),
    toSql $ idCompraMaterial m ]


selOneCmd :: Int -> Command
selOneCmd key =
  Command "SELECT * FROM comprasmateriales where id = ?" [toSql key]

savCmd :: CompraMaterial -> Command
savCmd c =
  Command "INSERT INTO comprasmateriales (compraid, materialid, cantidad, precio, guid) values (?,?,?,?,?)" (init $ fromType c)

updateCmd :: CompraMaterial -> Command
updateCmd c =
  Command "UPDATE comprasmateriales SET compraid=?, materialid=?, cantidad=?, precio=? where guid=? and id=?" (fromType c)

deleteCmd :: Int -> Command
deleteCmd key =
  Command "DELETE from comprasmateriales where id=?" [toSql False, toSql key]

getOne :: Int -> IO (Maybe CompraMaterial)
getOne key = do
  let cmd = selOneCmd key
  BaseDb.rowToType cmd toType

save :: (Maybe CompraMaterial) -> IO Integer
save Nothing = return 0
save (Just c) = execNonSelQuery (savCmd c)

update :: (Maybe CompraMaterial) -> IO Integer
update Nothing = return 0
update (Just c) = execNonSelQuery (updateCmd c)

delete :: Int -> IO Integer
delete key = execNonSelQuery (deleteCmd key)
