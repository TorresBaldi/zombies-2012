const
	
	//estados del zombie
	patrullando = 0;
	acercandose = 1;
	atacando_lejos = 2;
	atacando_cerca = 3;
	
end

/* -------------------------------------------------------------------------- */

process controlar_zombies()
// crea los zombies hasta que llegue a un cierto numero de muertes
private
	tiempo_respawn;
	contador_tiempo;
	
	punto;
	
	zombie_x;
	zombie_y;
end
begin
	
	switch ( nivel )
		case pantalla1:
			tiempo_respawn = 100;
		end
		case pantalla2:
			tiempo_respawn = 90;
		end
		case pantalla3:
			tiempo_respawn = 80;
		end
		case pantalla4:
			tiempo_respawn = 70;
		end
		case pantalla5:
			tiempo_respawn = 60;
		end
		case pantalla6:
			tiempo_respawn = 40;
		end
	end
	

	loop
	
		contador_tiempo++;
	
	
		if ( contador_tiempo > tiempo_respawn )
			contador_tiempo = 0;
			
			// obtiene un punto al azar
			punto = rand (1,10);
			point_get(fpg_nivel, 1, punto, &zombie_x, &zombie_y);
			
			// crea el zombie
			zombie(zombie_x,zombie_y);
		end
		
		// cada un cierto tiempo random crea un zombie en un punto de control
		frame;
	end
end


/* -------------------------------------------------------------------------- */


PROCESS Zombie(X, Y);

PRIVATE

	// comprueba si esta pisando suelo
	int sobre_suelo;
	
	// cantidad de movimiento
	int velocidad_x;
	int velocidad_y;
	
	int direccion; // direccion en la que mira el zombie	
	
	int salud = 100;
	
	//datos de los disparos
	disparo id_disparo;
	int ultimo_disparo;
	
	// animacion del zombie
	int animacion_frame;
	int animacion_retraso;
	
	//datos sobre el comportamiento
	int estado;
	int atacando;	// true o false, para las animaciones
	
	int distancia_carla;
	int direccion_carla;
	
	int direccion_patrulla = izquierda;
	int rango_patrulla = 150;
	int rango_patrulla_hecho = 0;
	
	// parametros
	int distancia_acercandose = 250;
	int distancia_atacando_lejos = 100;
	int distancia_atacando_cerca = 30;
	int retraso_disparos;
	
	int disparo_posx;
	int disparo_posy;
	int disparo_centroposx;
	int disparo_centroposy;
	int disparo_finalx;
	int disparo_finaly;
	
	// aparicion del zombie
	int apareciendo = true;
	
	int crear_arma;
	
	int random_muerte;
	
	
END

