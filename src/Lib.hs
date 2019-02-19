module Lib
    ( mainFunction
    ) where

import System.IO as S
import Controllers.Proveedores as Proveedores
import Controllers.Materiales as Materiales
import Controllers.Compras as Compras
import Control.Monad              ( msum )
import Happstack.Server           (Response, ServerPart,
                                  BodyPolicy(..), defaultBodyPolicy,
                                  decodeBody, dir, dirs, nullConf, path,
                                  simpleHTTP)

mainFunction :: IO ()
mainFunction = do
  do S.putStrLn ("http://localhost:8000" ++ "\nlistening...")
  simpleHTTP nullConf $ handlers

myPolicy :: BodyPolicy
myPolicy = (defaultBodyPolicy "/tmp/" 0 1000 1000)

handlers :: ServerPart Response
handlers = do
  decodeBody myPolicy
  msum [ dirs "proveedores/getBy" $ Proveedores.getBy
       , dir "proveedores" $ path Proveedores.get
       , dir "proveedores" $ path Proveedores.put
       , dir "proveedores" $ path Proveedores.del
       , dir "proveedores" $ Proveedores.post
       , dir "proveedores" $ Proveedores.allGet

       , dirs "materiales/getBy" $ Materiales.getBy
       , dir "materiales" $ path Materiales.get
       , dir "materiales" $ path Materiales.put
       , dir "materiales" $ path Materiales.del
       , dir "materiales" $ Materiales.post
       , dir "materiales" $ Materiales.allGet

       , dir "compras" $ Compras.post
       ]
