# -*- coding: utf-8 -*-
#Esta es mi clase boleto, pero no se si este del todo bien, no se como quieren vender boletos, perdón por tardarme tanto, lo que se me ocurrio es
#cuando se crea un viaje, se hacen todos los boletos y vamos a distinguir cuales estan vendidos y cuales no, por el usuario, cuando no estan vendidos
#tienen un usuario 0 o null y cuando ya los vendemos solo agregamos la relación con el usuario. No se que tenian en mente igual diganme para corregir.
from models import *


class Boleto(object):

    def __init__(self, idboleto, idusuario, idViaje, clase, asiento,
                 fechasalida, horasalida, fechallegada, horallegada,
                 costototal):
        self.idboleto = idboleto
        self.idusuario = idusuario
        self.idViaje = idViaje
        self.clase = clase
        self.asiento = asiento
        self.fechasalida = fechasalida
        self.horasalida = horasalida
        self.fechallegada = fechallegada
        self.horallegada = horallegada
        self.costototal = costototal
        self.c = Conexion()

    def crea(self):
        return self.c.actualizar("insert into boleto values(null,'"+ str(self.idusuario)+ "','" + str(idViaje)+ "','"+ self.clase + "','" +str(self.asiento)+ "','" + self.fechasalida +"','" + self.horasalida +"', null, null, null" + ")")

    @staticmethod
    def vendeboleto(iduser, idbole):	
	return self.c.actualizar("update boletos set idusuario= iduser where idboleto = idbole")

    @staticmethod
    def boletosdisponibles(idviaje):
    	c = Conexion()
        disponibles=[]
        for resultado in  c.consultar("select * from boleto where idviaje = idviaje and idusuario = str(0)"):
            r = list(resultado)
        return r
   
    @staticmethod
    def creaboletos(idvi):
	c = Conexion()
	avion = c.consultar("select idavion from viaje where idviaje = idvi")
    	capa1 = c.consultar("select capacidadprimera from avion where idavion = avion")
	capa2 = c.consultar("select capacidadturista from avion where idavion = avion")
	capacidad = capa1 + capa2
	i = 1
	while i<=capacidad:
	    if i <= capa1:
	        self.c.actualizar("insert into boleto values(null,'"+ str(0)+ "','" + str(idvi)+ "','"+ "'Primera'" + "','" +str(i)+ "','" + self.fechasalida +"','" + self.horasalida +"', null, null, null" + ")")
 	    else:
		self.c.actualizar("insert into boleto values(null,'"+ str(0)+ "','" + str(idvi)+ "','"+ "'Turista'" + "','" +str(i)+ "','" + self.fechasalida +"','" + self.horasalida +"', null, null, null" + ")")

   
    
		
        
        
