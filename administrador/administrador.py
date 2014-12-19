# -*- coding: utf-8 -*-
import cherrypy
import hashlib
from models import *
from controllers import *
from jinja2 import *

__all__ = ['Administrador']

SESSION_KEY = '_cp_username'

env = Environment(loader=FileSystemLoader('views'))

class Admin(object):

    def __init__(self):
        self.us = None

    @cherrypy.expose
    def login(self):
        try:
            c = self.us[SESSION_KEY]
        except:
            self.us = None
        if self.us is None:
            return file('views/login.html')
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
        return file('views/registro.html')

    @cherrypy.expose
    def distancia(self):
        return file('views/distancia.html')
        
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

    @cherrypy.expose
    def creaviaje(self):
        ciudads = Ciudad.all_()
        avions = Avion.all_()
        html = env.get_template("nuevoviaje.html")
        return html.render(ciudades = ciudads, aviones = avions)
            
    @cherrypy.expose
    def viajecreado(self, origen, destino, anio, mes, dia, hora, minuto, distancia, idavion):
        v =  Viaje(None, origen, destino, str(anio)+"-"+ str(mes)+"-"+ str(dia), str(hora)+ ":"+ str(minuto), None, None, distancia, None, None, None, idavion)
        r = v.crea()
        if r == 1:
            return "Se creo"
        else:
            raise cherrypy.HTTPRedirect("creaviaje")
        

if __name__ == '__main__':
    cherrypy.quickstart(Admin(), "" ,"app.conf")
