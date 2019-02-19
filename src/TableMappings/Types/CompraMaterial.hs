{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.CompraMaterial
( CompraMaterial(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar

data CompraMaterial = CompraMaterial { idCompraMaterial :: Int
               , compraId :: Int
               , materialId :: Int
               , cantidad :: Double
               , precio :: Double
               } deriving (Generic, Show)
instance ToJSON CompraMaterial where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON CompraMaterial
