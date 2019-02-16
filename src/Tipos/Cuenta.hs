{-# LANGUAGE DeriveGeneric #-}
module Tipos.Cuenta
(
  Cuenta(..)
) where

import Data.Aeson
import GHC.Generics
import Tipos.Banco
import Tipos.Efectivo


data Cuenta = Banco | Efectivo  deriving (Generic, Show)
instance ToJSON Cuenta where
 toEncoding = genericToEncoding defaultOptions
instance FromJSON Cuenta
