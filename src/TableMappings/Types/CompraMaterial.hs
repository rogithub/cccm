{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.CompraMaterial
( CompraMaterial(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Data.UUID

data CompraMaterial = CompraMaterial { idCompraMaterial :: Int
               , guidCompraMaterial :: UUID
               , compraId :: UUID
               , materialId :: UUID
               , cantidad :: Double
               , precio :: Double
               } deriving (Generic, Show)
instance ToJSON CompraMaterial where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON CompraMaterial
