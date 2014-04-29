process iniciar_menu()
private
	int permitido;
	int id_aviso_cargando;
end
begin

	put_screen (fpg_menu,1);
	
	opcion(1);
	opcion(2);
	opcion(3);
	opcion(4);
	opcion(5);
	
	// muestra la version
	write( 0, 318, 0, 2, "v" + game_version );

	// escribe el texto de ayuda
	if ( os_id == OS_GP2X_WIZ)
		write ( 0, 160, 230, 4, "[UP] and [Down] navigate  -  [SELECT] confirm");
	else
		write ( 0, 160, 230, 4, "[W] and [S] navigate  -  [ENTER] confirm");
	end
	
	loop
	
		// intercambia las opciones del menu
		if ( jkeys_state[_JKEY_UP] and permitido > 5);
			permitido = 0;
			
			menu_seleccion--;
			
			if (menu_seleccion < 1) menu_seleccion = 1; end
		end
		if ( jkeys_state[_JKEY_DOWN] and permitido > 5);
			permitido = 0;
			
			menu_seleccion++;
			
			if (menu_seleccion > 5) menu_seleccion = 5; end
		end
		permitido++;
		
/* -------------------------------------------------------------------------- */
		// reacciona de acuerdo a la seleccion
		if ( jkeys_state[_JKEY_SELECT] or jkeys_state[_JKEY_B] )
		
			id_aviso_cargando = aviso_cargando();
			
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
				// "help"
				case 3:
					nivel_cambio = true;
					nivel = ayuda;
					
				end
/* -------------------------------------------------------------------------- */
				// "credits"
				case 4:
					nivel_cambio = true;
					nivel = creditos;
					
				end
/* -------------------------------------------------------------------------- */
				// "exit"
				case 5:
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
	file = fpg_menu;
	graph = numero+1;
	alpha = 127;
	x = 160;
	y = 140 + numero * 30;
	loop
	
		diferencia = menu_seleccion - numero;
		y_final = 140 - diferencia * 20;
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
	file = fpg_sistema;
	graph = 3;
	
	loop
	
		vida--;
		if ( vida < 0 )
			break;
		end
		
		frame;
		
	end
	
end

