{-# LANGUAGE DeriveGeneric #-}
module Tipos.Banco
(
  Banco(..)
) where

import Data.Aeson
import GHC.Generics

data Banco = Banco { idCuenta :: Int
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
