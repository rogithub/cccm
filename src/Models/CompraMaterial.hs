{-# LANGUAGE DeriveGeneric #-}
module Models.CompraMaterial
( CompraMaterial(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import TableMappings.Types.Material

data CompraMaterial = CompraMaterial { material :: Material
                , cantidad :: Double
                , precio :: Double

               } deriving (Generic, Show)
instance ToJSON CompraMaterial where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON CompraMaterial
