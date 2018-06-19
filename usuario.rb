require 'yaml/store'

class Usuario
	attr_accessor :nombre, :apellido, :sexo, :edad
	attr_reader :idusuario, :fechacreacion

	def initialize(nombre, apellido, sexo="null", edad="null", fechacreacion="null")
		@nombre = nombre 
		@apellido = apellido
		@sexo = sexo 
		@edad = edad 
		@fechacreacion = fechacreacion

	end

	
	def crearusuario(objuser)

		@store = YAML::Store.new 'usuarios.yml'
		@store.transaction do 	
	    @store['usuarios'] ||= {}
        @store['usuarios'][@store['usuarios'].length] = objuser
    end

	end
end

class Metodousuario

		def modificarusuario(id, objuser)
		@store = YAML::Store.new 'usuarios.yml'
		@store.transaction do 	
	    @store['usuarios'] ||= {}
        @store['usuarios'][id] = objuser
    end
	end

	def traerusuario()
		@store = YAML::Store.new 'usuarios.yml'
		@usuarios = @store.transaction { @store['usuarios'] }
	end

	def traercantidad()

	end

end