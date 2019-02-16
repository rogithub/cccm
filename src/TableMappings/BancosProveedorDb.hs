module TableMappings.BancosProveedorDb
(
  TableMappings.BancosProveedorDb.getAll,
  BancosBaseDb.getOne,
  BancosBaseDb.save,
  BancosBaseDb.update,
  BancosBaseDb.delete
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Banco
import Tipos.PageResult
import TableMappings.BaseDb as BaseDb
import TableMappings.BancosBaseDb as BancosBaseDb

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
