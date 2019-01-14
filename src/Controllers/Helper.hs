module Controllers.Helper
(
  peekRequestBody,
  okJSON
) where

import Data.Aeson
import Control.Concurrent.MVar (tryReadMVar)
import Data.ByteString.Char8 as C
import Data.ByteString.Lazy as L
import Control.Monad.IO.Class     ( liftIO, MonadIO )
import Happstack.Server (Response, ServerPart, Request, RqBody, rqBody,
                        ok, toResponseBS, setHeaderM)


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