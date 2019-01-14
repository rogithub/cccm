{-# LANGUAGE DeriveGeneric #-}
module Tipos.Stock
(
  Stock(..)
) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar

data Stock = Stock { idStock :: Int
              , idProducto :: Int
              , idProveedor :: Int
              , cantidad :: Double
              , precio :: Double
              , fecha :: Day
              , movimiento :: Int
              } deriving (Generic, Show)
instance ToJSON Stock where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Stock
