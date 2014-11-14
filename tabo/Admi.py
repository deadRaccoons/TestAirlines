import string
import cherrypy

class Administrador(object):
    
    @cherrypy.expose
    def index(self):
        return "Hello world"

    @cherrypy.expose
    def admi(self):
        return "Aqui va la pagina del administrador"
        
    @cherrypy.expose
    def promociones(self):
        return "Aqui se manejaran las promociones"

    @cherrypy.expose
    def estadisticas(self):
        return "Aqui se pondra todo lo de las estadisticas"

    @cherrypy.expose
    def vuelos(self):
        return "vuelos lalalala"
        
    @cherrypy.expose
    def aviones(self):
        return "avionazo"

        
if __name__ == '__main__':
    cherrypy.quickstart(Administrador())
