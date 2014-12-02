import psycopg2
class Conexion:

    def consultar(self, sql):
        try:
            conn = psycopg2.connect("dbname='mamelines' user='mamelines' password='mame'")
        except:
            print "No se puede conectar"

        cur = conn.cursor()
        try:
            cur.execute(sql)
            rows = cur.fetchall()
        except:
            print "no puedo hacer la consulta"
            rows = None
        finally:
            try:
                conn.close()
                cur.close()
            except:
                print "no se puede desconectar consulta"
        if(len(rows) == 0):
            rows = None
        return rows

    def actualizar(self, sql):
        n = 1
        try:
            conn = psycopg2.connect("dbname='mamelines' user='mamelines' password='mame'")
        except:
            print "no se puede conectar"
        
        try:
            cur = conn.cursor()
            cur.execute(sql)
            conn.commit()
        except psycopg2.DatabaseError, e:
            print e.pgcode
            print e.pgerror
            n = -1
        finally :
            try:
                conn.close()
                cur.close()
            except:
                print "no se puede desconectar actualiza"
        return n
