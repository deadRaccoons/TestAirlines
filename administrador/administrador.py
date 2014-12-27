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
            c = cherrypy.session[SESSION_KEY]
        except:
            cherrypy.session[SESSION_KEY] = None
            c = None
        if c is None:
            return file('views/login.html')
        else:
            raise cherrypy.HTTPRedirect("index")

    @cherrypy.expose
    def do_login(self, correo=None, secreto=None):
        if cherrypy.session[SESSION_KEY] is not None:
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
                    raise cherrypy.HTTPRedirect("index")
                else:
                    raise cherrypy.HTTPRedirect("login")

    @cherrypy.expose
    def index(self):
        if cherrypy.session[SESSION_KEY] is None:
            raise cherrypy.HTTPRedirect("login")
        admin = Administrador.getAdministrador(cherrypy.session[SESSION_KEY])
        if admin is None:
            raise cherrypy.HTTPRedirect("salir")
        html = env.get_template('index.html')
        return html.render(admin = admin.nombres)
                    
    @cherrypy.expose
    def salir(self):
        if cherrypy.session[SESSION_KEY] is None:
            raise cherrypy.HTTPRedirect("login")
        else:
            username = cherrypy.session[SESSION_KEY]
            cherrypy.session[SESSION_KEY] = None
            if username:
                raise cherrypy.HTTPRedirect("login")

    @cherrypy.expose
    def registro(self):
        return file('views/registro.html')
        
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
    def creaviaje(self,visibilidad="hidden",tipo="",mesage=""):
        try:
            c = cherrypy.session[SESSION_KEY]
        except:
            cherrypy.session[SESSION_KEY] = None
            c = None
        if c is None:
            return file('views/login.html')
        else:
            ciudads = Ciudad.all_()
            avions = Avion.all_()
            html = env.get_template("viaje.html")
            return html.render(ciudades=ciudads, aviones=avions, mensage=mesage, visibilidad=visibilidad, tipo=tipo, crea="active", cancelar="hidden")
            
    @cherrypy.expose
    def viajecreado(self, origen, destino, anio, mes, dia, hora, minuto, distancia, idavion):
        m = int(mes)+1
        viaje = None
        if(m<10):
            viaje = Viaje(None, origen, destino, anio +"-0"+ str(m) +"-"+ dia, hora +":"+minuto, None, None, distancia, None, None, None, idavion)
        else:
            viaje = Viaje(None, origen, destino, anio +"-"+ str(m) +"-"+ dia, hora +":"+minuto, None, None, distancia, None, None, None, idavion)
        n = viaje.crea()
        if(n == 1):
            return self.creaviaje("", "success","Se creo el viaje")
        return self.creaviaje("", "warning", "No se pudo crear el viaje")

    @cherrypy.expose
    def aviones(self):
        try:
            c = cherrypy.session[SESSION_KEY]
        except:
            cherrypy.session[SESSION_KEY] = None
            c = None
        if c is None:
            return file('views/login.html')
        else:
            avions = Avion.all_()
            html = env.get_template('avion.html')
            return html.render(aviones = avions)

    @cherrypy.expose
    def cancelaviaje(self):
        try:
            c = cherrypy.session[SESSION_KEY]
        except:
            cherrypy.session[SESSION_KEY] = None
            c = None
        if c is None:
            return file('views/login.html')
        else:
            viajesc = Viaje.cancelables()
            html = env.get_template('viaje.html')
            return html.render(cancela="active", crear="hidden", visibilidad="hidden", viajes=viajesc)

    @cherrypy.expose
    def viajecancelado(self, seleccionados):
        cuerpo = "los viajes a cancelar son "
        for sel in seleccionados:
            cuerpo = cuerpo + " "+ str(sel)
        return cuerpo
        

if __name__ == '__main__':
    cherrypy.quickstart(Admin(), "" ,"app.conf")
