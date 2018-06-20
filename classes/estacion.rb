class Estacion
	attr_accessor :nombre
	attr_reader :id, :retiradas, :devueltas

	def initialize(nombre, retiradas=0, devueltas=0)
		@nombre = nombre 
		@retiradas = retiradas
		@devueltas = devueltas
	end

end