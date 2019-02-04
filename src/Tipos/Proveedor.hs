{-# LANGUAGE DeriveGeneric #-}
module Tipos.Proveedor
(Proveedor(..)) where

import Data.Aeson
import GHC.Generics

data Proveedor = Proveedor { idProveedor :: Int
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
