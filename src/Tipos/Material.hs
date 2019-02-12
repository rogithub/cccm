{-# LANGUAGE DeriveGeneric #-}
module Tipos.Material
( Material(..) ) where

import Data.Aeson
import GHC.Generics

data Material = Material { idMaterial :: Int
               , nombre :: String
               , color :: String
               , unidad :: String
               , marca :: Maybe String
               , modelo :: Maybe String
               , comentarios :: Maybe String
               , activo :: Bool
               } deriving (Generic, Show)
instance ToJSON Material where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Material