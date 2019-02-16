{-# LANGUAGE DeriveGeneric #-}
module Tipos.Efectivo
(
  Efectivo(..)
) where

import Data.Aeson
import GHC.Generics

data Efectivo = Efectivo { idCuenta :: Int
                , nombre :: String
                , beneficiario :: String
                , emailNotificacion :: Maybe String
                , activo :: Bool
                } deriving (Generic, Show)
instance ToJSON Efectivo where
 toEncoding = genericToEncoding defaultOptions
instance FromJSON Efectivo
