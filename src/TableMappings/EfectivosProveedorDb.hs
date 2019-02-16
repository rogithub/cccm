module TableMappings.EfectivosProveedorDb
(
  TableMappings.EfectivosProveedorDb.getAll,
  EfectivosBaseDb.getOne,
  EfectivosBaseDb.save,
  EfectivosBaseDb.update,
  EfectivosBaseDb.delete
) where

import Database.HDBC
import DataAccess.Commands
import Tipos.Efectivo
import Tipos.PageResult
import TableMappings.BaseDb as BaseDb
import TableMappings.EfectivosBaseDb as EfectivosBaseDb

selCmd :: Int -> Command
selCmd proveedorId =
  Command "SELECT c.* FROM cuentas c JOIN proveedorescuentas p \
  \ ON c.Id = p.cuentaId \
  \ where efectivo = true and \
  \ activo = ? and p.proveedorId = ?;" [toSql True, toSql proveedorId]

getAll :: Int -> IO [Efectivo]
getAll proveedorId = do
  let cmd = selCmd proveedorId
  BaseDb.rowsToType cmd toType
