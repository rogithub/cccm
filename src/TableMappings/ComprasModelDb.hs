module TableMappings.ComprasModelDb
(
  TableMappings.ComprasModelDb.save
) where

import Database.HDBC
import DataAccess.Commands
import DataAccess.PageResult
import DataAccess.Entities
import TableMappings.Models.CompraModel
import TableMappings.Models.CompraMaterialModel

import Data.UUID
import Data.Time.Calendar

import TableMappings.ComprasDb as Dbc
import TableMappings.MaterialesDb as Dbm
import TableMappings.ComprasMaterialesDb as Dbcm
import TableMappings.ComprasServiciosDb as Dbcs


savCmd :: CompraModel -> Command
savCmd m =
  Dbc.savCmd (compra m) `mappend`
  (mconcat $ map (\x ->  Dbm.savCmd (material x)) (materialesNuevo m)) `mappend`
  (mconcat $ map (\x -> Dbcm.savCmd (compraMaterial x)) (materialesNuevo m)) `mappend`
  (mconcat $ map (\x -> Dbcm.savCmd x) (materialesExistente m)) `mappend`
  (mconcat $ map (\x -> Dbcs.savCmd x) (servicios m))


save :: (Maybe CompraModel) -> IO Integer
save = persist TableMappings.ComprasModelDb.savCmd
