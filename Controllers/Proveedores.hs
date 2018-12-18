module Controllers.Proveedores
(
  proveedoresGetAll,
  proveedoresGet,
  proveedoresPut,
  proveedoresPost,
  proveedoresDel
) where

import System.IO as S
import Data.Aeson
import Controllers.Helper
import Tipos.Proveedor
import TableMappings.ProveedoresDb
import Happstack.Server           (Response, ServerPart, method,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  askRq, unBody, RqBody, rqBody)
import Control.Monad.IO.Class     ( liftIO )

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
