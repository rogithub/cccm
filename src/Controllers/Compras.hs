module Controllers.Compras
(
  post
) where


import Data.Aeson
import Controllers.Helper
import Models.Compra
import Business.Compras as Business
import Happstack.Server           (Response, ServerPart, method, look,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  askRq, unBody, RqBody, rqBody)
import Control.Monad.IO.Class     ( liftIO )
import TableMappings.MaterialesDb as Db

post :: ServerPart Response
post = do
  method [OPTIONS, POST]
  req  <- askRq
  body <- liftIO $ peekRequestBody req
  logReq ("BODY: " ++ (show body))
  let compra = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Compra
        Nothing     -> Nothing
  logReq ("[POST] compras/" ++ (show compra))
  okJSON (Business.save compra)
