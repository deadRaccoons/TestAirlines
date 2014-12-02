# -*- coding: utf-8 -*-
from administrador.models.Conexion import *

__all__ = ['Administrador']

class Administrador(object):

    def __init__(self, correo, nombres, apellidos):
        self.correo = correo
        self.nombres = nombres
        self.apellidos = apellidos
        self.c = Conexion()

    def crea(self):
        return self.c.actualizar("insert into administrador values ('"+ self.correo +"', '"+ self.nombres +"', '"+ self.apellidos +"');")

    def borra(self):
        return self.c.actualizar("delete from logins where correo = '"+ self.correo +"';")

    def actualiza(self, correo, secreto, activo):
        c.actualizar("update administrador set nombres = '"+ self.nombres +"', apellidos = '"+ self.apellidos +"' where correo = '"+ self.correo +"';")
        
    @staticmethod
    def getByCorreo(correo):
        c = Conexion()
        a = c.consultar("select * from administrador where correo = '"+ correo +"';")
        return Administrador(a[0][0], a[0][1], a[0][2])

    @staticmethod
    def all_():
        c = Conexion()
        todos = []
        for resultado in c.consultar("select * from administrador"):
            todos.append(Administrador(resultado[0][0], resultado[0][1], resultado[0][2]))
        return todos


todos = Administrador.all_()
print todos
