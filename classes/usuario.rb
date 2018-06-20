
class Usuario
	attr_accessor :nombre, :apellido, :sexo, :edad
	attr_reader :idusuario, :fechacreacion

	def initialize(nombre="noname", apellido="nosurname", sexo="null", edad="null", fechacreacion="null")
		@nombre = nombre 
		@apellido = apellido
		@sexo = sexo 
		@edad = edad.to_i
		@fechacreacion = fechacreacion

	end

	

end

class Metodo

		def crearentidad(obj, entidad)

		@store = YAML::Store.new entidad+'.yml'
		@store.transaction do 	
		@store[entidad] ||={}
        @store[entidad][@store[entidad].length] = obj
    end

	end

		def modificarentidad(obj, id, entidad)
		@store = YAML::Store.new entidad+'.yml'
		@store.transaction do 	
        @store[entidad][id] = obj
    end
	end

	def traerentidad(entidad)
		@store = YAML::Store.new entidad+'.yml'
		@entity = @store.transaction { @store[entidad] }
	end

	def traerentidadporid(id, entidad)
		@store = YAML::Store.new entidad+'.yml'
		@entity = @store.transaction { @store[entidad][id.to_i] }

	end

	def traercantidad()

	end

end