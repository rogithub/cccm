import Database.HDBC
import Database.HDBC.PostgreSQL

main = do
    putStrLn "Enter query:"
    query <- getLine
    conn <- connectPostgreSQL "host=localhost dbname=cc user=postgres"
    vals <- quickQuery conn query [ ]
    putStrLn ( "Returned row count " ++ show ( length vals ) )
    putStrLn $ show vals
