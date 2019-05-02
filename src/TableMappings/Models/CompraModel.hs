{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Models.CompraModel
( CompraModel(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import TableMappings.Types.Compra
import TableMappings.Types.CompraServicio
import TableMappings.Models.CompraMaterialModel
import Data.UUID

data CompraModel = CompraModel { compra :: Compra
                               , materiales :: [CompraMaterialModel]
                               , servicios  :: [CompraServicio]
                               } deriving (Generic, Show)

instance ToJSON CompraModel where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON CompraModel
