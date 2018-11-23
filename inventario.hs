data Proveedor = Proveedor { id :: String
                     , empresa :: String
                     , contacto :: String
                     , domicilio :: String
                     , telefono :: String
                     , email :: String
                     , horarioAtencion :: String
                     } deriving (Show)

data Producto = Producto { id :: String
                      , folio :: Int
                      , nombre :: String
                      , color :: String
                      , unidad :: String
                      , proveedorId :: String
                      } deriving (Show)
