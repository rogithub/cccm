module Main where

import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
import Control.Monad              ( msum )
import Control.Monad.IO.Class     ( liftIO )
import Data.ByteString.Char8 as C
import Data.Aeson
import Happstack.Server           (Method(GET, POST),
                                  dir, method, nullConf, ok,
                                  toResponseBS, simpleHTTP)

main :: IO ()
main = simpleHTTP nullConf $ msum
       [ dir "getAll" $ do
         method GET
         all <- liftIO $ getAll
         ok $ toResponseBS (C.pack "application/json") (encode all)
       ]
