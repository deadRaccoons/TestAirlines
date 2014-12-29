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
        try:
            c = cherrypy.session[SESSION_KEY]
        except:
            cherrypy.session[SESSION_KEY] = None
            c = None
        if c is None:
            raise cherrypy.HTTPRedirect("login")
        admin = Administrador.getAdministrador(cherrypy.session[SESSION_KEY])
        if admin is None:
            raise cherrypy.HTTPRedirect("salir")
        html = env.get_template('index.html')
        return html.render(admin = admin.nombres, val="hidden", adm="active")
                    
    @cherrypy.expose
    def salir(self):
        try:
            c = cherrypy.session[SESSION_KEY]
        except:
            cherrypy.session[SESSION_KEY] = None
            c = None
        if c is None:
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
            todos = Avion.disponibles()
            html = env.get_template("viaje.html")
            return html.render(ciudades=ciudads, aviones=avions, mensage=mesage, visibilidad=visibilidad, tipo=tipo, crea="active", cancelar="hidden", todos=todos)
            
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
    def cancelaviaje(self, canc="hidden", tipocan="", mensaje=""):
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
            return html.render(cancela="active", crear="hidden", visibilidad="hidden", viajes=viajesc, canc=canc, tipocan=tipocan, mensaje=mensaje)

    @cherrypy.expose
    def viajecancelado(self, seleccionados):
        cuerpo = "los viajes a cancelar son "
        for sel in seleccionados:
            r = Viaje.cancelar(sel)
        return self.cancelaviaje("", "info","Se cancelaron los viajes")
        
    @cherrypy.expose
    def valores(self):
        try:
            c = cherrypy.session[SESSION_KEY]
        except:
            cherrypy.session[SESSION_KEY] = None
            c = None
        if c is None:
            raise cherrypy.HTTPRedirect("login")
        valors = Administrador.valores()
        html = env.get_template('index.html')
        return html.render(admin = "Inicio", valo="active", graf="hidden", msg="hidden", valores=valors, valors=valors)

    @cherrypy.expose
    def cambiavalor(self, costomilla):
        r = Administrador.cambiovalor("0."+ str(costomilla))
        html = env.get_template('index.html')
        valors = Administrador.valores()
        if (r == 1):
            return html.render(admin="Inicio", valores=valors, valo="active", graf="hidden", tipo="success", mensaje="Se actualizaron los datos", valors=valors)
        else:
            return html.render(admin="Inicio", valores=valors, valo="active", graf="hidden", tipo="warning", mensaje="No se actualizaron los datos", valors=valors)

    @cherrypy.expose
    def vuelos(self):
        html = env.get_template('vuelos.html')
        return html.render()

if __name__ == '__main__':
    cherrypy.quickstart(Admin(), "" ,"app.conf")
