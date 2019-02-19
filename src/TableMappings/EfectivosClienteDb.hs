module TableMappings.EfectivosClienteDb
(
  TableMappings.EfectivosClienteDb.getAll,
  EfectivosBaseDb.getOne,
  EfectivosBaseDb.save,
  EfectivosBaseDb.update,
  EfectivosBaseDb.delete
) where

import Database.HDBC
import DataAccess.Commands
import TableMappings.Types.Efectivo
import TableMappings.Types.PageResult
import TableMappings.BaseDb as BaseDb
import TableMappings.EfectivosBaseDb as EfectivosBaseDb

selCmd :: Int -> Command
selCmd clienteId =
  Command "SELECT c.* FROM cuentas c JOIN clientescuentas cc \
  \ ON c.Id = cc.cuentaId \
  \ where efectivo = true and \
  \ activo = ? and cc.clienteId = ?;" [toSql True, toSql clienteId]

getAll :: Int -> IO [Efectivo]
getAll clienteId = do
  let cmd = selCmd clienteId
  BaseDb.rowsToType cmd toType
