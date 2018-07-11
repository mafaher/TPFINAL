
class Usuario
	attr_accessor :nombre, :apellido, :sexo, :edad
	attr_reader :idusuario, :fechacreacion

	def initialize(nombre="noname", apellido="nosurname", sexo="blank", edad="blank", fechacreacion="blank")
		@nombre = nombre 
		@apellido = apellido
		@sexo = sexo 
		@edad = edad.to_i
		@fechacreacion = fechacreacion
	end

	

end

