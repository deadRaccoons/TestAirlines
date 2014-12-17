
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
    def getViajes(fecha, hora):
        if fecha is None:
            return None
        else:
            c = Conexion()
            viajes = c.consultar("select * from viaje where fechasalida = '"+ fecha +"' and horasalida  = '"+ hora +"' and realizado = 'n'")
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
            todos.append(Viaje(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11]))
        return todos
