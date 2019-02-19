{-# LANGUAGE DeriveGeneric #-}
module Models.CompraServicio
( CompraServicio(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar

data CompraServicio = CompraServicio { idServicio :: Int
                , descripcion :: String
                , cantidad :: Double
                , precio :: Double

               } deriving (Generic, Show)
instance ToJSON CompraServicio where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON CompraServicio
