# -*- coding: utf-8 -*-
from models import *

class Ciudad(object):

    def __init__(self, nombre, pais, distancia, descripcion, zonahora, aeropuerto, iata):
        self.nombre = nombre
        self.pais = pais
        self.distancia = distancia
        self.descripcion = descripcion
        self.zonahora = zonahora
        self.aeropuerto = aeropuerto
        self.iata = iata
        self.c = Conexion()

    def crea(self):
        return self.c.actualizar("insert into ciudad values('"+ self.nombre +"', '"+ self.pais +"', "+ self.distancia +", '"+ self.descripcion +"', '"+ self.zonahora +"', '"+ self.aeropuerto +"', '"+ self.iata +"')")

    @staticmethod
    def all_():
        con = Conexion()
        todos = []
        for resultado in con.consultar("select * from ciudad order by nombre asc"):
            c = list(resultado)
            todos.append(Ciudad(c[0], c[1], c[2], c[3], c[4], c[5], c[6]))
        return todos
