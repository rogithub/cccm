module ConfeccionesColombia.ProveedoresDb
(
  obtenerTodos
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL
import ConfeccionesColombia.Db
import ConfeccionesColombia.Tipos

aTipo :: [SqlValue] -> Proveedor
aTipo sqlVal =
  Proveedor { proveedorId = fromSql (sqlVal!!0)::Int,
    empresa = fromSql (sqlVal!!1)::String,
    contacto = fromSql (sqlVal!!2)::String,
    domicilio = fromSql (sqlVal!!3)::String,
    telefono = fromSql (sqlVal!!4)::String,
    email = fromSql (sqlVal!!5)::String,
    comentarios = fromSql (sqlVal!!6)::String,
    activo = fromSql (sqlVal!!7)::Bool }

getAll :: Connection -> IO [[SqlValue]]
getAll c =
  execSel c "select * from public.\"Proveedores\"" []

obtenerTodos :: ([Proveedor] -> IO a) -> IO a
obtenerTodos f =
  execQuery (\c -> getAll c >>= (\rows -> f $ map aTipo rows))
