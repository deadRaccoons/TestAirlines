# -*- coding: utf-8 -*-
import cherrypy
import hashlib
from Conexion import *

__all__ = ['Administrador']

SESSION_KEY = '_cp_username'

class Administrador(object):
    
    _cp_config = {'tools.sessions.on': True}

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
    def getAdministrador(correo):
        if correo is None:
            return None
        else:
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
        


class Admin(object):
    
    _cp_config = {'tools.sessions.on': True}

    def __init__(self):
        self.us = None

    @cherrypy.expose
    def login(self):
        if self.us is None:
           return """<html>
              <head>
              </head>
              <body>
                <form method="post" action="do_login">
                  Correo:
                  <input type="text" value="" name="correo"><br>
                  Contrasena:
                  <input type="password" value="" name="secreto"><br>
                    <button type="submit">Give it now!</button>
                </form>
              </body>
            </html>"""
        else:
            raise cherrypy.HTTPRedirect("inicio")

    @cherrypy.expose
    def do_login(self, correo=None, secreto=None):
        if self.us is not None:
            raise cherrypy.HTTPRedirect("inicio")
        elif correo is None or secreto is None:
            cherrypy.session[SESSION_KEY] = None
            raise cherrypy.HTTPRedirect("login")
        else:
            login = Login.getLogin(correo)
            if login is None:
                raise cherrypy.HTTPRedirect("login")
            else:
                secret = hashlib.sha1()
                secret.update(secreto)
                if secret.hexdigest() == login.secreto:
                    cherrypy.session.regenerate()
                    cherrypy.session[SESSION_KEY] = cherrypy.request.login = correo
                    self.us = correo
                    raise cherrypy.HTTPRedirect("inicio")
                else:
                    raise cherrypy.HTTPRedirect("login")

    @cherrypy.expose
    def inicio(self):
        if self.us is None:
            raise cherrypy.HTTPRedirect("login")
        admin = Administrador.getAdministrador(cherrypy.session[SESSION_KEY])
        return """<html>
          <head>
          </head>
          <body>
            """+ admin.nombres +"""
            <a href="salir">Salir</a>
          </body>
        </html>"""
                    
    @cherrypy.expose
    def salir(self):
        if self.us is None:
            raise cherrypy.HTTPRedirect("login")
        else:
            self.us = None
            sess = cherrypy.session
            username = sess.get(SESSION_KEY, None)
            sess[SESSION_KEY] = None
            if username:
                cherrypy.request.login = None
                cherrypy.session[SESSION_KEY] = None
                raise cherrypy.HTTPRedirect("login")
            

if __name__ == '__main__':
    cherrypy.quickstart(Admin())
