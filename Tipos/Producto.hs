{-# LANGUAGE DeriveGeneric #-}
module Tipos.Producto
( Producto(..) ) where

import Data.Aeson
import GHC.Generics

data Producto = Producto { id :: Int
               , nombre :: String
               , color :: String
               , unidad :: String
               , marca :: String
               , modelo :: String
               , comentarios :: String
               } deriving (Generic, Show)
instance ToJSON Producto where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Producto
