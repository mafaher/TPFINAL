require 'yaml/store'

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
		@store[entidad] ||={}
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
end