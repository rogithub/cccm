{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.CompraMaterial
( CompraMaterial(..) ) where

import Data.Aeson
import GHC.Generics
import Data.Time.Calendar
import Data.UUID
import TableMappings.Types.DbRow
import Database.HDBC

data CompraMaterial = CompraMaterial { idCompraMaterial :: Int
               , guidCompraMaterial :: UUID
               , compraId :: UUID
               , materialId :: UUID
               , cantidad :: Double
               , precio :: Double
               } deriving (Generic, Show)
instance ToJSON CompraMaterial where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON CompraMaterial

instance ToType CompraMaterial where
  toType row =
    CompraMaterial { idCompraMaterial = fromSql (row!!0) :: Int,
                     guidCompraMaterial = read (fromSql (row!!1) :: String),
                     compraId = read (fromSql (row!!2) :: String),
                     materialId = read (fromSql (row!!3) :: String),
                     cantidad = fromSql (row!!4) :: Double,
                     precio = fromSql (row!!5) :: Double }

instance FromType CompraMaterial where
  fromType m =
    [ toSql $ toString (compraId m),
      toSql $ toString (materialId m),
      toSql $ cantidad m,
      toSql $ precio m,
      toSql $ toString (guidCompraMaterial m),
      toSql $ idCompraMaterial m ]
