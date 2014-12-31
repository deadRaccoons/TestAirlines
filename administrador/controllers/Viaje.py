
from models import *

class Viaje(object):

    def __init__(self, idviaje, origen, destino, fechasalida, horasalida, fechallegada, horallegada, distancia, tiempo, costoviaje, realizado, idavion):
        self.idviaje = idviaje
        self.origen = origen
        self.destino = destino
        self.fechasalida = fechasalida
        self.horasalida = horasalida
        self.fechallegada = fechallegada
        self.horallegada = horallegada
        self.distancia = distancia
        self.tiempo = tiempo
        self.costoviaje = costoviaje
        self.realizado = realizado
        self.idavion = idavion
        self.c = Conexion()

    def crea(self):
        return self.c.actualizar("insert into viaje values(null,'"+ self.origen +"', '"+ self.destino +"', '"+ self.fechasalida +"', '"+ self.horasalida +"', null, null, "+ str(self.distancia) +", null, null, null, "+ str(self.idavion) +")")

    @staticmethod
    def getViajes(fecha):
        if fecha is None:
            return None
        else:
            c = Conexion()
            viajes = c.consultar("select * from viaje where fechasalida = '"+ fecha +"' and realizado = 'y'")
            if viajes is not None:
                lv = []
                for viaje in viajes:
                    v = list(viaje)
                    lv.append(Viaje(v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10], v[11]))
                return lv
            return viajes
        
    @staticmethod
    def all_():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from viaje"):
            r = list(resultado)
            todos.append(Viaje(str(r[0]), r[1], r[2], str(r[3]), str(r[4]), str(r[5]), str(r[6]), str(r[7]), str(r[8]), str(r[9]), r[10], str(r[11])))
        return todos

    @staticmethod
    def cancelables():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from viaje where idviaje not in (select idviaje from cancelados) and realizado = 'n';"):
            r = list(resultado)
            todos.append(Viaje(r[0], r[1], r[2], str(r[3]), str(r[4]), str(r[5]), str(r[6]), r[7], r[8], r[9], r[10], r[11]))
        return todos

    @staticmethod
    def cancelar(idviaje):
        c = Conexion()
        con = Conexion()
        con.actualizar("update viaje set realizado = 'y' where idviaje = "+ str(idviaje))
        r = c.actualizar("ninsert into cancelados values("+ str(idviaje) +")")
        return r

    @staticmethod
    def cancelados():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from viaje where realizado = 'c' order by idviaje asc"):
            r = list(resultado)
            todos.append(Viaje(r[0], r[1], r[2], str(r[3]), str(r[4]), str(r[5]), str(r[6]), r[7], r[8], r[9], r[10], r[11]))
        return todos
        
    @staticmethod
    def proximos():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from viaje where realizado = 'n' order by idviaje asc"):
            r = list(resultado)
            todos.append(Viaje(r[0], r[1], r[2], str(r[3]), str(r[4]), str(r[5]), str(r[6]), r[7], r[8], r[9], r[10], r[11]))
        return todos

    @staticmethod
    def realizados():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from viaje where realizado = 'y' order by idviaje asc"):
            r = list(resultado)
            todos.append(Viaje(r[0], r[1], r[2], str(r[3]), str(r[4]), str(r[5]), str(r[6]), r[7], r[8], r[9], r[10], r[11]))
        return todos