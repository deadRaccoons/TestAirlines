import psycopg2
class Conexion:
    
    def actualiza(self, sql):
        try:
            conn = psycopg2.connect("dbname='mamelines' user='mamelines' password='mame'")
        except:
            print "No se puede conectar"
        cur = conn.cursor()
        try:
            cur.execute(sql)
        except:
            return -1
        return 1

    def consulta(self, sql):
        try:
            conn = psycopg2.connect("dbname='mamelines' user='mamelines' password='mame'")
        except:
            print "No se puede conectar"

        cur = conn.cursor()
        try:
            cur.execute(sql)
        except:
            print "no puedo hacer la consulta"
        rows = cur.fetchall()
        conn.close()
        cur.close()
        return rows

class Avion:
    conn = Conexion()
    
    rows = conn.consulta("select * from avions;")
    for row in rows:
        print row[0]
        
    print conn.actualiza("insert into avion")
