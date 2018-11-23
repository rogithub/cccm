import ConfeccionesColombia.Tipos
import ConfeccionesColombia.ProveedoresDb
main = do
  getAll (\l -> putStrLn $ show l)
  let p = Proveedor { proveedorId = 0,
    empresa = "Liconsa",
    contacto = "Rodrigo",
    domicilio = "Juarez 1000",
    telefono = "4521329604",
    email = "correo.rodrigo@gmail.com",
    comentarios = "chigo cabron",
    activo = True }
  save p
