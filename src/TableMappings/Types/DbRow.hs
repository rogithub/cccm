module TableMappings.Types.DbRow
(
  DbRow,
  ToType(..),
  FromType(..)
) where  

import Database.HDBC

class ToType a where
  toType :: [SqlValue] -> a

class FromType a where
  fromType :: a -> [SqlValue]
  

data DbRow a = DbRow a


instance Functor DbRow where
  fmap f (DbRow a) = DbRow (f a)


