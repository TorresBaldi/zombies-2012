process iniciar_menu()

private
	int permitido;

	int menu_opciones_inicial = 1;
	int menu_opciones_total = 6;
end

begin

	put (fpg_system,1, 160, 120);

	opcion(1);
	opcion(2);
	opcion(3);
	opcion(4);
	opcion(5);
	opcion(6);

	// muestra la version
	write( 0, 318, 0, 2, "v" + game_version );

	// escribe el texto de ayuda
	text_scrollhelp_start();

	if ( os_id == OS_GP2X_WIZ)
		// write ( 0, 160, 230, 4, "[UP] and [Down] navigate  -  [SELECT] confirm");
		text_scrollhelp_update ( "[UP] and [Down] navigate  -  [SELECT] confirm" );
	else
		// write ( 0, 160, 230, 4, "[W] and [S] navigate  -  [ENTER] confirm");
		text_scrollhelp_update ( "Use [W] and [S] navigate, [ENTER] to confirm" );
	end

	loop

		// intercambia las opciones del menu
		if ( jkeys_state[_JKEY_UP] and permitido > 5);
			permitido = 0;

			menu_seleccion--;

			if (menu_seleccion < menu_opciones_inicial) menu_seleccion = menu_opciones_inicial; end
		end
		if ( jkeys_state[_JKEY_DOWN] and permitido > 5);
			permitido = 0;

			menu_seleccion++;

			if (menu_seleccion > menu_opciones_total) menu_seleccion = menu_opciones_total; end
		end
		permitido++;

/* -------------------------------------------------------------------------- */
		// reacciona de acuerdo a la seleccion
		if ( jkeys_state[_JKEY_SELECT] or jkeys_state[_JKEY_B] )

			aviso_cargando();

			frame;

			switch (menu_seleccion)
/* -------------------------------------------------------------------------- */
				// "start game"
				case 1:
					opcion_iniciar_juego();	// juego.prg
				end
/* -------------------------------------------------------------------------- */
				// "continue game"
				case 2:
					opcion_cargar_juego();	// juego.prg
				end
/* -------------------------------------------------------------------------- */
				// "options"
				case 3:
					nivel_cambio = true;
					nivel = opciones;

				end
/* -------------------------------------------------------------------------- */
				// "help"
				case 4:
					nivel_cambio = true;
					nivel = ayuda;

				end
/* -------------------------------------------------------------------------- */
				// "credits"
				case 5:
					nivel_cambio = true;
					nivel = creditos;

				end
/* -------------------------------------------------------------------------- */
				// "exit"
				case 6:
					exit();
				end
			end

			// terminada su funcion mata a sus hijos y sale de este proceso
			if (nivel_cambio)
				break;
			end

		end


		frame;

	end

end

process opcion(numero)
private
	diferencia;
	i;
	y_final;
	y_vel;

	alpha_final;
end
begin
	file = fpg_system;
	graph = numero+1;
	alpha = 127;
	x = 160;
	y = 140 + numero * 30;
	loop

		diferencia = menu_seleccion - numero;
		y_final = 140 - diferencia * 30;
		alpha_final = 255 - abs (diferencia) * 96;

		// cambia
		if ( y_final < y)
			y_vel+=3;
			for ( i=0; i <= y_vel; i++ )
				y--;
				if (y == y_final)break;end
			end
		elseif ( y_final > y )
			y_vel+=3;
			for ( i=0; i <= y_vel; i++ )
				y++;
				if (y == y_final)break;end
			end
		elseif ( y_final == y )
			y_vel = 0;
		end

		// cambia alfa
		if ( alpha_final > alpha)
			alpha += 16;
		elseif ( alpha_final < alpha )
			alpha -= 16;
		end

		// cambia size
		if ( menu_seleccion == numero )
			if (size < 100)
				size += 10;
			else
				size = 100;
			end
		else
			if ( size > 50 )
				size -= 10;
			else
				size = 50;
			end
		end

		// si se descarga el menu, termina el proceso
		if ( nivel_cargado[menu] == false )
			break;
		end

		frame;

	end
end


process aviso_cargando()
private
	vida = 3;
end
begin
	x = 2;
	y = 2;
	file = fpg_system;
	graph = 23;

	loop

		vida--;
		if ( vida < 0 )
			break;
		end

		frame;

	end

end

/* -------------------------------------------------------------------------- */

process text_scrollhelp_start()

private

	int string_changed;

end

begin

	define_region( 1, 0, 227, 320, 9 );

	text_scrollhelp_update("");

	loop

		scroll[2].x0 += 2;

		frame;

	end

end

/* -------------------------------------------------------------------------- */

function text_scrollhelp_update( string text)

private

	map_id;

end

begin

	map_id = write_in_map ( 0, text + "  -  ", 4);
	start_scroll ( 2, 0, map_id, 0, 1, 3);
	scroll[2].x0 = 0;

end


/* -------------------------------------------------------------------------- */

function text_scrollhelp_stop()

begin

	stop_scroll(2);
	signal( type text_scrollhelp_start, S_KILL );

end
