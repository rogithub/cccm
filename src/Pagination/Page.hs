{-# LANGUAGE DeriveGeneric #-}
module Pagination.Page
( Page(..) ) where

-- SELECT *, count(*) OVER() as TOTAL_RECORDS FROM public."Productos" WHERE id > 5 AND activo=true ORDER BY id LIMIT 5;
-- SELECT *, count(*) OVER() as TOTAL_RECORDS FROM public."Productos" WHERE id > 10 AND activo=true ORDER BY id LIMIT 5;
-- SELECT *, count(*) OVER() as TOTAL_RECORDS FROM public."Productos" WHERE id < 6 AND activo=true ORDER BY id LIMIT 5;
-- SELECT *, count(*) OVER() as TOTAL_ROWS FROM public."Productos" WHERE activo=true ORDER BY ID OFFSET 15 FETCH NEXT 5 ROWS ONLY;

data Page a = Page { rows :: a[]
               , pageSize :: Int
               , more :: Bool
               }

data Direction = Left | Right

type LastId = Int
data PageQuery = PageQuery(Direction, LastId)
