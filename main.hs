import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
main = do
  obtenerTodos (\l -> putStrLn $ show l)
