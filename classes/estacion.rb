class Estacion
	attr_accessor :nombre,:retiradas,:devueltas
	attr_reader :id

	def initialize(nombre, retiradas=0, devueltas=0)
		@nombre = nombre 
		@retiradas = retiradas
		@devueltas = devueltas
	end

end