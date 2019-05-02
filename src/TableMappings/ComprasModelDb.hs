module TableMappings.ComprasModelDb
(
  save
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.PageResult
import DataAccess.Entities
import TableMappings.Models.CompraModel
import Data.UUID
import Data.Time.Calendar


save :: (Maybe CompraModel) -> IO Integer
save Nothing = return 0
save (Just cm) = return 1
