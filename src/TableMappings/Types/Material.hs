{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Material
( Material(..) ) where

import Data.Aeson
import GHC.Generics
import Data.UUID
import Database.HDBC

data Material = Material { idMaterial :: Int
               , guidMaterial :: UUID
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

