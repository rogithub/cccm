{-# LANGUAGE DeriveGeneric #-}
module Tipos.Producto
( Producto(..) ) where

import Data.Aeson
import GHC.Generics

data Producto = Producto { idProducto :: Int
               , nombre :: String
               , color :: String
               , unidad :: String
               , marca :: String
               , modelo :: String
               , comentarios :: String
               , activo :: Bool
               } deriving (Generic, Show)
instance ToJSON Producto where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Producto
