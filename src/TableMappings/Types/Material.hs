{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Material
( Material(..) ) where

import Data.Aeson
import GHC.Generics
import Data.UUID
import TableMappings.Types.DbRowClass
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

instance DbRow Material where
  toType row =
    Material { idMaterial = fromSql (row!!0)::Int,
               guidMaterial = read (fromSql (row!!1)::String),
               nombre = fromSql (row!!2)::String,
               color = fromSql (row!!3)::String,
               unidad = fromSql (row!!4)::String,
               marca = fromSql (row!!5)::Maybe String,
               modelo = fromSql (row!!6)::Maybe String,
               comentarios = fromSql (row!!7)::Maybe String,
               activo = fromSql (row!!8)::Bool }

  fromType p =
    [toSql $ nombre p,
     toSql $ color p,
     toSql $ unidad p,
     toSql $ marca p,
     toSql $ modelo p,
     toSql $ comentarios p,
     toSql $ activo p,
     toSql $ toString (guidMaterial p),
     toSql $ idMaterial p]
