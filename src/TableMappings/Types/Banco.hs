{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Banco
(
  Banco(..)
) where

import Data.Aeson
import GHC.Generics
import Data.UUID
import TableMappings.Types.DbRowClass
import Database.HDBC

data Banco = Banco { idCuenta :: Int
             , guidCuenta :: UUID
             , banco :: String
             , clabe :: Maybe String
             , nocuenta :: Maybe String
             , beneficiario :: String
             , emailNotificacion :: Maybe String
             , activo :: Bool
             } deriving (Generic, Show)
instance ToJSON Banco where
  toEncoding = genericToEncoding defaultOptions
instance FromJSON Banco


instance DbRow Banco where
  toType row =
    Banco { idCuenta = fromSql (row!!0)::Int,
            guidCuenta = read (fromSql (row!!1)::String),
            banco = fromSql (row!!2)::String,
            clabe = fromSql (row!!3)::Maybe String,
            nocuenta = fromSql (row!!4)::Maybe String,
            beneficiario = fromSql (row!!5)::String,
            emailNotificacion = fromSql (row!!6)::Maybe String,
            activo = fromSql (row!!9)::Bool }

  fromType p =
    [toSql $ banco p,
     toSql $ clabe p,
     toSql $ nocuenta p,
     toSql $ beneficiario p,
     toSql $ emailNotificacion p,
     toSql $ activo p,
     toSql $ toString (guidCuenta p),
     toSql $ idCuenta p]
