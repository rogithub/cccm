{-# LANGUAGE DeriveGeneric #-}
module Pagination.Page
( Page(..) ) where

-- SELECT *, count(*) OVER() as TOTAL_RECORDS FROM public."Productos" WHERE id > 5 AND activo=true ORDER BY id LIMIT 5;
-- SELECT *, count(*) OVER() as TOTAL_RECORDS FROM public."Productos" WHERE id > 10 AND activo=true ORDER BY id LIMIT 5;
-- SELECT *, count(*) OVER() as TOTAL_RECORDS FROM public."Productos" WHERE id < 6 AND activo=true ORDER BY id LIMIT 5;
-- SELECT *, count(*) OVER() as TOTAL_ROWS FROM public."Productos" WHERE activo=true ORDER BY ID OFFSET 15 FETCH NEXT 5 ROWS ONLY;


import Data.Aeson
import GHC.Generics

data Page a = Page { rows :: a[],
               , pageSize :: Int
               , more :: Bool
               } deriving (Generic, Show)

data Direction = Left | Right deriving (Generic, Show)

type LastId = Int
data PageQuery = (Direction, LastId) deriving (Generic, Show)

instance ToJSON Page where
 toEncoding = genericToEncoding defaultOptions

instance FromJSON Page
