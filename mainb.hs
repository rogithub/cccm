import Tipos.Proveedor
import TableMappings.ProveedoresDb
import Data.Aeson

nuevo :: Proveedor
nuevo =
  Proveedor { idProveedor = 0,
    empresa = "Liconsa",
    contacto = "Rodrigo",
    domicilio = "Juarez 1000",
    telefono = "4521329604",
    email = "correo.rodrigo@gmail.com",
    comentarios = "chido cabron",
    activo = True }

main = do
  --save nuevo
  json <- encode <$> getAll
  putStrLn $ show json
