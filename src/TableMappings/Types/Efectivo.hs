{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Efectivo
(
  Efectivo(..)
) where

import Data.Aeson
import GHC.Generics
import Data.UUID
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
