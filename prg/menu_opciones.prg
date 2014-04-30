process iniciar_menu_opciones()

private

	int id_txt_opcion;
	int id_txt_valor;

	string txt_opcion;
	string txt_valor;

	int total = 2;
	int opcion_actual = 0;
	int valor_actual = 0;

	int key_lock;

end

begin

	put_screen(fpg_system, 31);
	
	loop

		// vuelvo al menu principal
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = menu;
			break;
		end

		// cambio de opciones
		if ( jkeys_state[ _JKEY_UP ] and not key_lock  )
			key_lock = true;
			opcion_actual--;
			if (opcion_actual < 0)
				opcion_actual = total;
			end
		end

		if ( jkeys_state[ _JKEY_DOWN ] and not key_lock  )
			key_lock = true;
			opcion_actual++;
			if (opcion_actual > total)
				opcion_actual = 0;
			end
		end

		if ( not jkeys_state[ _JKEY_UP ] and not jkeys_state[ _JKEY_DOWN ] )
			key_lock = false;
		end

		switch ( opcion_actual )

			// fullscreen
			case 0:
				txt_opcion = "Pantalla Completa";
				if ( valor_actual )
					txt_valor = "Si";
				else
					txt_valor = "No";
				end
			end

			case 1:
				txt_opcion = "Graficos";
			end

			case 2:
				txt_opcion = "Escalado";
			end

		end

		id_txt_opcion = write( 0, 160, 130, 4, txt_opcion );
		id_txt_valor = write( 0, 160, 140, 4, txt_valor );

		frame;

		delete_text (id_txt_opcion);
		delete_text (id_txt_valor);

	end

end
