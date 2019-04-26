{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Efectivo
(
  Efectivo(..)
) where

import Data.Aeson
import GHC.Generics
import Data.UUID
import TableMappings.Types.DbRow
import Database.HDBC

data Efectivo = Efectivo { idCuenta :: Int
                , guidCuenta :: UUID
                , nombre :: String
                , beneficiario :: String
                , emailNotificacion :: Maybe String
                , activo :: Bool
                } deriving (Generic, Show)
instance ToJSON Efectivo where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Efectivo

instance ToType Efectivo where
  toType row =
    Efectivo { idCuenta = fromSql (row!!0)::Int,
               guidCuenta = read (fromSql (row!!1)::String),
               nombre = fromSql (row!!7)::String,
               beneficiario = fromSql (row!!5)::String,
               emailNotificacion = fromSql (row!!6)::Maybe String,
               activo = fromSql (row!!9)::Bool }

instance FromType Efectivo where
  fromType e =
    [toSql $ nombre e,
     toSql $ beneficiario e,
     toSql $ emailNotificacion e,
     toSql $ activo e,
     toSql $ toString (guidCuenta e),
     toSql $ idCuenta e]
