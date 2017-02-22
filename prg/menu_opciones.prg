function inicializar_opciones()

begin

	partida.opciones[OPC_FULLSCREEN].min_value = 0;
	partida.opciones[OPC_FULLSCREEN].max_value = 1;
	partida.opciones[OPC_FULLSCREEN].value = 0;
	partida.opciones[OPC_FULLSCREEN].show_on_pc = 0;
	partida.opciones[OPC_FULLSCREEN].show_on_wiz = 0;

	partida.opciones[OPC_SCALE].min_value = 1;
	partida.opciones[OPC_SCALE].max_value = 3;
	partida.opciones[OPC_SCALE].value = 2;
	partida.opciones[OPC_SCALE].show_on_pc = 0;
	partida.opciones[OPC_SCALE].show_on_wiz = 0;

	partida.opciones[OPC_QUALITY].min_value = 1;
	partida.opciones[OPC_QUALITY].max_value = 3;
	partida.opciones[OPC_QUALITY].value = 3;
	partida.opciones[OPC_QUALITY].show_on_pc = 1;
	partida.opciones[OPC_QUALITY].show_on_wiz = 1;

	partida.opciones[OPC_VOLMASTER].min_value = 0;
	partida.opciones[OPC_VOLMASTER].max_value = 100;
	partida.opciones[OPC_VOLMASTER].value = 100;
	partida.opciones[OPC_VOLMASTER].show_on_pc = 0;
	partida.opciones[OPC_VOLMASTER].show_on_wiz = 0;

	partida.opciones[OPC_VOLSFX].min_value = 0;
	partida.opciones[OPC_VOLSFX].max_value = 100;
	partida.opciones[OPC_VOLSFX].value = 50;
	partida.opciones[OPC_VOLSFX].show_on_pc = 1;
	partida.opciones[OPC_VOLSFX].show_on_wiz = 1;

	partida.opciones[OPC_VOLBGM].min_value = 0;
	partida.opciones[OPC_VOLBGM].max_value = 100;
	partida.opciones[OPC_VOLBGM].value = 25;
	partida.opciones[OPC_VOLBGM].show_on_pc = 1;
	partida.opciones[OPC_VOLBGM].show_on_wiz = 1;


end

process iniciar_menu_opciones()

private

	int key_lock;
	int key_lock2;
	int help_updated;

	int opcion_actual = 0;
	int valor_actual = 0;

	int id_txt_opcion;
	int id_txt_valor;

	string txt_opcion;
	string txt_valor;
	string txt_help;


end

begin

	put(fpg_system, 31, 160, 120);

	text_scrollhelp_start();

	opcion_actual = next_option( opcion_actual );

	loop

		// vuelvo al menu principal
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = NIVEL_MENU;
			break;
		end

		// cambio de opciones
		if ( jkeys_state[ _JKEY_UP ] and not key_lock  )
			key_lock = true;

			help_updated = false;

			opcion_actual = prev_option( opcion_actual );
			valor_actual = partida.opciones[opcion_actual].value;

		end

		if ( jkeys_state[ _JKEY_DOWN ] and not key_lock  )
			key_lock = true;

			help_updated = false;

			opcion_actual = next_option( opcion_actual );
			valor_actual = partida.opciones[opcion_actual].value;

		end

		if ( jkeys_state[ _JKEY_LEFT ] and not key_lock2  )
			key_lock2 = true;

			if ( valor_actual > partida.opciones[opcion_actual].min_value )
				valor_actual--;
			end

		end

		if ( jkeys_state[ _JKEY_RIGHT ] and not key_lock2  )
			key_lock2 = true;

			if ( valor_actual < partida.opciones[opcion_actual].max_value )
				valor_actual++;
			end

		end

		if ( not jkeys_state[ _JKEY_UP ] and not jkeys_state[ _JKEY_DOWN ])
			key_lock = false;
		end

		if ( not jkeys_state[ _JKEY_LEFT ] and not jkeys_state[ _JKEY_RIGHT ])
			key_lock2 = false;
		end

		switch ( opcion_actual )

			// fullscreen
			case OPC_FULLSCREEN:

				txt_opcion = "Fullscreen";
				txt_help = "Shows the game in fullscreen mode.";

				if ( valor_actual )
					txt_valor = "Enable";
				else
					txt_valor = "Disable";
				end


			end

			case OPC_SCALE:

				txt_opcion = "Scale Factor";
				txt_help = "Screen scale factor, only in windowed mode.";

				if ( valor_actual == 1 )
					txt_valor = "1X";
				elif( valor_actual == 2 )
					txt_valor = "2X";
				else
					txt_valor = "3X";
				end

			end

			case OPC_QUALITY:

				txt_opcion = "Graphics Quality";
				txt_help = "Graphics and explosions quality. Lower values can improve performance.";

				if ( valor_actual == 1 )
					txt_valor = "Low";
				elif( valor_actual == 2 )
					txt_valor = "Medium";
				else
					txt_valor = "High";
				end

			end

			case OPC_VOLMASTER:
				txt_opcion = "MASTER Volume";
				txt_help = "General volume.";
				txt_valor = valor_actual + " %";
				key_lock2 = false;
			end

			case OPC_VOLSFX:
				txt_opcion = "SFX Volume";
				txt_help = "Sound effects volume.";
				txt_valor = valor_actual + " %";
				key_lock2 = false;
			end

			case OPC_VOLBGM:
				txt_opcion = "BGM Volume";
				txt_help = "Background Music volume.";
				txt_valor = valor_actual + " %";
				key_lock2 = false;
			end

		end

		id_txt_opcion = write( 0, 160, 130, 4, txt_opcion );
		id_txt_valor = write( 0, 160, 140, 4, txt_valor );

		if (!help_updated)
			text_scrollhelp_update(txt_help);
			help_updated = true;
		end

		frame;

		delete_text (id_txt_opcion);
		delete_text (id_txt_valor);

	end

end

function next_option( int actual_option )

begin

	loop

		actual_option++;
		if (actual_option > OPC_LAST ) actual_option = 0; end

		// busco la siguiente opcion disponible en pc o wiz
		// TODO optimizar esto
		if ( partida.opciones[actual_option].show_on_pc && os_id <= OS_MACOS )
			break;
		end

		if ( partida.opciones[actual_option].show_on_wiz && os_id >= OS_GP2X_WIZ )
			break;
		end

	end

	return actual_option;

end


function prev_option( int actual_option )

begin

	loop
		actual_option--;
		if (actual_option < 0 ) actual_option = OPC_LAST; end

		if ( partida.opciones[actual_option].show_on_pc && os_id <= OS_MACOS )
			break;
		end

		if ( partida.opciones[actual_option].show_on_wiz && os_id >= OS_GP2X_WIZ )
			break;
		end

	end

	return actual_option;

end
