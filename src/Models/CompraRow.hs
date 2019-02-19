{-# LANGUAGE DeriveGeneric #-}
module Models.CompraRow
(
  CompraRow(..)
) where

import Data.Aeson
import GHC.Generics
import Models.CompraServicio
import Models.CompraMaterial


data CompraRow = CompraMaterial | CompraServicio  deriving (Generic, Show)
instance ToJSON CompraRow where
 toEncoding = genericToEncoding defaultOptions
instance FromJSON CompraRow
