module Main where

import Control.Applicative ((<$>), (<*>), optional)
import Controllers.Proveedores
import Control.Monad              ( msum )
import Control.Monad.IO.Class     ( liftIO, MonadIO )
import Happstack.Server           (Response, ServerPart, Request, RqBody, rqBody,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  BodyPolicy(..), decodeBody, defaultBodyPolicy,
                                  dir, method, nullConf, ok, look, path,
                                  toResponse, body, askRq, unBody,
                                  toResponseBS, simpleHTTP, setHeaderM)

main :: IO ()
main = simpleHTTP nullConf $ handlers

myPolicy :: BodyPolicy
myPolicy = (defaultBodyPolicy "/tmp/" 0 1000 1000)

handlers :: ServerPart Response
handlers = do
  decodeBody myPolicy
  msum [ dir "proveedores" $ path proveedoresGet
       , dir "proveedores" $ path proveedoresPut
       , dir "proveedores" $ path proveedoresDel
       , dir "proveedores" $ proveedoresPost
       , dir "proveedores" $ proveedoresGetAll
       ]
