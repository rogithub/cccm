module Controllers.Proveedores
(
  getBy,
  allGet,
  get,
  put,
  post,
  del
) where

import Data.Aeson
import Controllers.Helper
import Tipos.Proveedor
import TableMappings.ProveedoresDb as Db
import Happstack.Server           (Response, ServerPart, method, look,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  askRq, unBody, RqBody, rqBody)
import Control.Monad.IO.Class     ( liftIO )

getBy :: ServerPart Response
getBy = do
  method [GET, HEAD]
  name <- look "name"
  logReq ("[GET] proveedores/getBy?name=" ++ name)
  okJSON (Db.getByName ("%"++name++"%"))

allGet :: ServerPart Response
allGet = do
  method [GET, HEAD]
  offset <- look "offset"
  pageSize <- look "pageSize"
  name <- look "name"
  logReq ("[GET] proveedores?" ++ "offset=" ++ offset ++ "&pageSize=" ++ pageSize ++ "&name=" ++ name)
  okJSON (Db.getAll (read offset::Int) (read pageSize::Int) ("%"++name++"%"))

get :: String -> ServerPart Response
get key = do
  method [GET, HEAD]
  logReq ("[GET] proveedores/" ++ key)
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
  logReq ("[PUT] proveedores/" ++ (show proveedor))
  okJSON (Db.update proveedor)

post :: ServerPart Response
post = do
  method [OPTIONS, POST]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let proveedor = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Proveedor
        Nothing     -> Nothing
  logReq ("[POST] proveedores/" ++ (show proveedor))
  okJSON (Db.save proveedor)

del :: String -> ServerPart Response
del key = do
  method [OPTIONS, DELETE]
  logReq ("[DELETE] proveedores/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.delete intKey)
