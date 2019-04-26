module TableMappings.Types.DbRowClass
(
  DbRow,
  toType,
  fromType
) where  

import Database.HDBC

class DbRow a where
  toType :: [SqlValue] -> a
  fromType :: a -> [SqlValue]


data DbRecord a = DbRecord a


instance Functor DbRecord where
  fmap f (DbRecord a) = DbRecord (f a)


