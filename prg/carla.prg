process carla(x,y);

private

	// parametros
	saltoh_altura = 9;
	saltov_altura = 13;

	// comprobaciones
	color;
	salto_posible = true;
	sobre_suelo;

	// animaciones
	aux;
	frame_actual = 0;

	anim_reposo_arr=08;
	anim_reposo_aba=09;
	anim_reposo_ade=01;

	anim_disparo_aba=119;

	anim_camina_arr[]=30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,  41;
	anim_camina_aba[]=50,  51,  52,  53,  54,  53,  52,  51;
	anim_camina_ade[]=10,  11,  12,  13,  14,  15,  16,  17,  18,  19,  20,  21;

	anim_saltoh_arr[]=130, 131, 132, 133;
	anim_saltoh_aba[]=65,  66,  67,  68; /* *** */
	anim_saltoh_ade[]=135, 136, 137, 138;

	anim_saltov_arr[]=70,  71,  72,  73;
	anim_saltov_aba[]=65,  66,  67,  68;
	anim_saltov_ade[]=75,  76,  77,  78;

	// cantidad de movimiento
	velocidad_x;
	velocidad_y;

	invencible = true;			// si respawneo recien
	invencible_contador = 0;	// tiempo que lleva invencible


END

BEGIN

	file = fpg_carla;
	graph = 2;

	ctype = c_scroll;
	cnumber = c_0;

	scroll[0].camera = id;

	LOOP

		// DETECTA EL SUELO
		color = map_get_pixel(fpg_nivel,1,x,y);
		IF ( color == SUELO1 OR color == SUELO2 ) // si toca suelo

			IF (velocidad_y >= 0)	// (y no esta subiendo en un salto)
				// lo apoya en el suelo
				SOBRE_SUELO = TRUE;
				velocidad_y = 0;
			END

		ELSE	// si no toca suelo
			SOBRE_SUELO = FALSE;
			velocidad_y += gravedad;
		END


/* -------------------------------------------------------------------------- */

		// ESTADOS
		IF ( SOBRE_SUELO )

			// CAMINA IZQUIERDA
			IF ( jkeys_state[_JKEY_LEFT] AND NOT jkeys_state[_JKEY_RIGHT] )

				CARLA_DIR = DIR_IZQ;
				CARLA_EST = EST_CAMINA;

				velocidad_x = -3;

			// CAMINA DERECHA
			ELSEIF ( jkeys_state[_JKEY_RIGHT] AND NOT jkeys_state[_JKEY_LEFT] )

				CARLA_DIR = DIR_DER;
				CARLA_EST = EST_CAMINA;

				velocidad_x = 3;

			// REPOSO
			ELSEIF ( NOT jkeys_state[_JKEY_RIGHT] AND NOT jkeys_state[_JKEY_LEFT] )

				CARLA_EST = EST_REPOSO;
				velocidad_x = 0;

			END

			// salto chongo
			IF  ( jkeys_state[_JKEY_X] AND SALTO_POSIBLE)
				salto_posible = FALSE;

				IF ( CARLA_EST == EST_CAMINA )
					CARLA_EST = EST_SALTOH;
					velocidad_y = -saltoh_altura;
				ELSE
					CARLA_EST = EST_SALTOV;
					velocidad_y = -saltov_altura;
				END
			END

			IF ( SALTO_POSIBLE == FALSE AND NOT jkeys_state[_JKEY_X] )
				salto_posible = TRUE;
			END


		// SOBRE_SUELO = FALSE
		ELSE

			IF ( CARLA_EST == EST_CAMINA)
				CARLA_EST = EST_SALTOH;
			END

			// DIRECCION
			IF ( jkeys_state[_JKEY_LEFT] AND NOT jkeys_state[_JKEY_RIGHT] )
				CARLA_DIR = DIR_IZQ;

				IF ( CARLA_EST == EST_SALTOV )
					velocidad_x = -2;
				ELSE
					IF (velocidad_x  > -3 )
						velocidad_x --;
					END
				END

			ELSEIF ( jkeys_state[_JKEY_RIGHT] AND NOT jkeys_state[_JKEY_LEFT] )
				CARLA_DIR = DIR_DER;

				IF ( CARLA_EST == EST_SALTOV )
					velocidad_x = 2;
				ELSE
					IF ( velocidad_x  < 3 )
						velocidad_x ++;
					END
				END
			ELSEIF ( NOT jkeys_state[_JKEY_LEFT] AND NOT jkeys_state[_JKEY_RIGHT] )
				IF ( CARLA_EST == EST_SALTOV )
					velocidad_x = 0;
				END
			END
		END

		// VARIANTES
		IF ( jkeys_state[_JKEY_UP] AND NOT jkeys_state[_JKEY_DOWN] )
			CARLA_VAR = VAR_ARR;
		ELSEIF ( jkeys_state[_JKEY_DOWN] AND NOT jkeys_state[_JKEY_UP] )
			CARLA_VAR = VAR_ABA;

			// si esta agachado camina mas lento
			IF ( CARLA_EST == EST_CAMINA )
				IF (CARLA_DIR == DIR_DER)
					velocidad_x = 2;
				ELSE
					velocidad_x = -2;
				END
			END

		ELSEIF ( NOT jkeys_state[_JKEY_UP] AND NOT jkeys_state[_JKEY_DOWN] )
			CARLA_VAR = VAR_ADE;
		END