BEGIN

	file = FPG_Zombie;
	graph = 110;
	
	ctype = c_scroll;
	cnumber = c_0;
	
	apareciendo = true;
	
	crear_arma = rand (0,10);
	random_muerte  = rand (0,1);
	LOOP


	/* -------------------------------------------------------------------------- */
		if ( apareciendo )
			animacion_retraso++;
			
			if ( animacion_retraso > 2 )
				graph++;
				animacion_retraso = 0;
			end
			
			if ( graph > 116 )
				apareciendo = false;
				animacion_retraso = 0;
			end
		else

			
			// detecta los impactos de bala
			id_disparo = collision ( type disparo );
			if ( id_disparo )
				//crea sonido de dano
			end
			
			while ( id_disparo )
				// resta vida por cada impacto
				salud = salud - id_disparo.dano;
				partida.puntos += id_disparo.dano;

				// crea la explosion del cohete
				//if ( id_disparo.p_tipo == misil or id_disparo.p_tipo == cohete )
				//	misil_explosion(id_disparo.p_x, id_disparo.p_y);
				//end

				// guarda el ultimo impacto recibido
				ultimo_disparo = id_disparo.p_tipo;
				
				if ( ultimo_disparo <> lanzallamas )
					// si no es el lanzallamas desruye el proyectil
					signal(id_disparo, s_kill);
				end
				
				zombie_sangre(id_disparo.p_x, id_disparo.p_y, id_disparo.p_direccion);
				
				// busca el proximo disparo
				id_disparo = collision ( type disparo );
			end
			
			// detecta los impactos de explosiones
			if ( collision ( type granada_explosion ) or collision ( type misil_explosion ) )
				salud -= 100;
				ultimo_disparo = misil;
			end
				
			// si no tiene salud lo mata
			if ( salud <= 0 )
				
				// a veces crea un arma al azar
				if ( crear_arma > 9 )
					item_arma(x,y);
				end
			
				zombies_muertos++;
				
				signal(id, s_sleep);
				
				signal_action(id, s_freeze_tree, s_ign);
				signal_action(id, s_wakeup_tree, s_ign);
				
				// de acuerdo al ultimo disparo recibido
				switch (ultimo_disparo)
					case escopeta:
						zombie_muerte_escopeta(x,y, direccion);
					end
					
					case misil, cohete:
						zombie_muerte_explosion(x,y);
					end
					
					case lanzallamas:
						zombie_muerte_normal(x,y, direccion);
					end
					
					default:
						if ( random_muerte == 0 )
							zombie_muerte_normal(x,y, direccion);
						else
							zombie_muerte_headshot(x,y, direccion);
						end
					end
					
				end
			end


	/* -------------------------------------------------------------------------- */

			// detecta el suelo
			if ( 
			map_get_pixel(fpg_nivel,1,x,y) == suelo1 or
			map_get_pixel(fpg_nivel,1,x,y) == suelo2
			)	// si toca suelo
				if (velocidad_y >= 0)	// (y no esta subiendo en un salto)
					// lo apoya en el suelo
					sobre_suelo = true;
					velocidad_y = 0;	
				end
				
			else	// si no toca suelo
				sobre_suelo = false;
				velocidad_y += gravedad;
			end
			

	/* -------------------------------------------------------------------------- */

			// INTELIGENCIA
			
			
			// calcula la distancia hacia carla
			distancia_carla = abs(carla_posx - x);
			
			//calcula la direccion en la que esta carla
			if ( carla_posx-x > 0 )
				direccion_carla = derecha;
			else
				direccion_carla = izquierda;
			end
			
			//calcula el estado de acuerdo a la distancia
			if ( distancia_carla > distancia_acercandose )
				//si esta demasiado lejos continua con la patrulla
				estado = patrullando;
			else
				// si esta cerca, pregunta que tan cerca esta
				if ( distancia_carla < distancia_atacando_lejos )
					estado = atacando_lejos;
				else
					estado = acercandose;
				end
			end

	/* -------------------------------------------------------------------------- */

			// primero le da estos valores a la direccion, luego si es necesario, los cambia
			if ( direccion_carla == derecha ) direccion = derecha;
			else direccion = izquierda;	end
			
			// COMPORTAMIENTO DE LOS ESTADOS
			SWITCH ( estado )
				case patrullando:
					//si no termino la patrulla
					if ( rango_patrulla_hecho < rango_patrulla )
						rango_patrulla_hecho += 2;
						if ( direccion_patrulla == izquierda )
							velocidad_x = -2;
							direccion = izquierda;
						else
							velocidad_x = 2;
							direccion = derecha;
						end
					//si ya termino la patrulla, invierte el sentido	
					else
						rango_patrulla_hecho = 0;
						if ( direccion_patrulla == izquierda )
							direccion_patrulla = derecha;
							direccion = derecha;
						else
							direccion_patrulla = izquierda;
							direccion = izquierda;
						end
					end
				end
				
				case acercandose:
				
					if ( direccion_carla == derecha )
						velocidad_x = 2;
					else
						velocidad_x = -2;
					end
					
					retraso_disparos = 0;
					
				end
				
				case atacando_lejos:

					velocidad_x = 0;
					
					retraso_disparos++;
					
					if ( retraso_disparos == 20 )
						//zombie_disparo();
						atacando = true;
						animacion_frame = 0;
						//se vuelve a setear en false una vez terminada la animacion
					end
					
				end
				
				case atacando_cerca:
				
					velocidad_x = 0;
					
				end
			END

	/* -------------------------------------------------------------------------- */

			// ANIMACIONES
			animacion_retraso++;
			if ( animacion_retraso > 1 )
				animacion_frame++;
				animacion_retraso = 0;
			end
			
			switch ( estado )
				case acercandose, patrullando:
					if ( animacion_frame > 11 )
						animacion_frame = 0;
					end
					graph = 10 + animacion_frame;
				end
				
				case atacando_cerca:
					//repite constantemente la animacion de ataque
				end
				
				case atacando_lejos:
				
					if ( animacion_frame > 15 and atacando)
						animacion_frame = 0;
						atacando = false;
						retraso_disparos = 0;
					end
					// si esta atacando avanza la animacion,sino, se queda quieto
					if ( atacando )
						graph = 30 + animacion_frame;
						if ( graph == 38 and animacion_retraso == 0)
							
							// calcula el origen
							get_point (fpg_zombie, 38, 1, &disparo_posx, &disparo_posy);
							get_point (fpg_zombie, 38, 0, &disparo_centroposx, &disparo_centroposy);
							
							disparo_finalx = disparo_centroposx - disparo_posx;
							disparo_finaly = disparo_centroposy - disparo_posy;
							
							if ( direccion == izquierda )
								disparo_finalx = disparo_finalx;
							else
								disparo_finalx = disparo_finalx * -1;
							end

							//crea el disparo del zombie
							zombie_proyectil(x + disparo_finalx,y - disparo_finaly,direccion);
						end
					else
						graph = 1;
						animacion_retraso--;
					end
				end
			end
			
			if ( direccion == izquierda )
				flags = 1;
			else
				flags = 0;
			end
			

	/* -------------------------------------------------------------------------- */


			// Mueve el zombie
			MOVER(X, Y, velocidad_x, velocidad_y, &X, &Y);	

		end	// del if

		FRAME;
			
		
	END	// del loop
END

