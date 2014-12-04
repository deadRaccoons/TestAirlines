from Conexion import *

class Avion(object):
    
    def __inti__(self, idavion, modelo, marca, capacidadprimera, capacidadturista, disponible=None):
        self.idavion = idavion
        self.marca = marca
        self.modelo = modelo
        self.capacidadprimera = capacidadprimera
        self.capacidadturista = capacidadturista
        self.disponible = disponible
        self.c = Conexion()
        
    def crea(self):
        return self.c.actualizar("insert into avion values(null, '"+ self.modelo +"', '"+ self.marca +"', "+ str(self.capacidadprimera) +", "+ str(self.capacidadturista) +"'"+ self.disponible +"');")
        
    def borra(self):
        return self.c("delete from avion where idavion = "+ str(self.idavion) +";")
