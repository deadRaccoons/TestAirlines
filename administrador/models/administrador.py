# -*- coding: utf-8 -*-
import cherrypy
import hashlib
from Conexion import *
from Administrador import *
from Login import *
from jinja2 import *

__all__ = ['Administrador']

SESSION_KEY = '_cp_username'

env = Environment(loader=FileSystemLoader('templates'))

class Admin(object):
    
    _cp_config = {'tools.sessions.on': True}

    def __init__(self):
        self.us = None

    @cherrypy.expose
    def login(self):
        try:
            c = self.us[SESSION_KEY]
            if c is not None:
                self.us = None
        except:
            self.us = None
        if self.us is None:
            return file('login.html')
        else:
            raise cherrypy.HTTPRedirect("index")

    @cherrypy.expose
    def do_login(self, correo=None, secreto=None):
        if self.us is not None:
            raise cherrypy.HTTPRedirect("index")
        elif correo is None or secreto is None:
            raise cherrypy.HTTPRedirect("login")
        else:
            login = Login.getLogin(correo)
            if login is None:
                raise cherrypy.HTTPRedirect("login")
            else:
                secret = hashlib.sha1()
                secret.update(secreto)
                if secret.hexdigest() == login.secreto:
                    cherrypy.session[SESSION_KEY] = cherrypy.request.login = correo
                    self.us = cherrypy.session
                    raise cherrypy.HTTPRedirect("index")
                else:
                    raise cherrypy.HTTPRedirect("login")

    @cherrypy.expose
    def index(self):
        if self.us is None:
            raise cherrypy.HTTPRedirect("login")
        admin = Administrador.getAdministrador(self.us[SESSION_KEY])
        if admin is None:
            raise cherrypy.HTTPRedirect("salir")
        html = env.get_template('index.html')
        return html.render(admin = admin.nombres)
                    
    @cherrypy.expose
    def salir(self):
        if self.us is None:
            raise cherrypy.HTTPRedirect("login")
        else:
            username = self.us.get(SESSION_KEY, None)
            self.us[SESSION_KEY] = None
            if username:
                self.us = None
                raise cherrypy.HTTPRedirect("login")

    @cherrypy.expose
    def registro(self):
        return file('registro.html')
        
    @cherrypy.expose
    def registrarse(self, nombres, apellidos, correo, secreto, secreto2):
        secret = hashlib.sha1()
        secret.update(secreto)
        login = Login(correo, secret.hexdigest())
        admin = Administrador(correo, nombres, apellidos)
        s = login.crea()
        if s == 1:
            d = admin.crea()
            if d == 1:
                cherrypy.session[SESSION_KEY] = cherrypy.request.login = correo
                self.us = cherrypy.session
                raise cherrypy.HTTPRedirect("index")
            else:
                admin.borra()
                login.borra()
                raise cherrypy.HTTPRedirect("registro")
        else:
            admin.borra()
            login.borra()
            raise cherrypy.HTTPRedirect("registro")
            
            

if __name__ == '__main__':
    cherrypy.quickstart(Admin())
