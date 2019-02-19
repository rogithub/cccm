{-# LANGUAGE DeriveGeneric #-}
module Models.Compra
( Compra(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Models.CompraRow

data Compra = Compra { idCompra :: Int
               , proveedorId :: Int
               , fecha :: Day
               , rows :: [CompraRow]
               , iva :: Double
               , activo :: Bool
               } deriving (Generic, Show)
instance ToJSON Compra where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Compra
