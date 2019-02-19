{-# LANGUAGE DeriveGeneric #-}
module TableMappings.Types.PageResult
( PageResult(..) ) where

import Data.Aeson
import GHC.Generics

data PageResult a = PageResult { rows :: [a] , totalRows :: Int }
  deriving (Generic, Show)


instance ToJSON a => ToJSON (PageResult a) where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON a => FromJSON (PageResult a)
