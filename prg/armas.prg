function inicializar_armas();

begin

	// propiedades de las armas
	armas[ARMA_PISTOLA].alcance = 200;
	armas[ARMA_PISTOLA].velocidad = 16;
	armas[ARMA_PISTOLA].dano = 30;
	armas[ARMA_PISTOLA].retraso_manual = 5;
	armas[ARMA_PISTOLA].retraso_auto = 0;
	armas[ARMA_PISTOLA].rafaga = 0;
	armas[ARMA_PISTOLA].autodisparo = false;

	armas[ARMA_UZI].alcance = 220;
	armas[ARMA_UZI].velocidad = 18;
	armas[ARMA_UZI].dano = 20;
	armas[ARMA_UZI].retraso_manual = 3;
	armas[ARMA_UZI].retraso_auto = 3;
	armas[ARMA_UZI].rafaga = 2;
	armas[ARMA_UZI].autodisparo = true;

	armas[ARMA_MINIGUN].alcance = 250;
	armas[ARMA_MINIGUN].velocidad = 20;
	armas[ARMA_MINIGUN].dano = 20;
	armas[ARMA_MINIGUN].retraso_manual = 2;
	armas[ARMA_MINIGUN].retraso_auto = 1;
	armas[ARMA_MINIGUN].rafaga = 3;
	armas[ARMA_MINIGUN].autodisparo = true;

	armas[ARMA_ESCOPETA].alcance = 150;
	armas[ARMA_ESCOPETA].velocidad = 15;
	armas[ARMA_ESCOPETA].dano = 20;
	armas[ARMA_ESCOPETA].retraso_manual = 20;
	armas[ARMA_ESCOPETA].retraso_auto = 0;
	armas[ARMA_ESCOPETA].rafaga = 0;
	armas[ARMA_ESCOPETA].autodisparo = false;

	armas[ARMA_MISIL].alcance = 400;
	armas[ARMA_MISIL].velocidad = 15;
	armas[ARMA_MISIL].dano = 100;
	armas[ARMA_MISIL].retraso_manual = 30;
	armas[ARMA_MISIL].retraso_auto = 0;
	armas[ARMA_MISIL].rafaga = 0;
	armas[ARMA_MISIL].autodisparo = false;

	armas[ARMA_COHETE].alcance = 400;
	armas[ARMA_COHETE].velocidad = 15;
	armas[ARMA_COHETE].dano = 50;
	armas[ARMA_COHETE].retraso_manual = 6;
	armas[ARMA_COHETE].retraso_auto = 0;
	armas[ARMA_COHETE].rafaga = 3;
	armas[ARMA_COHETE].autodisparo = false;

	armas[ARMA_LANZALLAMAS].alcance = 150;
	armas[ARMA_LANZALLAMAS].velocidad = 15;
	armas[ARMA_LANZALLAMAS].dano = 3;
	armas[ARMA_LANZALLAMAS].retraso_manual = 1;
	armas[ARMA_LANZALLAMAS].retraso_auto = 1;
	armas[ARMA_LANZALLAMAS].rafaga = 5;
	armas[ARMA_LANZALLAMAS].autodisparo = true;

end

/* -------------------------------------------------------------------------- */

process controlar_armas();
private
	// necesarias para cambio de arma
	cambio_permitido;

	disparo_x;
	disparo_y;

	// nuevas variables
	permitido;		// indica si se solto la tecla desde el ultimo disparo
	direccion;		// calcula la direccion a la que se tiene que disparar

	retraso_disparo;		// contador de la separacion entre cada rafaga
	retraso_rafaga;			// contador de la separacion entre los disparos de una misma rafaga

	quiere_disparar_rafaga;		// indica que quiere disparar rafaga
	esta_disparando_rafaga;		// indica si esta disparando la rafaga
	contador_rafaga;			//indica cuantos disparos hizo de la rafaga

	disparar;		// indica si tiene o no que crear los disparos
