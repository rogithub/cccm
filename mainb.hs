import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb

insertOne :: IO Integer
insertOne = do
  save Proveedor { proveedorId = 0,
    empresa = "Liconsa",
    contacto = "Rodrigo",
    domicilio = "Juarez 1000",
    telefono = "4521329604",
    email = "correo.rodrigo@gmail.com",
    comentarios = "chido cabron",
    activo = True }

main = do
  -- needs to be inside a lambda so it keeps laziness
  list <- getAll 2

  putStrLn $ show list
