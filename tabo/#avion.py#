import psycopg2
from Conexion import *

class Avion:
    conn = Conexion()

    rows = conn.consulta("select * from avions;")
    for row in rows:
        print row[0]
    
    print conn.actualiza("delete from logins where correo = 'micorreo';")
