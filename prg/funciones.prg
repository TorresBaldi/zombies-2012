function mover (x, y, vel_x, vel_y, pointer resultado_x, pointer resultado_y)

private

	int signo_x;
	int escalon;
	int i;
	int color;

end

begin
	// horizontal
	if ( vel_x <> 0 )

		signo_x = abs(vel_x) / vel_x;

		for ( i = 0; i<= abs(vel_x); i++)

			escalon = 0;

			color = map_get_pixel(fpg_nivel,1,x+(i*signo_x),y-(escalon+1));
			while ( color == suelo1 or color == suelo2 )
				// mientras haya suelo aumenta el escalon
				escalon++;
				color = map_get_pixel(fpg_nivel,1,x+(i*signo_x),y-(escalon+1));
			end

			if (escalon < 5)
				// si el escalon es menor a 5, se mueve
				y -= escalon;
				x += i * signo_x;
			else
				// si hay escalon grande, termina el movimiento
				break;
			end
		end
	end

	// vertical
	if ( vel_y > 0 )
		// hacia abajo detecta suelo
		for ( i = 0; i <= vel_y; i++ )

			color = map_get_pixel(fpg_nivel,1,x,y);
			if( color == suelo1 or color == suelo2 )
				break;
			else
				y++;
			end

		end

	elseif ( vel_y < 0)
		// hacia arriba detecta techo
		for ( i = 0; i <= abs(vel_y); i++ )
			if ( map_get_pixel(fpg_nivel,1,x,y-50) == techo )
				break;
			else
				y--;
			end
		end
	end



	// fix: si esta muy cerca del suelo, se apoya
	if (vel_y >= 0)
		for ( i=0; i <= 3; i++ )
			color = map_get_pixel(fpg_nivel,1,x,y+i);
			if ( color == suelo1 or color == suelo2 )
				y += i;
				break;
			end
		end
	end

	// devuelve el resultado
	*resultado_x = x;
	*resultado_y = y;
end


//
// Pregunta si el disparo choco con suelo o paredes
//
FUNCTION COMPROBAR_DUREZA_DISPARO(x,y);
PRIVATE
	HAY_DUREZA = FALSE;
END
BEGIN
	IF (map_get_pixel(fpg_nivel,1,x,y) == SUELO1)
		HAY_DUREZA = TRUE;
	END

	RETURN HAY_DUREZA;

END

//
// De acuerdo al estado del personaje, devuelve la direccion a la que debe salir la bala
//
FUNCTION DIRECCION_DISPARO(estado,variante,direccion)
PRIVATE
	result_dir;
END
BEGIN

	SWITCH ( variante )
		CASE VAR_ARR:
			result_dir = DISPARO_ARRIBA;
		END
		CASE VAR_ABA:
			IF ( estado == EST_CAMINA OR estado == EST_REPOSO )
				IF ( direccion == DIR_DER )
					result_dir = DISPARO_DERECHA;
				ELSE
					result_dir = DISPARO_IZQUIERDA;
				END
			ELSE
				result_dir = DISPARO_ABAJO;
			END
		END
		CASE VAR_ADE:
			IF ( direccion == DIR_DER )
				result_dir = DISPARO_DERECHA;
			ELSE
				result_dir = DISPARO_IZQUIERDA;
			END
		END
	END
	RETURN result_dir;
END

// Comprobar la colision del disparo con el suelo
FUNCTION DISPARO_COMPROBAR_DUREZA(x, y, direccion, velocidad);
PRIVATE
	i;
END
BEGIN
	SWITCH (DIRECCION)
		CASE DISPARO_ARRIBA:
		END
		CASE DISPARO_ABAJO:
		END
		CASE DISPARO_IZQUIERDA:
		END
		CASE DISPARO_DERECHA:
		END
	END
END

// cambiar de arma al presionar el gatillo o quedarse sin balas
function cambiar_arma(dir)
begin
	// si no tiene balas la "desactiva"
	if (partida.municion[arma_actual] <= 0 )
		partida.armas[arma_actual] = false;
	end

	// circula hasta la proxima arma disponible
	if (dir)
		repeat
			arma_actual--;
			if ( arma_actual < 0 )
				arma_actual = 6;
			end
		until ( partida.armas[arma_actual] == true )
	else
		repeat
			arma_actual++;
			if ( arma_actual > 6 )
				arma_actual = 0;
			end
		until ( partida.armas[arma_actual] == true )
	end

end
