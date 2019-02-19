{-# LANGUAGE DeriveGeneric #-}
module Tipos.CompraRow
(
  CompraRow(..)
) where

import Data.Aeson
import GHC.Generics
import Tipos.CompraServicio
import Tipos.CompraMaterial


data CompraRow = CompraMaterial | CompraServicio  deriving (Generic, Show)
instance ToJSON CompraRow where
 toEncoding = genericToEncoding defaultOptions
instance FromJSON CompraRow
