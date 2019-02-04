module Lib
    ( mainFunction
    ) where

import Controllers.Proveedores as Proveedores
import Controllers.Productos as Productos
import Controllers.Inventarios as Inventarios
import Control.Monad              ( msum )
import Happstack.Server           (Response, ServerPart,
                                  BodyPolicy(..), defaultBodyPolicy,
                                  decodeBody, dir, nullConf, path,
                                  simpleHTTP)

mainFunction :: IO ()
mainFunction = simpleHTTP nullConf $ handlers

myPolicy :: BodyPolicy
myPolicy = (defaultBodyPolicy "/tmp/" 0 1000 1000)

handlers :: ServerPart Response
handlers = do
  decodeBody myPolicy
  msum [ dir "proveedores" $ path Proveedores.get
       , dir "proveedores" $ path Proveedores.put
       , dir "proveedores" $ path Proveedores.del
       , dir "proveedores" $ Proveedores.post
       , dir "proveedores" $ Proveedores.allGet

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