/* -------------------------------------------------------------------------- */
//			danoS DE CARLA
/* -------------------------------------------------------------------------- */

		invencible_contador++;

		IF ( carla_hit )

			carla_hit = false;

			IF ( !invencible )

				invencible = true;
				invencible_contador = 0;
				partida.salud-= 10;

				if ( partida.salud <= 0 )

					// muerte de carla
					carla_muriendo = true;
					carla_muerte(x,y);
					break;

				end

			end

		END

		if ( invencible_contador > 30 and invencible )
			invencible = false;
		end

		if ( invencible and (invencible_contador+1) % 4)
			alpha = 64;
		else
			alpha = 256;
		end
/* -------------------------------------------------------------------------- */


		// ANIMACIONES
		SWITCH ( CARLA_EST )
			CASE EST_REPOSO:
				SWITCH ( CARLA_VAR )
					CASE VAR_ARR:
						graph = anim_reposo_arr;
					END

					CASE VAR_ABA:
						if ( carla_disparando )
							graph = anim_disparo_aba;
						else
							graph = anim_reposo_aba;
						end
					END

					CASE VAR_ADE:
						graph = anim_reposo_ade;
					END
				END
			END

			CASE EST_CAMINA:

				IF (frame_actual > 11)
					frame_actual = 0;
				END

				SWITCH ( CARLA_VAR )
					CASE VAR_ARR:
						graph = anim_camina_arr[frame_actual];
					END

					CASE VAR_ABA:
						IF ( frame_actual >= 8 ) frame_actual = 0; END
						graph = anim_camina_aba[frame_actual];
					END

					CASE VAR_ADE:
						graph = anim_camina_ade[frame_actual];
					END
				END
			END

			CASE EST_SALTOH:

				IF (frame_actual > 12)
					frame_actual = 0;
				END

				SWITCH ( CARLA_VAR )
					CASE VAR_ARR:
						graph = anim_saltoh_arr[frame_actual /4];
					END

					CASE VAR_ABA:
						graph = anim_saltoh_aba[frame_actual /4];
					END

					CASE VAR_ADE:
						graph = anim_saltoh_ade[frame_actual /4];
					END
				END
			END

			CASE EST_SALTOV:

				IF (frame_actual > 12)
					frame_actual = 0;
				END

				SWITCH ( CARLA_VAR )
					CASE VAR_ARR:
						graph = anim_saltov_arr[frame_actual /4];
					END

					CASE VAR_ABA:
						graph = anim_saltov_aba[frame_actual /4];
					END

					CASE VAR_ADE:
						graph = anim_saltov_ade[frame_actual /4];
					END
				END
			END
		END

		// ESPEJADO
		IF (CARLA_DIR==DIR_IZQ)
			flags = 1;
		ELSE
			flags = 0;
		END

		// aumenta la animacion a la mitad del framerate
		aux++;
		IF (aux > 1)
			aux = 0;
			frame_actual++;
		END


/* -------------------------------------------------------------------------- */

		// MOVIMIENTO
		MOVER(X, Y, velocidad_x, velocidad_y, &X, &Y);	// llama a la funcion mover y actualiza la posicion

		// ACTUALIZA LAS VARIABLES GLOBALES
		CARLA_POSX = X;
		CARLA_POSY = Y;


/* -------------------------------------------------------------------------- */


		// Actualiza la coordenada por donde se dispara
		get_point(fpg_carla, graph, 1, &CARLA_DISPAROX, &CARLA_DISPAROY );
		get_point(fpg_carla, graph, 0, &CARLA_AUXX, &CARLA_AUXY );

		CARLA_DISPAROX = CARLA_AUXX - CARLA_DISPAROX;
		CARLA_DISPAROY = CARLA_AUXY - CARLA_DISPAROY;

		if ( carla_dir == DIR_DER )
			CARLA_DISPAROX = CARLA_DISPAROX * -1;
		end


		if ( carla_var == VAR_ABA and carla_est == EST_REPOSO)
			if ( carla_dir == DIR_IZQ )
				CARLA_DISPAROX = -26;
			else
				CARLA_DISPAROX = 26;
			end

			CARLA_DISPAROY = 25;
		end

		FRAME;

	END
END

/* -------------------------------------------------------------------------- */

process carla_muerte(x,y);

private
	retraso;
	retraso_muerte;
end

begin
	file = fpg_carla;
	graph = 201;

	ctype = c_scroll;
	cnumber = c_0;

	loop
		retraso++;

		if ( retraso > 3 )
			retraso = 0;
			graph++;
		end


		if ( graph >= 203 )

			retraso_muerte++;

			if ( retraso_muerte > 90 )
				carla_muerta = true;
				break;
			else
				graph = 203;
			end
		end

		frame;
	end

end