end
begin

	loop

		// control de cambios de armas
		if ( jkeys_state[_jkey_r] and cambio_permitido)
			cambio_permitido = false;
			cambiar_arma(0);

			quiere_disparar_rafaga = false;
			esta_disparando_rafaga = false;
			contador_rafaga = 0;

		elseif ( jkeys_state[_jkey_l] and cambio_permitido)
			cambio_permitido = false;
			cambiar_arma(1);

			quiere_disparar_rafaga = false;
			esta_disparando_rafaga = false;
			contador_rafaga = 0;

		end
		if ( not jkeys_state[_jkey_l] and not jkeys_state[_jkey_r] and cambio_permitido == false)
			cambio_permitido = true;
		end

		// controla los disparos en rafagas
		if ( armas[arma_actual].autodisparo )

			// si apreta el boton indica que quiere disparar la rafaga
			if ( jkeys_state[_jkey_a] and permitido)
				permitido = false;
				quiere_disparar_rafaga = true;
			end

			// si quiere disparar la rafaga, y paso el retraso entre rafagas, dispara la rafaga
			if ( quiere_disparar_rafaga and esta_disparando_rafaga == false and retraso_disparo >= armas[arma_actual].retraso_manual )
				esta_disparando_rafaga = true;
				quiere_disparar_rafaga = false;
				retraso_disparo = 0;
			end

			// si esta disparando rafaga, y paso el tiempo entre cada disparo
			if ( esta_disparando_rafaga and retraso_rafaga > armas[arma_actual].retraso_auto )

				// si todavia no termino de disparar la rafaga
				if ( contador_rafaga < armas[arma_actual].rafaga )
					contador_rafaga++;
					retraso_rafaga = 0;

					//da la orden de que dispare
					disparar = true;

					// y le avisa a carla que esta disparando
					carla_disparando = true;

				// si ya termino la rafaga
				else
					contador_rafaga = 0;
					esta_disparando_rafaga = false;
				end
			end

		// controla los disparos individuales
		else

			// si apreta el boton y paso el retraso indica que quiere disparar
			if ( jkeys_state[_jkey_a] and permitido and retraso_disparo > armas[arma_actual].retraso_manual )
				permitido = false;
				retraso_disparo = 0;

				// da la orden de que dispare
				disparar = true;

				// y le avisa a carla que esta disparando
				carla_disparando = true;
			end

		end


		// cancela los disparos si esta agachada+caminando o muerta
		if ( (carla_var == aba and carla_est == camina) or carla_muriendo)
			disparar = false;
			permitido = false;
			esta_disparando_rafaga = false;
			quiere_disparar_rafaga = false;
		end


		// y finalmente crea los disparos
		if ( disparar )
			disparar = false;

			// calcula la direccion del disparo
			direccion = direccion_disparo(carla_est,carla_var,carla_dir);

			// reproduce el sonido correspondiente
			play_wav(sfx_armas[arma_actual],0);

			// descuenta la municion si no es pistola
			if ( arma_actual <> ARMA_PISTOLA )
				partida.municion[arma_actual]--;
			end

			disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);

			// para la escopeta crea muchos
			if ( arma_actual == ARMA_ESCOPETA )
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
				disparo(carla_posx + carla_disparox, carla_posy - carla_disparoy, arma_actual, direccion);
			end
		end


		// aumenta el tiempo que paso entre los disparos
		retraso_disparo++;
		retraso_rafaga++;

		// luego de un rato, el grafico de carla deja de disparar
		if ( carla_disparando and retraso_disparo > 15 )
			carla_disparando = false;
		end


		// vuelve a permitir el disparo
		if ( not jkeys_state[_jkey_a] and permitido == false)
			permitido = true;
		end

		frame;

		// si se acaban las balas, cambia de arma
		if (partida.municion[arma_actual] <= 0)
			cambiar_arma(0);

			quiere_disparar_rafaga = false;
			esta_disparando_rafaga = false;
			contador_rafaga = 0;

		end
	end


end

/* -------------------------------------------------------------------------- */

process disparo (x, y , tipo, direccion)

public
	dano;
	p_x;
	p_y;
	p_direccion;
	p_tipo;
end

private
	// generales
	alcance;

	// misiles y cohetes
	velocidad_actual = 8;
	aceleracion = -3;
	original;
	variacion;

	destruido; 	// lo destruye en el proximo frame

	objetivo;	// id del proceso con el que colisiona

end

