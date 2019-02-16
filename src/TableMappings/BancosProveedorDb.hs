module TableMappings.BancosProveedorDb
(
  getAll,
  getOne,
  save,
  update,
  Db.delete
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Banco
import Tipos.PageResult
import DataAccess.ValueHelpers
import TableMappings.CuentasDb as Db

selCmd :: Int -> Command
selCmd proveedorId =
  Command "SELECT c.* FROM cuentas c JOIN proveedorescuentas p \
  \ ON c.Id = p.cuentaId \
  \ where efectivo = false and \
  \ activo = ? and p.proveedorId = ?;" [toSql True, toSql proveedorId]

getAll :: Int -> IO (PageResult Banco)
getAll proveedorId = do
  rows <- execSelQuery (selCmd proveedorId)
  return (PageResult (map Db.bancoToType rows) (getFstIntOrZero rows 8))

getOne :: Int -> IO (Maybe Banco)
getOne = Db.getOneBanco

save :: (Maybe Banco) -> IO Integer
save = Db.saveBanco

update :: (Maybe Banco) -> IO Integer
update = Db.updateBanco
