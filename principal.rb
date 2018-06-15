require 'sinatra'
require './estacion.rb'
require './viaje.rb'
require './usuario.rb'

get "/" do
	erb :home
end

get "/usuario/nuevo" do
	erb :usuarionew		
end

get "/usuario/modificar" do
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

get "/importar/usuarios" do 	
	erb :importusers
end

get "/importar/bicis" do
	erb :importbicis
end