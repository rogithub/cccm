import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
main = do
  getAll (\l -> putStrLn $ show l)
