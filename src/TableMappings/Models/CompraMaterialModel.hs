{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Models.CompraMaterialModel
(
  CompraMaterialModel(..)
) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import TableMappings.Types.Material
import TableMappings.Types.CompraMaterial

import Data.UUID

data CompraMaterialModel =
  CompraMaterialModel { material :: Material
                      , compraMaterial :: CompraMaterial
                      } deriving (Generic, Show)

instance ToJSON CompraMaterialModel where
  toEncoding = genericToEncoding defaultOptions
  
instance FromJSON CompraMaterialModel
