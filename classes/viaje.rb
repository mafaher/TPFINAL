class Viaje
	attr_accessor :fretiro, :tiempouso, :hretiro
	attr_reader :iduser, :estdestino, :estretiro

	def initialize (fretiro, hretiro, tiempouso, iduser, estdestino, estretiro)
		@fretiro = fretiro
		@hretiro= hretiro
		@tiempouso = tiempouso
		@iduser = iduser
		@estdestino = estdestino
		@estretiro = estretiro
	end

end