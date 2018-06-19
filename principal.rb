require 'sinatra'
require './estacion.rb'
require './viaje.rb'
require './usuario.rb'
require 'csv'

get "/" do
	erb :home
end

get "/usuario/nuevo" do
	erb :usuarionew		
end

get "/usuario/modificar" do
	@objusuario = Metodousuario.new().traerusuario()
	erb :modificarusuario
end

get "/estacion/nuevo" do	
	erb :estacionnew
end

get "/estacion/modificar" do  
	erb :modificarestacion
end

get "/viaje/nuevo" do  
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
	@check=@usuario.crearusuario(@usuario);

end

post "/estacion/nuevo"  do 
	name=params[:name]
	@estacion=Estacion.new(name)

	erb :testingpar
end




