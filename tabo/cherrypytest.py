#Estas lineas de codigo sirven para que la aplicacion en cherrypy corra en apache.
#Obviamente, esto aun no compila.
 import cherrypy

class NombreClase:
	@cherrypy.expose
	def metodo(self, myparam):
		return "hola mundo"
 #dentro de la/s clase/s usamos @cherrypy.expose, esto 
 #hace que el metodo sea visible para cuando la pasemos a la URL 

 cherrypy.config.update(conf)
    cherrypy.tree.mount(NombreClase(), script_name='/direcciondemame', config=app_conf)
    cherrypy.engine.start()
    cherrypy.engine.block()

#Definimos las variables
conf = {
    'global': {
        'server.socket_host': '127.0.0.1',
        'server.socket_port': 9091,
    },
}

app_conf = {
    '/style.css': {
        'tools.staticfile.on': True,
        'tools.staticfile.filename': os.path.join(_curdir,
        '/mydeploydir/css/style.css'),
    }
}

#Con esto podremos hacer peticiones desde: 
#http:// 127.0.0.1:9091/mamelines/metodo?myparam=eead

