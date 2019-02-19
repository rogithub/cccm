{-# LANGUAGE DeriveGeneric #-}
module Tipos.CompraServicio
( CompraServicio(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar

data CompraServicio = CompraServicio { idCompraServicio :: Int
               , compraId :: Int
               , descripcion :: String
               , cantidad :: Double
               , precio :: Double
               } deriving (Generic, Show)
instance ToJSON CompraServicio where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON CompraServicio
