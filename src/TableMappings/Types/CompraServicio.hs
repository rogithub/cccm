{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.CompraServicio
( CompraServicio(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Data.UUID
import Database.HDBC

data CompraServicio = CompraServicio { idCompraServicio :: Int
               , guidCompraServicio :: UUID
               , compraId :: UUID
               , descripcion :: String
               , cantidad :: Double
               , precio :: Double
               } deriving (Generic, Show)
instance ToJSON CompraServicio where
 toEncoding = genericToEncoding defaultOptions


instance FromJSON CompraServicio
