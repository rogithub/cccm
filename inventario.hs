module Inventario
( Producto
, Proveedor
, Stock
) where

import Data.Time.Calendar

data Movimiento = Entrada | Salida deriving (Show)

data Proveedor = Proveedor { proveedorId :: Int
              , empresa :: String
              , contacto :: String
              , domicilio :: String
              , telefono :: String
              , email :: String
              , comentarios :: String
              , activo :: Boolean
              } deriving (Show)

data Producto = Producto { productoId :: Int
               , nombre :: String
               , color :: String
               , unidad :: String
               , idProveedor :: Int
               } deriving (Show)

data Stock = Stock { stockId :: Int
              , idProducto :: Int
              , cantidad :: Double
              , precio :: Double
              , fecha :: Day
              , movimiento :: Movimiento
              } deriving (Show)
