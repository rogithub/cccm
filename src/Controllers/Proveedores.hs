module Controllers.Proveedores
(
  allGet,
  get,
  put,
  post,
  del
) where

import System.IO as S
import Data.Aeson
import Controllers.Helper
import Tipos.Proveedor
import TableMappings.ProveedoresDb as Db
import Happstack.Server           (Response, ServerPart, method,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  askRq, unBody, RqBody, rqBody)
import Control.Monad.IO.Class     ( liftIO )

allGet :: ServerPart Response
allGet = do
  method [GET, HEAD]
  do liftIO $ S.putStrLn ("[GET] proveedores")
  okJSON Db.getAll

get :: String -> ServerPart Response
get key = do
  method [GET, HEAD]
  do liftIO $ S.putStrLn ("[GET] proveedores/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.getOne intKey)

put :: String -> ServerPart Response
put key = do
  method [OPTIONS, PUT]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let proveedor = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Proveedor
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[PUT] proveedores/" ++ (show proveedor))
  okJSON (Db.update proveedor)

post :: ServerPart Response
post = do
  method [OPTIONS, POST]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let proveedor = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Proveedor
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[POST] proveedores/" ++ (show proveedor))
  okJSON (Db.save proveedor)

del :: String -> ServerPart Response
del key = do
  method [OPTIONS, DELETE]
  do liftIO $ S.putStrLn ("[DELETE] proveedores/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.delete intKey)
