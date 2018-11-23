import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
main = do
  obtenerTodos (\l -> do
      list <- l
      putStrLn $ show list
      return ()
    )
  return()
