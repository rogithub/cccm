import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
main = do
  obtenerTodos (\l -> do putStrLn $ show l)
