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
  toType r =
    Material { idMaterial = fromSql (r!!0)::Int,
               guidMaterial = read (fromSql (r!!1)::String),
               nombre = fromSql (r!!2)::String,
               color = fromSql (r!!3)::String,
               unidad = fromSql (r!!4)::String,
               marca = fromSql (r!!5)::Maybe String,
               modelo = fromSql (r!!6)::Maybe String,
               comentarios = fromSql (r!!7)::Maybe String,
               activo = fromSql (r!!8)::Bool }

  fromType t =
    [toSql $ nombre t,
     toSql $ color t,
     toSql $ unidad t,
     toSql $ marca t,
     toSql $ modelo t,
     toSql $ comentarios t,
     toSql $ activo t,
     toSql $ toString (guidMaterial t),
     toSql $ idMaterial t]
