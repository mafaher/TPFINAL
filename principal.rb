require 'sinatra'
require './classes/estacion.rb'
require './classes/viaje.rb'
require './classes/usuario.rb'
require 'csv'
require './classes/metgenerales.rb'


get "/" do
	erb :home
end

get "/usuario/nuevo" do
	erb :usuarionew		
end

get "/usuario/modificar" do
	@objusuario = Metodo.new().traerentidad("usuarios")

	erb :selectusuario
end

post "/usuario/modificar" do
	@id=params[:id].to_i
	@objusuarioA=Metodo.new().traerentidadporid(@id, 'usuarios')
	erb :modificarusuario
end

post "/usuario/modificar/:id" do
	nombre = params[:name]
	apellido = params[:surname]
	sexo=params[:sexo]
	edad=params[:edad]
	fcreacion=params[:fcreacion]
	@id=params[:id].to_i
	@objusuario=Usuario.new(nombre, apellido, sexo, edad, fcreacion)
	@some = Metodo.new().modificarentidad(@objusuario,@id, 'usuarios')
	@title="Usuario ha sido modificado exitosamente."
	erb :goodnews
end

get "/estacion/nuevo" do	
	erb :estacionnew
end

get "/estacion/modificar" do  
	@objestacion = Metodo.new().traerentidad("estaciones")
	erb :selectstation
end

post "/estacion/modificar" do
	@id=params[:id]
	@objestacionA=Metodo.new().traerentidadporid(@id, 'estaciones')
	erb :modificarestacion
end

post "/estacion/modificar/:id" do  
	@id=params[:id].to_i
	nombre=params[:name]
	@objestacion=Estacion.new(nombre)
	@some = Metodo.new().modificarentidad(@objestacion,@id, 'estaciones')
	@title="Estacion ha sido modificado exitosamente."
	erb :goodnews

end

get "/viaje/nuevo" do  
	@objestacion = Metodo.new().traerentidad("estaciones")
	@objusuario = Metodo.new().traerentidad("usuarios")
	erb :viajenew
end

get "/importar/:name" do 	
	@name=params[:name]
	erb :import
end

post "/importar/:name" do 

	file_data=params[:file][:tempfile].read
	@data=CSV.parse(file_data, headers: true, col_sep: ";").map(&:to_h)	
end

post "/usuario/nuevo" do 
	name=params[:name]
	apellido=params[:surname]
	sexo=params[:sexo]
	edad=params[:edad]
	t=Time.now
	fcreacion=t.day.to_s+"/"+t.month.to_s+"/"+t.year.to_s
	@usuario=Usuario.new(name, apellido, sexo, edad, fcreacion)
	@check=Metodo.new().crearentidad(@usuario, "usuarios");
	@title="Usuario ha sido creado satisfactoriamente."
	erb :goodnews
end

post "/estacion/nuevo"  do 
	name=params[:name]
	estacion=Estacion.new(name)
	@objmetodo=Metodo.new().crearentidad(estacion, "estaciones")
	@title="Estacion ha sido creada satisfactoriamente."
	erb :goodnews
end
