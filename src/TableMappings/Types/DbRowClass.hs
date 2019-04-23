module TableMappings.Types.DbRowClass
(
  DbRow
) where  

import Database.HDBC

class DbRow a where
  toType :: [SqlValue] -> a
  fromType :: a -> [SqlValue]
