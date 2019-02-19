{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Compra
( Compra(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import TableMappings.Types.CompraRow

data Compra = Compra { idCompra :: Int
               , proveedorId :: Int
               , fecha :: Day
               , docIdFacturaPdf :: Maybe Int
               , docIdFacturaXml :: Maybe Int
               , iva :: Double
               , activo :: Bool
               } deriving (Generic, Show)
instance ToJSON Compra where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Compra
