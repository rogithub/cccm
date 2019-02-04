module Controllers.Inventarios
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
import Tipos.Stock
import TableMappings.StockDb as Db
import Happstack.Server           (Response, ServerPart, method, look,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  askRq, unBody, RqBody, rqBody)
import Control.Monad.IO.Class     ( liftIO )

allGet :: ServerPart Response
allGet = do
  method [GET, HEAD]
  offset <- look "offset"
  pageSize <- look "pageSize"
  do liftIO $ S.putStrLn ("[GET] inventarios?" ++ "offset=" ++ offset ++ "&pageSize=" ++ pageSize)
  okJSON (Db.getAll (read offset::Int) (read pageSize::Int))

get :: String -> ServerPart Response
get key = do
  method [GET, HEAD]
  do liftIO $ S.putStrLn ("[GET] inventarios/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.getOne intKey)

put :: String -> ServerPart Response
put key = do
  method [OPTIONS, PUT]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let stock = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Stock
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[PUT] inventarios/" ++ (show stock))
  okJSON (Db.update stock)

post :: ServerPart Response
post = do
  method [OPTIONS, POST]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  let stock = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Stock
        Nothing     -> Nothing
  do liftIO $ S.putStrLn ("[POST] inventarios/" ++ (show stock))
  okJSON (Db.save stock)

del :: String -> ServerPart Response
del key = do
  method [OPTIONS, DELETE]
  do liftIO $ S.putStrLn ("[DELETE] inventarios/" ++ key)
  let intKey = read key :: Int
  okJSON (Db.delete intKey)
