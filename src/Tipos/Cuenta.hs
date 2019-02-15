{-# LANGUAGE DeriveGeneric #-}
module Tipos.Cuenta
( Cuenta(..) ) where

import Data.Aeson
import GHC.Generics

data Cuenta = Banco { idCuenta :: Int
               , banco :: String
               , clabe :: Maybe String
               , nocuenta :: Maybe String
               , beneficiario :: String
               , emailNotificacion :: Maybe String
               , activo :: Bool
               } |
               Efectivo { idCuenta :: Int
                              , nombre :: String
                              , beneficiario :: String
                              , emailNotificacion :: Maybe String
                              , activo :: Bool
                              }
                deriving (Generic, Show)
instance ToJSON Cuenta where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Cuenta
