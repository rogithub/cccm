module Main where

import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
import Control.Monad (msum)
import Happstack.Server (Method(GET, POST), dir, method, nullConf, ok, toResponse, simpleHTTP)
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

main :: IO ()
main = simpleHTTP nullConf $ msum
       [ dir "getAll" $ do method GET
                           ok $ toResponse (encode getProveedor)
       ]

-- main = do
--   affectedRows <- save Proveedor { proveedorId = 0,
--     empresa = "Liconsa",
--     contacto = "Rodrigo",
--     domicilio = "Juarez 1000",
--     telefono = "4521329604",
--     email = "correo.rodrigo@gmail.com",
--     comentarios = "chido cabron",
--     activo = True }
--
--   putStrLn $ show affectedRows
--
--   -- needs to be inside a lambda so it keeps laziness
--   list <- getAll (\l -> putStrLn $ show l)
--
--   putStrLn $ show list
