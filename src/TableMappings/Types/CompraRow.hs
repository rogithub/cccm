{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.CompraRow
(
  CompraRow(..)
) where

import Data.Aeson
import GHC.Generics
import TableMappings.Types.CompraServicio
import TableMappings.Types.CompraMaterial


data CompraRow = CompraMaterial | CompraServicio  deriving (Generic, Show)
instance ToJSON CompraRow where
 toEncoding = genericToEncoding defaultOptions
instance FromJSON CompraRow
