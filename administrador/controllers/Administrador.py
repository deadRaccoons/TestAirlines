# -*- coding: utf-8 -*-
from models import *

class Administrador(object):

    def __init__(self, correo, nombres, apellidos):
        self.correo = correo
        self.nombres = nombres
        self.apellidos = apellidos
        self.c = Conexion()

    def crea(self):
        return self.c.actualizar("insert into administrador values('"+ self.correo +"', '"+ self.nombres +"', '"+ self.apellidos +"')")

    def borra(self):
        return self.c.actualizar("delete from logins where correo = '"+ self.correo +"';")

    def actualiza(self, correo, secreto, activo):
        c.actualizar("update administrador set nombres = '"+ self.nombres +"', apellidos = '"+ self.apellidos +"' where correo = '"+ self.correo +"';")
        
    @staticmethod
    def getAdministrador(correo):
        if correo is None:
            return None
        else:
            c = Conexion()
            a = c.consultar("select * from administrador where correo = '"+ correo +"';")
            if a is not None:
                return Administrador(a[0][0], a[0][1], a[0][2])
            return a

    @staticmethod
    def all_():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from administrador"):
            r = list(resultado)
            todos.append(Administrador(r[0], r[1], r[2]))
        return todos

    @staticmethod
    def cambiovalor(valor):
        c = Conexion()
        try:
            r = c.actualizar("insert into valor values(null, "+ valor +", null, 'Dolar', 'Milla')")
        except:
            r = -1
        return r

    @staticmethod
    def valores():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from valor"):
            todos.append((resultado[0], resultado[1], str(resultado[2]), resultado[3], resultado[4]))
        return todos
            

    @staticmethod
    def estadoviajes():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select realizado, count(*) from viaje group by realizado"):
            todos.append((resultado[0], resultado[1]))
        return todos

    @staticmethod
    def cantidadvuelos():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select destino, count(*) from viaje group by destino order by destino asc"):
            todos.append((resultado[0], resultado[1]))
        return todos

    @staticmethod
    def vuelosdestino():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select destino, count(*) from viaje group by destino order by destino asc"):
            todos.append((resultado[0], resultado[1]))
        return todos

    @staticmethod
    def vuelosorigen():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select origen, count(*) from viaje group by origen order by origen asc"):
            todos.append((resultado[0], resultado[1]))
        return todos