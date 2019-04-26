{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.CompraServicio
( CompraServicio(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Data.UUID
import TableMappings.Types.DbRow
import Database.HDBC

data CompraServicio = CompraServicio { idCompraServicio :: Int
               , guidCompraServicio :: UUID
               , compraId :: UUID
               , descripcion :: String
               , cantidad :: Double
               , precio :: Double
               } deriving (Generic, Show)
instance ToJSON CompraServicio where
 toEncoding = genericToEncoding defaultOptions


instance FromJSON CompraServicio


instance ToType CompraServicio where
  toType row =
    CompraServicio { idCompraServicio = fromSql (row!!0) :: Int,
                     guidCompraServicio = read (fromSql (row!!1) :: String),
                     compraId = read (fromSql (row!!2) :: String),
                     descripcion = fromSql (row!!3) :: String,
                     cantidad = fromSql (row!!4) :: Double,
                     precio = fromSql (row!!5) :: Double }

instance FromType CompraServicio where
  fromType c =
    [ toSql $ toString (compraId c),
      toSql $ descripcion c,
      toSql $ cantidad c,
      toSql $ precio c,
      toSql $ toString (guidCompraServicio c),
      toSql $ idCompraServicio c ]
