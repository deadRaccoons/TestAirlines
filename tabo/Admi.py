from Conexion import *
import hashlib
import cherrypy

class Administrador(object):
    
    @cherrypy.expose
    def index(self):
        return """<html>
             <head></head>
             <body>
               <a href="aviones"> Aviones </a> </br>
               <a href="registrarse"> Registrarse </a>
             </body>
           </html> """

    @cherrypy.expose
    def registrarse(self):
        return """<html>
        <head></head>
        <body>
        <form action="createlogin">
          Nombres:
          <input type="text" name="nombre"><br>
          Apellidos:
          <input type="text" name="apellido"><br>
          Correo:
          <input type="text" name="correo"><br>
          Contrasena:
          <input type="text" name="secreto"><br>
          Confirma Contrasena:
              <button type="submit">Give it now!</button>
        </form>
        </body>
        </html>"""

    @cherrypy.expose
    def createlogin(self, nombre, apellido, correo, secreto):
        con = Conexion()
        secret = hashlib.sha1()
        secret.update(secreto)
        if con.actualiza("insert into logins values('"+correo+"', '"+secret.hexdigest()+"', 'y');") == 1 :
            if con.actualiza("insert into administrador values('"+correo+"', '"+nombre+"', '"+apellido+"');") == 1:
                return "se creo"
            return "no se creo"
        else:
            return "no se creo"

    @cherrypy.expose
    def login(self):
        return """<html>
        <head></head>
        <body>
        <form method="get" action="inicia">
          Correo:
          <input type="text" value="" name="correo"><br>
          Contrasena:
          <input type="text" value="" name="secreto"><br>
              <button type="submit">Give it now!</button>
        </form>
        </body>
        </html>"""
    
    @cherrypy.expose
    def inicia(self, correo, secreto):
        con = Conexion()
        secret = hashlib.sha1()
        secret.update(secreto)
        if(con.consulta("select secreto from logins where correo = '"+correo+"';")[0][0] is None):
            print "es vacio"
        if(con.consulta("select secreto from logins where correo = '"+correo+"';")[0][0] == secret.hexdigest()):
            return self.admin(correo)
        else:
            return self.login()
    
    @cherrypy.expose
    def admin(self, correo):
        con = Conexion()
        usuario = con.consulta("select * from administrador where correo = '"+ correo+ "';")
        return "Bienvenido "+ usuario[0][1]
    
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

    @cherrypy.expose
    def viajes(self):
        con = Conexion()
        cuerpo = """<html>
        <head>
          <script>
            function quita(){
              var x = document.getElementById("viaje_origen");
              var s = x.value;
              var y = "Todos menos seleccionado "+ x.value;
              for (i = 0; i < x.length; i++){
                y = y + "\n"+ x.options[i].text;
              }
              alert(y);
            }
          </script>
        </head>
        <body>
        <form method="post" action="createlogin">
          Origen:
          <select id="viaje_origen" name="origen" onchange="quita()">"""
        ciudades = con.consulta("select nombre from ciudads")
        for ciudad in ciudades:
            cuerpo = cuerpo + """<option value=\""""+ ciudad[0] +"""">"""+ ciudad[0]+"""</option>"""
        cuerpo = cuerpo + """</select><br>Destino: <select id="viaje_destino" name="destino">"""
        cuerpo = cuerpo + """</select></br> Fecha:<select id="viaje_anio" name="anio">
        <option value="2014">2014</option><option value="2015">2015</option></select>
        <select id="viaje_mes" name="mes">
        </select>
        <select id="viaje_dia" name="dia"></select></br>
        Hora Salida: <select id="viaje_hora" name="hora"></select>
        <select id="viaje_minuto" name="minuto"></select></br>
        Distancia<input id="viaje_distancia" type="text" name="distancia"/></br>
        Avion:<select id="viaje_avion" name="idavion">
        """
        aviones = con.consulta("select * from avion")
        for avion in aviones:
            cuerpo = cuerpo + """<option value""""+avion[0]+"""">"""+avion[1]+", capacidad "+str(avion[3]+avion[4])+"""</option>"""
        cuerpo = cuerpo + """</select></br><button type="submit">Crea Viaje</button>
        </form>
        </body>
        </html>"""
        return cuerpo

        
if __name__ == '__main__':
    cherrypy.quickstart(Administrador())
