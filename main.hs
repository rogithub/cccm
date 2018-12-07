module Main where

import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
import Control.Monad (msum)
import Data.ByteString.Char8 as C
import Happstack.Server (Method(GET, POST), dir, method, nullConf, ok, toResponseBS, simpleHTTP)
import Data.Aeson
import Control.Monad.IO.Class        ( liftIO )

getProveedor :: Proveedor
getProveedor = Proveedor { proveedorId = 0,
  empresa = "Liconsa",
  contacto = "Rodrigo",
  domicilio = "Juarez 1000",
  telefono = "4521329604",
  email = "correo.rodrigo@gmail.com",
  comentarios = "chido cabron",
  activo = True }


main :: IO ()
main = simpleHTTP nullConf $ msum
       [ dir "getAll" $ do
         method GET
         all <- liftIO $ getAll
         ok $ toResponseBS (C.pack "application/json") (encode all)
       ]
