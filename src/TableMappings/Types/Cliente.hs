{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Cliente
( Cliente(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Data.UUID

data Cliente = Cliente { idCliente :: Int
               , guidCliente :: UUID
               , facturacionId :: Maybe UUID
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
