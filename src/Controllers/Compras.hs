module Controllers.Compras
(
  post
) where


import Data.Aeson
import Controllers.Helper
import TableMappings.Models.Compra
import TableMappings.ComprasModelDb as Db

import Happstack.Server           (Response, ServerPart, method, look,
                                  Method(GET, HEAD, POST, PUT, OPTIONS, DELETE),
                                  askRq, unBody, RqBody, rqBody)
import Control.Monad.IO.Class     ( liftIO )

post :: ServerPart Response
post = do
  method [OPTIONS, POST]
  req  <- askRq
  body <- liftIO $ peekRequestBody req  
  let compra = case body of
        Just rqbody -> decode (unBody rqbody) :: Maybe Compra
        Nothing     -> Nothing
  logReq ("[POST] compras/" ++ (show body))
  okJSON (Db.save compra)
