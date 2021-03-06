{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Compra
( Compra(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Data.UUID

data Compra = Compra { idCompra :: Int
               , guidCompra :: UUID 
               , proveedorId :: UUID 
               , fecha :: DotNetTime
               , docIdFacturaPdf :: Maybe UUID
               , docIdFacturaXml :: Maybe UUID
               , iva :: Double
               , activo :: Bool
               } deriving (Generic, Show)
instance ToJSON Compra where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Compra
