
require 'sinatra'
require './classes/estacion.rb'
require './classes/viaje.rb'
require './classes/usuario.rb'
require 'csv'
require './classes/metgenerales.rb'
require 'pill_chart'


get "/" do
	erb :home
end

get "/usuario/nuevo" do
	erb :usuarionew		
end

get "/usuario/modificar" do
	@objusuario = Metodo.new().traerentidad("usuarios")
	if !@objusuario.nil?
	erb :selectusuario
else
	@title="No hay usuarios cargados"
	erb :badnews
end
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
	if !@objestacion.nil?
	erb :selectstation
else
	@title="No hay estaciones cargadas"
	erb :badnews
end
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
	if !@objestacion.nil? && !@objusuario.nil?
	erb :viajenew
else
	@title="Favor de cargar primero usuarios y estaciones"
	erb :badnews
end
end

post "/viaje/nuevo" do
	rdate=params[:rdate]	
	rtime=params[:rtime]
	dret=params[:dret]
	dest=params[:dest]
	user=params[:user]
	dur=params[:duracion]
	rdate=Date.parse(rdate).strftime("%d/%m/%Y")
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
		    if dato["TIEMPO_USO"][2].to_s==""
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
	@objusuarios=Metodo.new().traerentidad("usuarios")
	if !@objviajes.nil? && !@objusuarios.nil?
	@objviajes = @objviajes.sort_by {|key, v| DateTime.strptime(v.fretiro+" "+v.hretiro, '%d/%m/%Y %H:%M')}.reverse!
	erb :ultimosviajes
else
	@title="No hay ningun viaje o usuario cargados"
	erb :badnews
	end
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

get "/reportes/efrd" do
	objmetodos=Metodo.new()
	fretiradas = {}
	objviajes=objmetodos.traerentidad("viajes")
	objestaciones=objmetodos.traerentidad("estaciones")
	if !objviajes.nil? && !objestaciones.nil?
	objviajes.each do |viaje|
		idestr=(viaje[1].estretiro).to_i
		idestd=(viaje[1].estdestino).to_i
		objestaciones[idestr].retiradas += 1
		objestaciones[idestd].devueltas += 1
		if fretiradas.has_key?(viaje[1].fretiro)
			fretiradas[viaje[1].fretiro]+=1
		else
			fretiradas[viaje[1].fretiro]=1
		end
	end
	@listaretiradas=objestaciones.sort_by {|key, v| v.retiradas}.reverse!
	@listadevueltas=objestaciones.sort_by {|key, v| v.devueltas}.reverse!
	@fecharetiradas=fretiradas.sort_by { |key, v| v }.reverse!

	erb :retiradasdevueltas
else
	@title="No hay ningun viaje o estacion cargados"
	erb :badnews
end
end

get "/reportes/estadisticas" do

	objmetodo=Metodo.new()
	objviajes=objmetodo.traerentidad("viajes")
	@objusuarios=objmetodo.traerentidad("usuarios")
	if objviajes.nil? || @objusuarios.nil?
		@title="No hay viajes o usuarios cargardos"
		erb :badnews
	else
		@userhash={}
		@hourlyhash={"first"=>0,"second"=>0,"third"=>0,"fourth"=>0,"fifth"=>0}
		@dailyhash={"Lunes"=>0, "Martes"=>0,"Miercoles"=>0,"Jueves"=>0,"Viernes"=>0,"Sabado"=>0,"Domingo"=>0}
		objviajes.each do |viaje|
			#Estadisticas Top 10 usuarios
			if @userhash.has_key?(viaje[1].iduser)
				@userhash[viaje[1].iduser] += 1
			else
				@userhash[viaje[1].iduser] = 1
			end

			#Estadistica Dia de la semana
			viaje[1].fretiro=Date.parse(viaje[1].fretiro)

			if viaje[1].fretiro.monday?
				@dailyhash["Lunes"]+=1
			elsif viaje[1].fretiro.tuesday?
				@dailyhash["Martes"]+=1
			elsif viaje[1].fretiro.wednesday?
				@dailyhash["Miercoles"]+=1
			elsif viaje[1].fretiro.thursday?
				@dailyhash["Jueves"]+=1
			elsif viaje[1].fretiro.friday?
				@dailyhash["Viernes"]+=1
			elsif viaje[1].fretiro.saturday?
				@dailyhash["Sabado"]+=1
			else
				@dailyhash["Domingo"]+=1
			end

			#Estadistica horario
			hour=viaje[1].hretiro.split(":")[0].to_i
 			
			if hour >= 0 && hour < 8
				@hourlyhash["first"]+=1
			elsif hour >= 8 && hour < 12
				@hourlyhash["second"]+=1
			elsif hour >= 12 && hour < 16
				@hourlyhash["third"]+=1
			elsif hour >= 16 && hour < 20
				@hourlyhash["fourth"]+=1
			else
				@hourlyhash["fifth"]+=1
			end

			
		end
		@userhash=@userhash.sort_by{|key, value| value}.reverse!
		@mayordaily=@dailyhash.sort_by{|key, value| value}.reverse![0][1]
		@mayorhourly=@hourlyhash.sort_by{|key, value| value}.reverse![0][1]

		erb :estadisticas
		end

end