begin

	file = fpg_armas;

	ctype = c_scroll;
	cnumber = c_0;

	dano = armas[tipo].dano;
	graph = tipo+1;
	variacion = RAND(-4,4);

	if ( tipo == ARMA_ESCOPETA )
		variacion = rand(-15,15);
	end

	if ( tipo == ARMA_LANZALLAMAS )
		size = 20;
	end

	switch (direccion)
		case derecha:
			angle = 0 + variacion * 1000;
		end
		case arriba:
			angle = 90000 + variacion * 1000;
		end
		case izquierda:
			angle = 180000 + variacion * 1000;
		end
		case abajo:
			angle = 270000 + variacion * 1000;
		end
	end

	// inicializacion especial de acuerdo al tipo de arma
	switch ( tipo )
		case ARMA_COHETE, ARMA_MISIL:
			velocidad_actual = 8;
			aceleracion = -3;
			variacion = rand(-6,6);
			switch (direccion)
				case derecha:
					original = y;
				end
				case izquierda:
					original = y;
				end
				case arriba:
					original = x;
				end
				case abajo:
					original = x;
				end
			end
		end
	end

	loop

		frame;

		// comportamientos de acuerdo al tipo de arma y la direccion
		switch (tipo)

			// comportamiento general
			case ARMA_PISTOLA, ARMA_UZI, ARMA_MINIGUN, ARMA_ESCOPETA, ARMA_LANZALLAMAS:

				if ( tipo == ARMA_ESCOPETA )
					//caso especial escopeta
					advance(armas[tipo].velocidad + rand(-8,8));
					size -= 10;

				elseif ( tipo == ARMA_LANZALLAMAS )
					// caso especial lanzallamas
					size += 8;
					angle += rand(-6000,6000);
					if ( size > 70 )
						alpha -= 32;
					end
					advance(armas[tipo].velocidad);

				else
					//caso general
					advance(armas[tipo].velocidad);
				end

				alcance += armas[tipo].velocidad;

			end

			case ARMA_COHETE, ARMA_MISIL:

				// acelera
				if ( velocidad_actual <= armas[tipo].velocidad)
					velocidad_actual += aceleracion;
				end
				if (aceleracion <= 3)
					aceleracion++;
				end

				// avanza con variacion, por cada direccion
				switch (direccion)
					case derecha:
						x+= velocidad_actual;

						if ( (original+variacion) > y)
							y++;
						elseif ( (original+variacion) < y)
							y--;
						else
							variacion = rand(-6,6);
						end
					end

					case izquierda:
						x-= velocidad_actual;

						if ( (original+variacion) > y)
							y++;
						elseif ( (original+variacion) < y)
							y--;
						else
							variacion = rand(-6,6);
						end
					end

					case arriba:
						y-= velocidad_actual;

						if ( (original+variacion) > x)
							x++;
						elseif ( (original+variacion) < x)
							x--;
						else
							variacion = rand(-6,6);
						end
					end

					case abajo:
						y+= velocidad_actual;

						if ( (original+variacion) > x)
							x++;
						elseif ( (original+variacion) < x)
							x--;
						else
							variacion = rand(-6,6);
						end
					end

				end

				alcance += velocidad_actual;

			end

		end

		//destruye el misil al pasar el alcance
		if ( alcance > armas[tipo].alcance)
			signal(id,S_KILL);
		end

		// al chocar con zombie atualiza las variables publicas
		if ( collision (type zombie) )

			p_x = x;
			p_Y = y;
			p_direccion = direccion;
			p_tipo = tipo;
			// el zombie destruye el misil

			if ( tipo == ARMA_COHETE or tipo == ARMA_MISIL)
				misil_explosion(x,y,direccion,tipo);
			end

		end

		// si el frame anterior toco algo, lo destruye
		if ( destruido )
			signal(id,S_KILL_TREE);
		end

	end
end

/* -------------------------------------------------------------------------- */

process misil_explosion(x, y, direccion, tipo)
begin
	file = fpg_armas;
	graph = 30;

	ctype = c_scroll;
	cnumber = c_0;

	switch (direccion)
		case arriba:
			angle = 0;
		end
		case izquierda:
			angle = 90000;
		end
		case abajo:
			angle = 180000;
		end
		case derecha:
			angle = 270000;
		end
	end

	if (tipo == ARMA_MISIL )
		size = 150;
	else
		size = 100;
	end

	loop
		angle += rand(-50000, 50000);
		alpha -= 32;

		if ( alpha < 0 )
			break;
		end

		frame;

		graph++;

		if ( graph > 33 )
			graph = 32;
		end
	end
end


/* -------------------------------------------------------------------------- */

process controlar_granadas();
private

	posible;
	retraso;
end
begin
	loop
		if ( jkeys_state[_jkey_b] and posible and retraso > 10 and partida.granadas > 0)
			posible = false;
			retraso = 0;
			partida.granadas--;
			granada(carla_posx,carla_posy);
		end

		if (not jkeys_state[_jkey_b] and posible == false)
			posible = true;
		end

		retraso++;
		frame;
	end
end

/* -------------------------------------------------------------------------- */

process granada(x,y);
private
	velocidad_x;
	velocidad_y;
	i;
	vida = 40;
end
begin
	file = fpg_armas;
	graph = 25;

	ctype = c_scroll;
	cnumber = c_0;

	velocidad_x = 8;
	velocidad_y = -12;

	if ( carla_dir == izq )
		velocidad_x = velocidad_x * -1;
	end

	loop
		velocidad_y += gravedad;
		angle -= 15000;
		x += velocidad_x;

		if (velocidad_y > 0)
			for ( i = 0; i <= velocidad_y; i++ )

				if (map_get_pixel(fpg_nivel,1,x,y+i) == suelo1 )
					velocidad_y = (velocidad_y * 0.7) * -1;
					break;
				else
					y++;
				end

			end
		else
			y += velocidad_y;
		end

		vida--;

		if (map_get_pixel(fpg_nivel,1,x,y+i) == suelo1);
			i = 0;
			while (map_get_pixel(fpg_nivel,1,x,y - i) == suelo1 )
				y--;
				i++;
			end
		end

		if ( vida < 0 or collision (type zombie) )
			granada_explosion(x,y);
			play_wav(sfx_granada, 0);
			signal (id, S_SLEEP);
		end
		frame;
	end
end

process granada_explosion(x,y);
private
	tiempo = 0;
end
begin
	file = fpg_armas;
	graph = 30;
	size = 200;

	ctype = c_scroll;
	cnumber = c_0;

	loop
		tiempo++;

		if ( tiempo < 15 )
			if ( tiempo == 2 )
				graph = 31;
			end
			if ( tiempo > 2)
				graph = rand ( 32,33 );
				angle += rand (-10000,-30000);
			end
		else
			signal ( father, S_KILL_TREE );
			break;
		end

		frame;
	end
end

