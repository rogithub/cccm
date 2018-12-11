module Main where

import Tipos.Proveedor
import TableMappings.ProveedoresDb
import Control.Monad              ( msum )
import Control.Monad.IO.Class     ( liftIO )
import Data.ByteString.Char8 as C
import Data.ByteString.Lazy as L
import Data.Aeson
import Happstack.Server           (Response, ServerPart, Method(GET, POST),
                                  dirs, method, nullConf, ok,
                                  toResponseBS, simpleHTTP, setHeaderM)

main :: IO ()
main = simpleHTTP nullConf $ handlers

getOkJSON :: (ToJSON a) => IO a -> ServerPart Response
getOkJSON payload = do
  method GET
  newMonad <- liftIO payload
  let json = encode newMonad
  mapM_ (uncurry setHeaderM) [ ("Access-Control-Allow-Origin", "*")
                             , ("Access-Control-Allow-Headers", "Accept, Content-Type")
                             , ("Access-Control-Allow-Methods", "GET, HEAD, POST, DELETE, OPTIONS, PUT, PATCH")
                             ]
  ok $ toResponseBS (C.pack "application/json") json

handlers :: ServerPart Response
handlers =
  msum [ dirs "proveedores/lista" $ getOkJSON getAll ]
