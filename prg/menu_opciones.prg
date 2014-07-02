function iniciar_opciones()

begin

	partida.option[opc_fullscreen].min_value = 0;
	partida.option[opc_fullscreen].max_value = 1;
	partida.option[opc_fullscreen].value = 0;
	partida.option[opc_fullscreen].show_on_pc = 1;
	partida.option[opc_fullscreen].show_on_wiz = 0;

	partida.option[opc_scale].min_value = 1;
	partida.option[opc_scale].max_value = 3;
	partida.option[opc_scale].value = 2;
	partida.option[opc_scale].show_on_pc = 1;
	partida.option[opc_scale].show_on_wiz = 0;

	partida.option[opc_quality].min_value = 1;
	partida.option[opc_quality].max_value = 3;
	partida.option[opc_quality].value = 3;
	partida.option[opc_quality].show_on_pc = 1;
	partida.option[opc_quality].show_on_wiz = 1;

	partida.option[opc_volmaster].min_value = 0;
	partida.option[opc_volmaster].max_value = 100;
	partida.option[opc_volmaster].value = 100;
	partida.option[opc_volmaster].show_on_pc = 1;
	partida.option[opc_volmaster].show_on_wiz = 1;

	partida.option[opc_volsfx].min_value = 0;
	partida.option[opc_volsfx].max_value = 100;
	partida.option[opc_volsfx].value = 50;
	partida.option[opc_volsfx].show_on_pc = 1;
	partida.option[opc_volsfx].show_on_wiz = 1;

	partida.option[opc_volbgm].min_value = 0;
	partida.option[opc_volbgm].max_value = 100;
	partida.option[opc_volbgm].value = 25;
	partida.option[opc_volbgm].show_on_pc = 1;
	partida.option[opc_volbgm].show_on_wiz = 1;


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

	put_screen(fpg_system, 31);

	text_scrollhelp_start();
	
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

			help_updated = false;

			opcion_actual = prev_option( opcion_actual );
			valor_actual = partida.option[opcion_actual].value;

		end

		if ( jkeys_state[ _JKEY_DOWN ] and not key_lock  )
			key_lock = true;

			help_updated = false;

			opcion_actual = next_option( opcion_actual );
			valor_actual = partida.option[opcion_actual].value;

		end

		if ( jkeys_state[ _JKEY_LEFT ] and not key_lock2  )
			key_lock2 = true;

			if ( valor_actual > partida.option[opcion_actual].min_value )
				valor_actual--;
			end

		end

		if ( jkeys_state[ _JKEY_RIGHT ] and not key_lock2  )
			key_lock2 = true;

			if ( valor_actual < partida.option[opcion_actual].max_value )
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
			case opc_fullscreen:

				txt_opcion = "Pantalla Completa";
				txt_help = "Muestra el juego en pantalla completa";

				if ( valor_actual )
					txt_valor = "Activada";
				else
					txt_valor = "Desactivada";
				end


			end

			case opc_scale:

				txt_opcion = "Escalado";
				txt_help = "Escalado completo de pantalla";

				if ( valor_actual == 1 )
					txt_valor = "1X";
				elif( valor_actual == 2 )
					txt_valor = "2X";
				else
					txt_valor = "3X";
				end

			end

			case opc_quality:

				txt_opcion = "Calidad Graficos";
				txt_help = "Calidad de graficos y explosiones. Puede mejorar el rendimiento";

				if ( valor_actual == 1 )
					txt_valor = "Baja";
				elif( valor_actual == 2 )
					txt_valor = "Media";
				else
					txt_valor = "Alta";
				end

			end

			case opc_volmaster:
				txt_opcion = "Volumen MASTER";
				txt_help = "Volumen general";
				txt_valor = valor_actual + " %";
				key_lock2 = false;
			end

			case opc_volsfx:
				txt_opcion = "Volumen SFX";
				txt_help = "Volumen sonidos efectos";
				txt_valor = valor_actual + " %";
				key_lock2 = false;
			end

			case opc_volbgm:
				txt_opcion = "Volumen BGM";
				txt_help = "Volumen musica";
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

	repeat
		actual_option++;
		if (actual_option >= opc_last ) actual_option = 0; end
	until ( partida.option[actual_option].show_on_pc )

	return actual_option;

end


function prev_option( int actual_option )

begin

	repeat
		actual_option--;
		if (actual_option < 0 ) actual_option = opc_last -1; end
	until ( partida.option[actual_option].show_on_pc )

	return actual_option;

end
