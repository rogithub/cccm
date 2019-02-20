{-# LANGUAGE DeriveGeneric #-}
module Models.Compra
( Compra(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Models.CompraMaterial
import Models.CompraServicio

data Compra = Compra { activo :: Bool
               , idCompra :: Int
               , proveedorId :: Int
               , fecha :: DotNetTime
               , iva :: Double
               , materialesNuevo :: [CompraMaterial]
               , materialesExistente :: [CompraMaterial]
               , servicios  :: [CompraServicio]
               } deriving (Generic, Show)
instance ToJSON Compra where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Compra
