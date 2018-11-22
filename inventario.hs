module Inventario
( Producto
, Proveedor
, Stock
) where

import Data.Time.Calendar
import Data.UUID

data Movimiento = Entrada | Salida deriving (Show)

-- Proveedor (read "00000000-0000-0000-0000-000000000000") "La Macarena" "Don Ramon" "Inguambo 56" "452-132-96-04" "ro@ro.com"
data Proveedor = Proveedor { proveedorId :: UUID
              , empresa :: String
              , contacto :: String
              , domicilio :: String
              , telefono :: String
              , email :: String
              } deriving (Show)

data Producto = Producto { productoId :: UUID
               , folio :: Int
               , nombre :: String
               , color :: String
               , unidad :: String
               , idProveedor :: UUID
               } deriving (Show)

data Stock = Stock { stockId :: UUID
              , idProducto :: UUID
              , cantidad :: Double
              , precio :: Double
              , fecha :: Day
              , movimiento :: Movimiento
              } deriving (Show)
