import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
main = do
  getProveedores (\l -> do
      list <- l
      putStrLn $ show list
      return ()
    )
  return()
