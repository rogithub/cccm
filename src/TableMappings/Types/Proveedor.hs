{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Proveedor
(Proveedor(..)) where

import Data.Aeson
import GHC.Generics
import Data.UUID
import TableMappings.Types.DbRow
import Database.HDBC


data Proveedor = Proveedor { idProveedor :: Int
              , guidProveedor :: UUID
              , empresa :: String
              , contacto :: String
              , domicilio :: Maybe String
              , telefono :: String
              , email :: String
              , comentarios :: Maybe String
              , activo :: Bool
              } deriving (Generic, Show)
instance ToJSON Proveedor where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON Proveedor

instance ToType Proveedor where
  toType r =
    Proveedor { idProveedor = fromSql (r!!0)::Int,
                guidProveedor = read (fromSql (r!!1)::String),
                empresa = fromSql (r!!2)::String,
                contacto = fromSql (r!!3)::String,
                domicilio = fromSql (r!!4)::Maybe String,
                telefono = fromSql (r!!5)::String,
                email = fromSql (r!!6)::String,
                comentarios = fromSql (r!!7)::Maybe String,
                activo = fromSql (r!!8)::Bool }
instance FromType Proveedor where
  fromType p =
    [toSql $ empresa p,
     toSql $ contacto p,
     toSql $ domicilio p,
     toSql $ telefono p,
     toSql $ email  p,
     toSql $ comentarios p,
     toSql $ activo p,
     toSql $ toString (guidProveedor p),
     toSql $ idProveedor p]

