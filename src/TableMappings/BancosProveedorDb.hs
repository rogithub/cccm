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
import TableMappings.BaseDb as BaseDb
import TableMappings.CuentasDb as CuentasDb

selCmd :: Int -> Command
selCmd proveedorId =
  Command "SELECT c.* FROM cuentas c JOIN proveedorescuentas p \
  \ ON c.Id = p.cuentaId \
  \ where efectivo = false and \
  \ activo = ? and p.proveedorId = ?;" [toSql True, toSql proveedorId]

getAll :: Int -> IO [Banco]
getAll proveedorId = do
  let cmd = selCmd proveedorId
  BaseDb.rowsToType cmd toType  

getOne :: Int -> IO (Maybe Banco)
getOne = CuentasDb.getOneBanco

save :: (Maybe Banco) -> IO Integer
save = CuentasDb.saveBanco

update :: (Maybe Banco) -> IO Integer
update = CuentasDb.updateBanco
