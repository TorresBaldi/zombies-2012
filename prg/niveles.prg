/* -------------------------------------------------------------------------- */

function control_niveles();

begin

	loop
	
		if ( nivel_cambio == true )
			nivel_cambio = false;
			delete_text(all_text);
			
			switch ( nivel )

/* -------------------------------------------------------------------------- */

				case intro:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_intro = load_fpg ("fpg/intro.fpg");
					
					// avisa que se cargo
					nivel_cargado[intro] = true;
					
					// inicia procesos
					play_song (bgm_intro, -1);
					iniciar_intro();
				
				end
				

/* -------------------------------------------------------------------------- */

				case menu:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_menu = load_fpg ("fpg/menu.fpg");
					
					// avisa que se cargo
					nivel_cargado[menu] = true;
					
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

				case opciones:
					// descarga recursos anteriores
					descargar();
					

					// carga recursos actuales
					fpg_menu2 = load_fpg("fpg/menu2.fpg");
					
					// avisa que se cargo
					nivel_cargado[opciones] = true;
					
					// inicia procesos
					// muestra pantalla de opciones
					efecto_fade();
					iniciar_menu_opciones();
				end
				

/* -------------------------------------------------------------------------- */

				case ayuda:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_menu2 = load_fpg("fpg/menu2.fpg");
					
					// avisa que se cargo
					nivel_cargado[ayuda] = true;
					
					// inicia procesos
					efecto_fade();
					iniciar_menu_ayuda();
				end
				

/* -------------------------------------------------------------------------- */

				case creditos:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_menu2 = load_fpg("fpg/menu2.fpg");
					
					// avisa que se cargo
					nivel_cargado[creditos] = true;
					
					// inicia procesos
					efecto_fade();
					iniciar_menu_creditos();
				end
				

/* -------------------------------------------------------------------------- */

				case pantalla1:
					// descarga recursos anteriores
					descargar();
					
					fpg_nivel = load_fpg("fpg/mapa1.fpg");
					
					// avisa que se cargo
					nivel_cargado[pantalla1] = true;
					
					// inicia procesos
					efecto_fade();
					iniciar_juego(100,180,1260,200,30);
				end
				

/* -------------------------------------------------------------------------- */

				case pantalla2:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa2.fpg");
					
					// avisa que se cargo
					nivel_cargado[pantalla2] = true;
					
					// inicia procesos
					efecto_fade();
					iniciar_juego(175,36,10,515,40);
				end

/* -------------------------------------------------------------------------- */

				case pantalla3:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa3.fpg");
					
					// avisa que se cargo
					nivel_cargado[pantalla3] = true;
					
					// inicia procesos
					efecto_fade();
					iniciar_juego(980,100,20,160,50);
				end

/* -------------------------------------------------------------------------- */

				case pantalla4:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa4.fpg");
					
					// avisa que se cargo
					nivel_cargado[pantalla4] = true;
					
					// inicia procesos
					efecto_fade();
					iniciar_juego(995,155,10,330,60);
				end

/* -------------------------------------------------------------------------- */

				case pantalla5:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa5.fpg");
					
					// avisa que se cargo
					nivel_cargado[pantalla5] = true;
					
					// inicia procesos
					efecto_fade();
					iniciar_juego(990,225,19,110,80);
				end

/* -------------------------------------------------------------------------- */

				case pantalla6:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					fpg_nivel = load_fpg("fpg/mapa6.fpg");
					
					// avisa que se cargo
					nivel_cargado[pantalla6] = true;
					
					// inicia procesos
					efecto_fade();
					iniciar_juego(1000,160,10,150,150);
				end

/* -------------------------------------------------------------------------- */

				case gameover:
					// descarga recursos anteriores
					descargar();
					
					// carga recursos actuales
					
					// avisa que se cargo
					nivel_cargado[gameover] = true;
					
					// inicia procesos
					iniciar_menu_gameover();
					efecto_fade();
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

	//intro
	if ( nivel_cargado[intro] )
		unload_fpg(fpg_intro);
		nivel_cargado[intro] = false;
	end
	

/* -------------------------------------------------------------------------- */

	//menu
	if ( nivel_cargado[menu] )
		unload_fpg(fpg_menu);
		nivel_cargado[menu] = false;
	end


/* -------------------------------------------------------------------------- */

	//opciones
	if ( nivel_cargado[opciones] )
		unload_fpg(fpg_menu2);
		nivel_cargado[opciones] = false;
	end
	

/* -------------------------------------------------------------------------- */

	//ayuda
	if ( nivel_cargado[ayuda] )
		unload_fpg(fpg_menu2);
		nivel_cargado[opciones] = false;
	end
	

/* -------------------------------------------------------------------------- */

	//creditos
	if ( nivel_cargado[creditos] )
		unload_fpg(fpg_menu2);
		nivel_cargado[opciones] = false;
	end
	

/* -------------------------------------------------------------------------- */

	//pantalla 1
	if ( nivel_cargado[pantalla1] )
		unload_song ( bgm_id );
		unload_fpg (fpg_nivel);
		stop_scroll(0);
		nivel_cargado[pantalla1] = false;
	end
	

/* -------------------------------------------------------------------------- */

	//pantalla 2
	if ( nivel_cargado[pantalla2] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[pantalla2] = false;
	end

	

/* -------------------------------------------------------------------------- */

	//pantalla 3
	if ( nivel_cargado[pantalla3] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[pantalla3] = false;
	end

	

/* -------------------------------------------------------------------------- */

	//pantalla 4
	if ( nivel_cargado[pantalla4] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[pantalla4] = false;
	end

	

/* -------------------------------------------------------------------------- */

	//pantalla 5
	if ( nivel_cargado[pantalla5] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[pantalla5] = false;
	end

	

/* -------------------------------------------------------------------------- */

	//pantalla 6
	if ( nivel_cargado[pantalla6] )
		unload_song ( bgm_id );
		stop_scroll(0);
		unload_fpg(fpg_nivel);
		nivel_cargado[pantalla6] = false;
	end

	clear_screen();
	delete_text(all_text);

end


/* -------------------------------------------------------------------------- */

process efecto_fade()

begin
	x = 320;
	y = 120;
	z = -999;
	file = fpg_sistema;
	graph = 1;
	loop
		x+= 30;
		
		if ( x > 800 ) break; end
		
		frame;
	end
end
