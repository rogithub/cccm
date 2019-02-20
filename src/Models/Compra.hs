{-# LANGUAGE DeriveGeneric #-}
module Models.Compra
( Compra(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Models.CompraRow


data Compra = Compra { activo :: Bool
               , idCompra :: Int
               , proveedorId :: Int
               , fecha ::  DotNetTime
               , iva :: Double
               , rows :: [CompraRow]
               } deriving (Generic, Show)
instance ToJSON Compra where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Compra