// impacto de bala sobre el zombie
process zombie_sangre(x,y,direccion);
begin
	file = fpg_zombie;
	ctype = c_scroll;
	cnumber = c_0;
	graph = 120;
	flags = 1;
	size = rand(100,200);
	switch (direccion)
		case derecha:
			angle = 0;
		end
		case abajo:
			angle = 90000;
		end
		case izquierda:
			angle = 180000;
			flags = 3;
		end
		case arriba:
			angle = 270000;
		end
	end
	
	loop
		graph++;
		
		if (graph > 129)
			break;
		end
		
		frame;
	end
end

process zombie_muerte_escopeta(x, y, direccion)
// del 90 al 108
private
	retraso_animacion;
	int desapareciendo;
end
begin
	file = fpg_zombie;
	graph = 90;
	ctype = c_scroll;
	cnumber = c_0;
	retraso_animacion = 0;
	z = father.z+1;
	if ( direccion == izquierda )
		flags = 1;
	end
	loop
		retraso_animacion++;
		if ( retraso_animacion > 1 )
			retraso_animacion = 0;
			graph++;
		end
		
		if ( graph > 108 )
			desapareciendo = true;
		end
		
		if ( desapareciendo )
			graph = 108;
			alpha -= 10;
			if ( alpha <= 0 )
				signal ( father, s_kill_tree );
			end
		end
		frame;
	end
end

process zombie_muerte_normal(x, y, direccion)
// del 50 al 65
private
	retraso_animacion;
	int desapareciendo;
end
begin
	file = fpg_zombie;
	graph = 50;
	ctype = c_scroll;
	cnumber = c_0;
	retraso_animacion = 0;
	z = father.z+1;
	if ( direccion == izquierda )
		flags = 1;
	end
	loop
		retraso_animacion++;
		if ( retraso_animacion > 1 )
			retraso_animacion = 0;
			graph++;
		end
		
		if ( graph > 65 )
			desapareciendo = true;
		end
		
		
		if ( desapareciendo )
			graph = 65;
			alpha -= 10;
			if ( alpha <= 0 )
				signal ( father, s_kill_tree );
			end
		end
		
		frame;
	end
end

process zombie_muerte_headshot(x, y, direccion)
// del 70 al 82
private
	retraso_animacion;
	desapareciendo;
end
begin
	file = fpg_zombie;
	graph = 70;
	ctype = c_scroll;
	cnumber = c_0;
	retraso_animacion = 0;
	z = father.z+1;
	if ( direccion == izquierda )
		flags = 1;
	end
	loop
		retraso_animacion++;
		if ( retraso_animacion > 1 )
			retraso_animacion = 0;
			graph++;
		end
		if ( graph > 82 )
			desapareciendo = true;
		end
		
		if ( desapareciendo )
			graph = 82;
			alpha -= 10;
			if ( alpha <= 0 )
				signal ( father, s_kill_tree );
			end
		end
		frame;
	end
end

process zombie_muerte_explosion(x,y);
private
	vida = 100;
end
begin
	zombie_parte(x,y,0);
	zombie_parte(x,y,2);
	zombie_parte(x,y,4);
	zombie_parte(x,y,6);
	zombie_parte(x,y,8);
	loop
		vida--;
		if (vida<0)
			signal (father,S_KILL_TREE);
		end
		
		frame;
	end
end

process zombie_parte(x,y,variante)
private
	velocidad_x;
	velocidad_y;
	i;
end
begin
	file = fpg_zombie;
	graph = 140 + variante;
	ctype = c_scroll;
	cnumber = c_0;
	
	velocidad_x = rand(-10,10);
	velocidad_y = rand(-10,10);
	angle = rand(0,270000);
	
	loop
	
		x += velocidad_x;
		velocidad_y += gravedad;

		if (velocidad_y > 0)
			for ( i = 0; i <= velocidad_y; i++ )
			
				if (map_get_pixel(fpg_nivel,1,x,y+i) == suelo1 )
					velocidad_y = (velocidad_y * 1) * -1;
					break;
				else
					y++;
				end
				
			end
		else
			y += velocidad_y;
		end

		if (map_get_pixel(fpg_nivel,1,x,y+i) == suelo1);
			i = 0;
			while (map_get_pixel(fpg_nivel,1,x,y - i) == suelo1 )
				y--;
				i++;
			end
		end
		
		graph = 140 + variante + rand(0,1);
		
		angle += rand ( 1000, 3000 );
		
		frame;
	end

end


// proyectil que dispara el zombie
process zombie_proyectil(x,y,direccion)
private
	velocidad_x;
	velocidad_y;
end
begin
	file = fpg_zombie;
	graph = rand(02,03);
	ctype = c_scroll;
	cnumber = c_0;
	angle = 45000;
	if ( direccion == derecha )
		velocidad_x = 6;
	else
		velocidad_x = -6;
		flags = 1;
	end
	
	velocidad_y = -3;
	
	LOOP
		
		velocidad_y += gravedad;
		y += velocidad_y;
		x += velocidad_x;
		
		angle -= 5000;
		
		if ( velocidad_y > 20)
			break;
		end
		
		// dano a carla
		if ( collision ( type carla ) )
			carla_hit = true;
			break;
		end
		
		frame;
	end
	
end
