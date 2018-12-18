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
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
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

proveedoresGet :: String -> ServerPart Response
proveedoresGet key = do
  method [GET, HEAD]
  do liftIO $ S.putStrLn ("[GET] proveedores/" ++ key)
  let intKey = read key :: Int
  okJSON (getOne intKey)

proveedoresPut :: String -> ServerPart Response
proveedoresPut key = do
  method [OPTIONS, PUT]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let proveedor = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Proveedor
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[PUT] proveedores/" ++ (show proveedor))
  okJSON (update proveedor)

proveedoresPost :: ServerPart Response
proveedoresPost = do
  method [OPTIONS, POST]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let proveedor = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Proveedor
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[POST] proveedores/" ++ (show proveedor))
  okJSON (save proveedor)

proveedoresDel :: String -> ServerPart Response
proveedoresDel key = do
  method [OPTIONS, DELETE]
  do liftIO $ S.putStrLn ("[DELETE] proveedores/" ++ key)
  let intKey = read key :: Int
  okJSON (delete intKey)

handlers :: ServerPart Response
handlers = do
  decodeBody myPolicy
  msum [ dir "proveedores" $ path proveedoresGet
       , dir "proveedores" $ path proveedoresPut
       , dir "proveedores" $ path proveedoresDel
       , dir "proveedores" $ proveedoresPost
       , dir "proveedores" $ proveedoresGetAll
       ]
