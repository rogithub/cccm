module Business.Compras
(
  save
) where

import Models.Compra

save :: (Maybe Compra) -> IO Integer
save Nothing  = return 0
save (Just c) = return 1
