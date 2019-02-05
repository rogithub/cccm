module Lib
    ( mainFunction
    ) where

import System.IO as S
import Controllers.Proveedores as Proveedores
import Controllers.Productos as Productos
import Controllers.Inventarios as Inventarios
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

       , dirs "materiales/getBy" $ Productos.getBy
       , dir "materiales" $ path Productos.get
       , dir "materiales" $ path Productos.put
       , dir "materiales" $ path Productos.del
       , dir "materiales" $ Productos.post
       , dir "materiales" $ Productos.allGet

       , dir "inventarios" $ path Inventarios.get
       , dir "inventarios" $ path Inventarios.put
       , dir "inventarios" $ path Inventarios.del
       , dir "inventarios" $ Inventarios.post
       , dir "inventarios" $ Inventarios.allGet
       ]
