module TableMappings.BancosClienteDb
(
  TableMappings.BancosClienteDb.getAll,
  BancosBaseDb.getOne,
  BancosBaseDb.save,
  BancosBaseDb.update,
  BancosBaseDb.delete
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.PageResult
import DataAccess.Entities
import TableMappings.Types.Banco
import TableMappings.BancosBaseDb as BancosBaseDb

selCmd :: Int -> Command
selCmd clienteId =
  Command "SELECT c.* FROM cuentas c JOIN clientescuentas cc \
  \ ON c.Id = cc.cuentaId \
  \ where efectivo = false and \
  \ activo = ? and cc.clienteId = ?;" [toSql True, toSql clienteId]

getAll :: Int -> IO [Banco]
getAll clienteId = do
  let cmd = selCmd clienteId
  selectMany cmd
