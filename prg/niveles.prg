/* -------------------------------------------------------------------------- */

function control_niveles();

begin

	loop

		if ( nivel_cambio == true )
			nivel_cambio = false;

			// descarga recursos anteriores
			descargar();

			switch ( nivel )

/* -------------------------------------------------------------------------- */

				case NIVEL_INTRO:

					// carga recursos actuales
					fpg_intro = load_fpg ("fpg/intro.fpg");

					// avisa que se cargo
					nivel_cargado[NIVEL_INTRO] = true;

					// inicia procesos
					play_song (bgm_intro, -1);
					iniciar_intro();

				end


/* -------------------------------------------------------------------------- */

				case NIVEL_MENU:
					// carga recursos actuales

					// avisa que se cargo
					nivel_cargado[NIVEL_MENU] = true;

					// inicia procesos
					efecto_fade();
					iniciar_menu();

					if ( not is_playing_song() )
						set_song_volume(0);
						play_song( bgm_intro, -1 );
						set_music_position(7.66);
						set_song_volume( volumen );
					end

				end


/* -------------------------------------------------------------------------- */

				case NIVEL_OPCIONES:
					// carga recursos actuales

					// avisa que se cargo
					nivel_cargado[NIVEL_OPCIONES] = true;

					// inicia procesos
					// muestra pantalla de opciones
					efecto_fade();
					iniciar_menu_opciones();
				end


/* -------------------------------------------------------------------------- */

				case NIVEL_AYUDA:
					// carga recursos actuales

					// avisa que se cargo
					nivel_cargado[NIVEL_AYUDA] = true;

					// inicia procesos
					efecto_fade();
					iniciar_menu_ayuda();
				end


/* -------------------------------------------------------------------------- */

				case NIVEL_CREDITOS:
					// carga recursos actuales

					// avisa que se cargo
					nivel_cargado[NIVEL_CREDITOS] = true;

					// inicia procesos
					efecto_fade();
					iniciar_menu_creditos();
				end


/* -------------------------------------------------------------------------- */

				case NIVEL_PANTALLA_1:
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa1.fpg");

					// avisa que se cargo
					nivel_cargado[NIVEL_PANTALLA_1] = true;

					// inicia procesos
					efecto_fade();
					iniciar_juego(100,180,1260,200,30);
				end


/* -------------------------------------------------------------------------- */

				case NIVEL_PANTALLA_2:
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa2.fpg");

					// avisa que se cargo
					nivel_cargado[NIVEL_PANTALLA_2] = true;

					// inicia procesos
					efecto_fade();
					iniciar_juego(175,36,10,515,40);
				end

/* -------------------------------------------------------------------------- */

				case NIVEL_PANTALLA_3:
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa3.fpg");

					// avisa que se cargo
					nivel_cargado[NIVEL_PANTALLA_3] = true;

					// inicia procesos
					efecto_fade();
					iniciar_juego(980,100,20,160,50);
				end

/* -------------------------------------------------------------------------- */

				case NIVEL_PANTALLA_4:
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa4.fpg");

					// avisa que se cargo
					nivel_cargado[NIVEL_PANTALLA_4] = true;

					// inicia procesos
					efecto_fade();
					iniciar_juego(995,155,10,330,60);
				end

/* -------------------------------------------------------------------------- */

				case NIVEL_PANTALLA_5:
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa5.fpg");

					// avisa que se cargo
					nivel_cargado[NIVEL_PANTALLA_5] = true;

					// inicia procesos
					efecto_fade();
					iniciar_juego(990,225,19,110,80);
				end

/* -------------------------------------------------------------------------- */

				case NIVEL_PANTALLA_6:
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa6.fpg");

					// avisa que se cargo
					nivel_cargado[NIVEL_PANTALLA_6] = true;

					// inicia procesos
					efecto_fade();
					iniciar_juego(1000,160,10,150,150);
				end

/* -------------------------------------------------------------------------- */

				case NIVEL_GAMEOVER:
					// carga recursos actuales
					//fpg_system = load_fpg ("fpg/system.fpg");

					// avisa que se cargo
					nivel_cargado[NIVEL_GAMEOVER] = true;

					// inicia procesos
					efecto_fade();
					iniciar_menu_gameover();
				end

			end

		end

		frame;

	end

end


/* -------------------------------------------------------------------------- */

// descarga todos los recursos cargados
function descargar();

begin

/* -------------------------------------------------------------------------- */

	// NIVEL_INTRO
	if ( nivel_cargado[NIVEL_INTRO] )
		unload_fpg(fpg_intro);
		nivel_cargado[NIVEL_INTRO] = false;
	end


/* -------------------------------------------------------------------------- */

	//menu
	if ( nivel_cargado[NIVEL_MENU] )
		text_scrollhelp_stop();
		nivel_cargado[NIVEL_MENU] = false;
	end


/* -------------------------------------------------------------------------- */

	//opciones
	if ( nivel_cargado[NIVEL_OPCIONES] )
		text_scrollhelp_stop();
		nivel_cargado[NIVEL_OPCIONES] = false;
	end


/* -------------------------------------------------------------------------- */

	//ayuda
	if ( nivel_cargado[NIVEL_AYUDA] )
		nivel_cargado[NIVEL_AYUDA] = false;
	end


/* -------------------------------------------------------------------------- */

	//creditos
	if ( nivel_cargado[NIVEL_CREDITOS] )
		nivel_cargado[NIVEL_CREDITOS] = false;
	end


/* -------------------------------------------------------------------------- */

	//pantalla 1
	if ( nivel_cargado[NIVEL_PANTALLA_1] )
		unload_song ( bgm_id );
		unload_fpg (fpg_nivel);
		stop_scroll(0);
		nivel_cargado[NIVEL_PANTALLA_1] = false;
	end


/* -------------------------------------------------------------------------- */

	//pantalla 2
	if ( nivel_cargado[NIVEL_PANTALLA_2] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[NIVEL_PANTALLA_2] = false;
	end



/* -------------------------------------------------------------------------- */

	//pantalla 3
	if ( nivel_cargado[NIVEL_PANTALLA_3] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[NIVEL_PANTALLA_3] = false;
	end



/* -------------------------------------------------------------------------- */

	//pantalla 4
	if ( nivel_cargado[NIVEL_PANTALLA_4] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[NIVEL_PANTALLA_4] = false;
	end



/* -------------------------------------------------------------------------- */

	//pantalla 5
	if ( nivel_cargado[NIVEL_PANTALLA_5] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[NIVEL_PANTALLA_5] = false;
	end



/* -------------------------------------------------------------------------- */

	//pantalla 6
	if ( nivel_cargado[NIVEL_PANTALLA_6] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[NIVEL_PANTALLA_6] = false;
	end

	clear_screen();

end


/* -------------------------------------------------------------------------- */

process efecto_fade()

begin
	x = 320;
	y = 120;
	z = -999;
	file = fpg_system;
	graph = 21;
	loop
		x+= 30;

		if ( x > 800 ) break; end

		frame;
	end
end
