module Main where

import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
import Control.Monad (msum)
import Data.ByteString.Char8 as C
import Happstack.Server (Method(GET, POST), dir, method, nullConf, ok, toResponseBS, simpleHTTP)
import Data.Aeson

getProveedor :: Proveedor
getProveedor = Proveedor { proveedorId = 0,
  empresa = "Liconsa",
  contacto = "Rodrigo",
  domicilio = "Juarez 1000",
  telefono = "4521329604",
  email = "correo.rodrigo@gmail.com",
  comentarios = "chido cabron",
  activo = True }

toJsonResponse :: ToJSON a => IO a -> IO b
toJsonResponse it = do
  item <-item
  ok $ toResponseBS (C.pack "application/json") (encode item)

main :: IO ()
main = simpleHTTP nullConf $ msum
       [ dir "getAll" $ do
         method GET
         toJsonResponse (getAll)
       ]
