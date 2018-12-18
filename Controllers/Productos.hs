module Controllers.Productos
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
import Tipos.Producto
import TableMappings.ProductosDb as Db
import Happstack.Server           (Response, ServerPart, method,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  askRq, unBody, RqBody, rqBody)
import Control.Monad.IO.Class     ( liftIO )

allGet :: ServerPart Response
allGet = do
  method [GET, HEAD]
  do liftIO $ S.putStrLn ("[GET] materiales")
  okJSON Db.getAll

get :: String -> ServerPart Response
get key = do
  method [GET, HEAD]
  do liftIO $ S.putStrLn ("[GET] materiales/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.getOne intKey)

put :: String -> ServerPart Response
put key = do
  method [OPTIONS, PUT]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let producto = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Producto
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[PUT] materiales/" ++ (show producto))
  okJSON (Db.update producto)

post :: ServerPart Response
post = do
  method [OPTIONS, POST]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let producto = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Producto
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[POST] materiales/" ++ (show producto))
  okJSON (Db.save producto)

del :: String -> ServerPart Response
del key = do
  method [OPTIONS, DELETE]
  do liftIO $ S.putStrLn ("[DELETE] materiales/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.delete intKey)
