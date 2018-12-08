module Main where

import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
import Control.Monad              ( msum )
import Control.Monad.IO.Class     ( liftIO )
import Data.ByteString.Char8 as C
import Data.Aeson
import Happstack.Server           (Response, ServerPart, Method(GET, POST),
                                  dirs, method, nullConf, ok,
                                  toResponseBS, simpleHTTP)

main :: IO ()
main = simpleHTTP nullConf $ handlers

listarClientes :: ServerPart Response
listarClientes = do
  method GET
  all <- liftIO $ getAll
  ok $ toResponseBS (C.pack "application/json") (encode all)

handlers :: ServerPart Response
handlers =
  msum [ dirs "clientes/lista" $ listarClientes ]
