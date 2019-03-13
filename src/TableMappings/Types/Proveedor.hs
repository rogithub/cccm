{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Proveedor
(Proveedor(..)) where

import Data.Aeson
import GHC.Generics
import Data.UUID

data Proveedor = Proveedor { idProveedor :: Int
              , guidProveedor :: UUID
              , empresa :: String
              , contacto :: String
              , domicilio :: Maybe String
              , telefono :: String
              , email :: String
              , comentarios :: Maybe String
              , activo :: Bool
              } deriving (Generic, Show)
instance ToJSON Proveedor where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON Proveedor
