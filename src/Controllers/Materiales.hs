module Controllers.Materiales
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
import Tipos.Material
import TableMappings.MaterialesDb as Db
import Happstack.Server           (Response, ServerPart, method, look,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  askRq, unBody, RqBody, rqBody)
import Control.Monad.IO.Class     ( liftIO )

getBy :: ServerPart Response
getBy = do
  method [GET, HEAD]
  name <- look "name"
  logReq ("[GET] materiales/getBy?name=" ++ name)
  okJSON (Db.getByName ("%"++name++"%"))

allGet :: ServerPart Response
allGet = do
  method [GET, HEAD]
  offset <- look "offset"
  pageSize <- look "pageSize"
  logReq ("[GET] materiales?" ++ "offset=" ++ offset ++ "&pageSize=" ++ pageSize)
  okJSON (Db.getAll (read offset::Int) (read pageSize::Int))

get :: String -> ServerPart Response
get key = do
  method [GET, HEAD]
  logReq ("[GET] materiales/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.getOne intKey)

put :: String -> ServerPart Response
put key = do
  method [OPTIONS, PUT]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let material = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Material
        Nothing     -> Nothing
  logReq ("[PUT] materiales/" ++ (show material))
  okJSON (Db.update material)

post :: ServerPart Response
post = do
  method [OPTIONS, POST]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let material = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Material
        Nothing     -> Nothing
  logReq ("[POST] materiales/" ++ (show material))
  okJSON (Db.save material)

del :: String -> ServerPart Response
del key = do
  method [OPTIONS, DELETE]
  logReq ("[DELETE] materiales/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.delete intKey)
