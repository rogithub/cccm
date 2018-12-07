import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
import Data.Aeson

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
  list <- getAll
  putStrLn $ show (encode list)
