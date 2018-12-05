{-# LANGUAGE DeriveGeneric #-}
module ConfeccionesColombia.Tipos
( Producto(..)
, Proveedor(..)
, Stock(..)
, Movimiento(..)
) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar

data Movimiento = Entrada | Salida deriving (Generic, Show)
instance ToJSON Movimiento where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON Movimiento


data Proveedor = Proveedor { proveedorId :: Int
              , empresa :: String
              , contacto :: String
              , domicilio :: String
              , telefono :: String
              , email :: String
              , comentarios :: String
              , activo :: Bool
              } deriving (Generic, Show)
instance ToJSON Proveedor where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON Proveedor

data Producto = Producto { productoId :: Int
               , nombre :: String
               , color :: String
               , unidad :: String
               , idProveedor :: Int
               } deriving (Generic, Show)
instance ToJSON Producto where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Producto

data Stock = Stock { stockId :: Int
              , idProducto :: Int
              , cantidad :: Double
              , precio :: Double
              , fecha :: Day
              , movimiento :: Movimiento
              } deriving (Generic, Show)
instance ToJSON Stock where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Stock
