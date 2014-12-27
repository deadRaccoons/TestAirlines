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
    def disponibles():
        con = Conexion()
        con2 = Conexion()
        con3 = Conexion()
        con4 = Conexion()
        con5 = Conexion()
        disponibles = []
        todos = con.consultar("select ''||idavion, modelo, marca, ''||capacidadprimera, ''||capacidadturista, disponible from avion")
        if todos is not None:
            for disponible in todos:
                a = list(disponible)
                disponibles.append(Avion(a[0], a[1], a[2], [3], a[4], a[5]))
            todos = []
            for dis in disponibles:
                idavion = dis.idavion
                print str(idavion)
                try:
                    idviaje = con2.consultar("select idviaje from viaje where idavion = "+ str(idavion) +" order by fechallegada desc")[0][0]
                except:
                    idviaje = None
                if idviaje is None:
                    idviaje = 0
                try:
                    lugar = con3.consultar("select destino from viaje where idviaje = "+ str(idviaje))[0][0]
                except:
                    lugar = None
                if lugar is None:
                    lugar = "Nada"
                try:
                    hora = con4.consultar("select ''||horallegada::time without time zone from viaje where idviaje = "+ str(idviaje))[0][0]
                except:
                    hora = None
                if hora is None:
                    hora = "00:00"
                try:
                    fecha = con5.consultar("select ''||fechallegada from viaje where idviaje="+ str(idviaje))[0][0]
                except:
                    fecha = None
                if fecha is None:
                    fecha = "2014-12-14"
                todos.append((dis, lugar, fecha, hora))
            return todos
        else:
            return None

    @staticmethod
    def nousados():
        con = Conexion()
        disponibles = []
        todos = con.consultar("select * from avion where idavion not in (select idavion from viaje)")
        if todos is not None:
            for disponible in todos:
                a = list(disponible)
                disponibles.append(Avion(a[0], a[1], a[2], a[3], a[4], a[5]))
            return disponibles
        else:
            return None

    
    def ultimovuelo(self, idavion):
        c = Conexion()
        try:
            resultado = c.consultar("select idviaje from viaje where idavion = "+ str(idavion) +" order by fechallegada desc")[0][0]
        except:
            resultado = None
        return resultado