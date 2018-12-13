module Main where

import Control.Applicative ((<$>), (<*>), optional)
import Control.Concurrent.MVar (tryReadMVar)
import System.IO as S
import Tipos.Proveedor
import TableMappings.ProveedoresDb
import Control.Monad              ( msum )
import Control.Monad.IO.Class     ( liftIO, MonadIO )
import Data.ByteString.Char8 as C
import Data.ByteString.Lazy as L
import Data.Aeson
import Happstack.Server           (Response, ServerPart, Request, RqBody, rqBody,
                                  Method(GET, HEAD, POST, PUT, OPTIONS),
                                  BodyPolicy(..), decodeBody, defaultBodyPolicy,
                                  dir, method, nullConf, ok, look, path,
                                  toResponse, body, askRq, unBody,
                                  toResponseBS, simpleHTTP, setHeaderM)

main :: IO ()
main = simpleHTTP nullConf $ handlers

myPolicy :: BodyPolicy
myPolicy = (defaultBodyPolicy "/tmp/" 0 1000 1000)

peekRequestBody :: (MonadIO m) => Request -> m (Maybe RqBody)
peekRequestBody rq = liftIO $ tryReadMVar (rqBody rq)

okJSON :: (ToJSON a) => IO a -> ServerPart Response
okJSON payload = do
  newMonad <- liftIO payload
  let json = encode newMonad
  mapM_ (uncurry setHeaderM) [ ("Access-Control-Allow-Origin", "*")
                             , ("Access-Control-Allow-Headers", "Accept, Content-Type")
                             , ("Access-Control-Allow-Methods", "GET, HEAD, POST, DELETE, OPTIONS, PUT, PATCH")
                             ]
  ok $ toResponseBS (C.pack "application/json") json

proveedoresGetAll :: ServerPart Response
proveedoresGetAll = do
  method [GET, HEAD]
  do liftIO $ S.putStrLn ("[GET] proveedores")
  okJSON getAll

proveedoresGetOne :: String -> ServerPart Response
proveedoresGetOne key = do
  method [GET, HEAD]
  do liftIO $ S.putStrLn ("[GET] proveedores/" ++ key)
  let intKey = read key :: Int
  okJSON (getOne intKey)

proveedoresPutOne :: String -> ServerPart Response
proveedoresPutOne key = do
  method [OPTIONS, PUT]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let proveedor = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Proveedor
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[PUT] proveedores/" ++ (show proveedor))
  okJSON (update proveedor)


handlers :: ServerPart Response
handlers = do
  decodeBody myPolicy
  msum [ dir "proveedores" $ path proveedoresGetOne
       , dir "proveedores" $ path proveedoresPutOne
       , dir "proveedores" $ proveedoresGetAll
       ]
