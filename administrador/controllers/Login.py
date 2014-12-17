# -*- coding: utf-8 -*-
from models import *

class Login(object):    
    def __init__(self, correo, secreto):
        self.c = Conexion()
        self.correo = correo
        self.secreto = secreto

    def crea(self):
        return self.c.actualizar("insert into logins values('"+ self.correo +"', '"+self.secreto +"', 'y');")

    def borra(self):
        return self.c.actualizar("delete from logins where correo = '"+ self.correo +"';")

    @staticmethod
    def getLogin(correo):
        if correo is None:
            return None
        else:
            c = Conexion()
            l = c.consultar("select * from logins where correo = '"+ correo +"'")
            if(l is not None):
                return Login(l[0][0], l[0][1])
            else:
                return None
