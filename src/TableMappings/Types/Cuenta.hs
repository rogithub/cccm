{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.Cuenta
(
  Cuenta(..)
) where

import Data.Aeson
import GHC.Generics
import TableMappings.Types.Banco
import TableMappings.Types.Efectivo


data Cuenta = Banco | Efectivo  deriving (Generic, Show)
instance ToJSON Cuenta where
 toEncoding = genericToEncoding defaultOptions
instance FromJSON Cuenta
