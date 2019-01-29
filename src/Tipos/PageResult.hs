{-# LANGUAGE DeriveGeneric #-}
module Tipos.PageResult
( PageResult(..) ) where

import Data.Aeson
import GHC.Generics

data PageResult a = PageResult { rows :: [a] , totalRows :: Int }
  deriving (Generic, Show)
