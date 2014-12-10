from Conexion import *

class Viaje(object):

    def __init__(self, idviaje, origen, destino, fechasalida, horasalida, fechallegada, horallegada, distancia, tiempo, costoviaje, realizado):
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
        self.c = Conexion()

    def crea(self):
        return self.c.actualizar("insert into viaje values(null,'"+ self.origen +"', '"+ self.destino +"', '"+ self.fechasalida +"', '"+ self.horasalida +"', null, null, "+ str(self.distancia) +", null, null, null)")

    @staticmethod
    def getViajes(fecha):
        if fecha is None:
            return None
        else:
            c = Conexion()
            viajes = c.consultar("select * from viaje where fechasalida = '"+  +"' and realizado = 'n'")
            if viajes is not None:
                lv = []
                for viaje in viajes:
                    lv.append(Viaje(c[0][0], c[0][1], c[0][2], c[0][3], c[0][4], c[0][5], c[0][6], c[0][7], c[0][8], c[0][9], c[0][10]))
                return lv
            return c
        
    @staticmethod
    def all_():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from viaje"):
            todos.append(Viaje(c[0][0], c[0][1], c[0][2], c[0][3], c[0][4], c[0][5], c[0][6], c[0][7], c[0][8], c[0][9], c[0][10]))
        return todos

viajes = Viaje.all_()
for viaje in viajes:
    print viaje
