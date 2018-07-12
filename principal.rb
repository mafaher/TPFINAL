
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

post "/viaje/nuevo" do
	rdate=params[:rdate]	
	rtime=params[:rtime]
	dret=params[:dret]
	dest=params[:dest]
	user=params[:user]
	dur=params[:duracion]
    @viaje=Viaje.new(rdate, rtime, dur, user, dest, dret)
    @check=Metodo.new().crearentidad(@viaje, "viajes");
    @title="Viaje ha sido creado satisfactoriamente."
    erb :goodnews
end

get "/importar/:name" do 	
	@name=params[:name]
	erb :import
end

post "/importar/:name" do 

	file_data=params[:file][:tempfile].read
	@data=CSV.parse(file_data, headers: true, col_sep: ";").map(&:to_h)	
	if params[:name]=="usuarios" && @data[0].has_key?("id")
		var=true
		@data.each do |dato|
			if dato["nombre"].to_s.empty?
				dato["nombre"] = " "	
			end
			if dato["apellido"].to_s.empty?
				dato["apellido"] = " "
			end
			usuario=Usuario.new(dato["nombre"],dato["apellido"])
			metodos=Metodo.new().modificarentidad(usuario,dato["id"].to_i,"usuarios")
		end
		@title="Carga de usuarios masiva, concluida satisfactoriamente"
	elsif params[:name]=="bicis" && @data[0].has_key?("NOMBRE_DESTINO")
		var=true
		@data.each do |dato|
			estaciondest=Estacion.new(dato["NOMBRE_DESTINO"])
			estacionor=Estacion.new(dato["NOMBRE_ORIGEN"])
		    dato["FECHA_HORA_RETIRO"]= dato["FECHA_HORA_RETIRO"].strip.split(/\s+/)
		    fretiro=dato["FECHA_HORA_RETIRO"][0]
		    hretiro=dato["FECHA_HORA_RETIRO"][1]
		    dato["TIEMPO_USO"]=dato["TIEMPO_USO"].gsub(/[H|MIN|SEG]/, '').strip.split(" ")
		    if dato["TIEMPO_USO"][2].to_s=="" || dato["TIEMPO_USO"][2].to_s== nil
		    	dato["TIEMPO_USO"][2]="00"
		    end
		    duracion=dato["TIEMPO_USO"][0].to_s+":"+dato["TIEMPO_USO"][1].to_s+":"+dato["TIEMPO_USO"][2].to_s
			viaje=Viaje.new(fretiro, hretiro, duracion, dato["ID_USUARIO"],dato["DESTINO_ESTACION"],dato["ORIGEN_ESTACION"])
			Metodo.new().modificarentidad(estaciondest,dato["DESTINO_ESTACION"].to_i,"estaciones")
			Metodo.new().modificarentidad(estacionor, dato["ORIGEN_ESTACION"].to_i,"estaciones")
			Metodo.new().crearentidad(viaje, "viajes");
		end
		@title="Carga de viajes y estaciones masiva, concluida satisfactoriamente"
	else
		var=false
		@title="El archivo indicado no es el correcto, favor de volver a intentarlo"
	end

	if var==true
		erb :goodnews
	else
		erb :badnews
	end

end


get "/reportes/viajesrecientes" do 
	@objviajes = Metodo.new().traerentidad("viajes")
	@objviajes = @objviajes.sort_by {|key, v| DateTime.strptime(v.fretiro+" "+v.hretiro, '%d/%m/%Y %H:%M')}.reverse! 
	@objusuarios=Metodo.new().traerentidad("usuarios")
	erb :testingpar
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
