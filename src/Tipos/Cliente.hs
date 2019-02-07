{-# LANGUAGE DeriveGeneric #-}
module Tipos.Cliente
( Cliente(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar

data Cliente = Cliente { idCliente :: Int
               , facturacionId :: Maybe Int
               , contacto :: String
               , empresa :: String
               , telefono :: Maybe String
               , email :: Maybe String
               , domicilio :: Maybe String
               , fechaCreado :: Day
               , activo :: Bool
               } deriving (Generic, Show)
instance ToJSON Cliente where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Cliente
