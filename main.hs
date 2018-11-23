import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
main = do
  affectedRows <- save Proveedor { proveedorId = 0,
    empresa = "Liconsa",
    contacto = "Rodrigo",
    domicilio = "Juarez 1000",
    telefono = "4521329604",
    email = "correo.rodrigo@gmail.com",
    comentarios = "chido cabron",
    activo = True }

  putStrLn $ show affectedRows

  list <- getAll (\l -> putStrLn $ show l)

  putStrLn $ show list
