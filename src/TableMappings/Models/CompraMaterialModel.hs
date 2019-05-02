{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Models.CompraMaterialModel
(
  CompraMaterialModel(..)
) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import TableMappings.Types.Material
import Data.UUID

data CompraMaterialModel =
  MaterialNuevo { material :: Material
                , cantidad :: Double
                , precio :: Double
                }
  | MaterialExistente { materialId :: UUID
                      , cantidad :: Double
                      , precio :: Double }
                     deriving (Generic, Show)


instance ToJSON CompraMaterialModel where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON CompraMaterialModel
