# -*- coding: utf-8 -*-
from models import *

class Avion(object):
    
    def __init__(self, idavion, modelo, marca, capacidadprimera, capacidadturista, disponible):
        self.idavion = idavion
        self.modelo = modelo
        self.marca = marca
        self.capacidadprimera = capacidadprimera
        self.capacidadturista = capacidadturista
        self.disponible = disponible
        self.c = Conexion()

    def crea(self):
        return self.c.actualizar("insert into avion values(null, '"+ self.modelo +"', '"+ self.marca +"', "+ str(self.capacidadprimera) +", "+ str(self.capacidadturista) +", 'n')")

    @staticmethod
    def all_():
        con = Conexion()
        todos = []
        for resultado in con.consultar("select * from avion"):
            r = list(resultado)
            todos.append(Avion(r[0], r[1], r[2], r[3], r[4], r[5]))
        return todos

    @staticmethod
    def disponibles(fecha, hora, lugar):
        con = Conexion()
        disponibles = []
        todos = con.consultar("select viaje.idavion from avion join viaje on avion.idavion = viaje.idavion where fechallegada <= '"+ fecha +"' and (select cast(horallegada as time) +'04:00:00') <= '"+ hora +"' and disponible = 'y' and destino = '"+ lugar +"' group by viaje.idavion having count(*) < 2")
        if todos is not None:
            for disponible in todos:
                a = lis(disponible)
                disponibles.append(Avion(a[0], a[1], a[2], a[3], a[4], a[5]))
            return disponibles
        else:
            return None
