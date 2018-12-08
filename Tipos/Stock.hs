{-# LANGUAGE DeriveGeneric #-}
module Tipos.Stock
(
  Movimiento(..)
, Stock(..)
) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar

data Movimiento = Entrada | Salida deriving (Generic, Show)
instance ToJSON Movimiento where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON Movimiento


data Stock = Stock { id :: Int
              , idProducto :: Int
              , idProveedor :: Int
              , cantidad :: Double
              , precio :: Double
              , fecha :: Day
              , movimiento :: Movimiento
              } deriving (Generic, Show)
instance ToJSON Stock where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Stock
