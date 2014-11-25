from Conexion import *
import cherrypy

class Administrador(object):
    
    @cherrypy.expose
    def index(self):
        return """<html>
             <head></head>
             <body>
               <a href="aviones"> Aviones </a> </br>
               <a href="regitrarse"> Registrarse </a>
             </body>
           </html> """

    @cherrypy.expose
    def registrarse(self):
        return """<html>
        <head></head>
        <body>
        <form method="get" action="createlogin">
          Nombres:
          <input type="text" name="nombre" value="text"><br>
          Apellidos:
          <input type="text" name="apellido" value="text"><br>
          Correo:
          <input type="text" value="text" name="correo"><br>
          Contrasena:
          <input type="text" value="text" name="secreto"><br>
          Confirma Contrasena:
              <button type="submit">Give it now!</button>
        </form>
        </body>
        </html>"""

    @cherrypy.expose
    def createlogin(self, nombre, apellido, correo, secreto):
        con = Conexion()
        if con.actualiza("insert into logins values('"+correo+"', 'secreto', 'y');") == 1 :
            if con.actualiza("insert into administrador values('"+correo+"', '"+nombre+"', '"+apellido+"');") == 1:
                return "se creo"
            return "no se creo"
        else:
            return "no se creo"
        
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
        con = Conexion()
        cuerpo = """<html>
          <head></head>
        <body>"""
        
        aviones = con.consulta("select * from avion")
        for avion in aviones:
            cuerpo = cuerpo + avion[1] + " "+ avion [2]+"" + " </br>"

        cuerpo = cuerpo + """
        </body>
        </html>"""
        return cuerpo

        
if __name__ == '__main__':
    cherrypy.quickstart(Administrador())
