import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb as DbP
main = do
  DbP.getProveedores (\l -> do
      list <- l
      putStrLn $ show list
      return ()
    )
  return()
