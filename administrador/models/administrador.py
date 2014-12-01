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
        if self.us is None:
            return file('login.html')
        else:
            raise cherrypy.HTTPRedirect("index")

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
                    raise cherrypy.HTTPRedirect("index")
                else:
                    raise cherrypy.HTTPRedirect("login")

    @cherrypy.expose
    def index(self):
        if self.us is None:
            raise cherrypy.HTTPRedirect("login")
        admin = Administrador.getAdministrador(cherrypy.session[SESSION_KEY])
        html = env.get_template('index.html')
        return html.render(admin = "Hola que hace?")
                    
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
