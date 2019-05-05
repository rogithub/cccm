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

sCompra :: CompraModel -> IO ()
sCompra m = do
  Dbc.save (Just (compra m)) >> return ()

sMaterial :: CompraModel -> IO ()
sMaterial m = do
  savMany Dbm.savSql (map (\x -> material x) (materialesNuevo m))

sCmaterial :: CompraModel -> IO ()
sCmaterial m = do
  savMany Dbm.savSql (map (\x -> compraMaterial x) (materialesNuevo m))

sCmaterial2 :: CompraModel -> IO ()
sCmaterial2 m = do
  savMany Dbm.savSql (materialesExistente m)

sServicios :: CompraModel -> IO ()
sServicios m = do
  savMany Dbcs.savSql (servicios m)

save :: (Maybe CompraModel) -> IO ()
save Nothing = return ()
save (Just m) = sCompra m >> sMaterial m >> sCmaterial m >> sCmaterial2 m >> sServicios m
  


  
