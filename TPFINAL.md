# Modelado TP Final:


##  Clase usuario:
##### Propiedades:

* Id de usuario  - reader
* Nombre - r/w
* Apellido - r/w
* Sexo - r/w
* Edad - r/w
* Fecha de creacion - reader

##### Metodos: 
* Crear usuario()
* Modificar Usuario()
* Traer Usuario()

##   Clase Estacion: 
##### Propiedades:
* Id de estacion - reader
* Nombre de estacion - r/w
* Cantidad Bicis Retiradas - reader
* Cantidad Bicis Recibidas - reader

##### Metodos: 
* Crear Estacion()
* Modificar Estacion()
* Mostrar Estacion()
* Cantidad Devueltas > ()
* Cantidad Retiradas > ()

##  Clase Viaje: 
##### Propiedades:
* Fecha retiro (DD/MM/AAAA)
* Hora de Retiro (HH:MM)
* EstRetiro (Id) - r/w
* EstDestino (Id)- r/w
* TiempoUso  (HH:MM:SS) r/w
* Usuario (Id) - r/w

##### Metodos: 
* Crear Viaje()
* Mostrar ultimos diez() -> Formato tabla (Nom, Apellido, Fecha y horar de retiro y devolucion, Duracion del viaje)
* Fecha de retiro mayor()
* Traer cantidad por dia de semana()
* Traer Cantidad por horario ()
* Top 10 Usuario mayor uso()