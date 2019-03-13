{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Banco
(
  Banco(..)
) where

import Data.Aeson
import GHC.Generics
import Data.UUID

data Banco = Banco { idCuenta :: Int
             , guidCuenta :: GUID
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
