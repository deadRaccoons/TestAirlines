from Conexion import *

class Login(object):    
    def __init__(self, correo, secreto):
        self.c = Conexion()
        self.correo = correo
        self.secreto = secreto

    def crea(self):
        c.actualiza("insert into logins values('%s', '%s')", self.correo, self.secreto)

    def borra(self):
        c.actualiza("delete from logins where correo = '%s'", self.correo)

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
