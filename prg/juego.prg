/* -------------------------------------------------------------------------- */

// crea una partida nueva, y va al nivel correspondiente
function opcion_iniciar_juego();

begin

	// crea los datos de la partida nueva
	partida.salud = 100;
	partida.vidas = 4;
	partida.puntos = 0;
	partida.nivel = NIVEL_PANTALLA_1;

	partida.armas[ARMA_PISTOLA] 	= true;
	partida.armas[ARMA_UZI] 		= false;
	partida.armas[ARMA_MINIGUN] 	= false;
	partida.armas[ARMA_ESCOPETA] 	= false;
	partida.armas[ARMA_MISIL] 		= false;
	partida.armas[ARMA_COHETE] 		= false;
	partida.armas[ARMA_LANZALLAMAS] = false;

	partida.municion[ARMA_PISTOLA]		= 999;
	partida.municion[ARMA_UZI]			= 0;
	partida.municion[ARMA_MINIGUN]		= 0;
	partida.municion[ARMA_ESCOPETA]		= 0;
	partida.municion[ARMA_MISIL]		= 0;
	partida.municion[ARMA_COHETE]		= 0;
	partida.municion[ARMA_LANZALLAMAS]	= 0;

	partida.granadas = 5;

	// y guarda la partida
	//save("savegame.dat", partida);

	// inicia el primer nivel
	nivel_cambio = true;
	nivel = NIVEL_PANTALLA_1;

end

/* -------------------------------------------------------------------------- */

// carga datos de una partida vieja y va al nivel correspondiente
function opcion_cargar_juego();

begin

	// obtiene la partida guardada
	load("savegame.dat", partida);

	partida.vidas = 4;
	partida.granadas = 5;

	//va al nivel correspondiente
	nivel_cambio = true;
	nivel = partida.nivel;

end

/* -------------------------------------------------------------------------- */

// inicia cada nivel del juego
// mantiene la ejecucion del juego
// reinicia a carla
// maneja la pausa
function iniciar_juego(carlax,carlay,finalx,finaly, objetivo);

private
	int juego_pausado = false;
	int pausa_posible = false;
	int id_menu_pausa;
end

begin

	// carga recursos del juego
	fpg_carla = load_fpg("fpg/carla.fpg");
	fpg_zombie = load_fpg("fpg/zombie.fpg");
	fpg_armas = load_fpg("fpg/armas.fpg");
	fpg_gui = load_fpg("fpg/gui.fpg");
	fpg_items = load_fpg("fpg/items.fpg");

	sfx_armas[ARMA_PISTOLA] = load_wav("sfx/pistola.wav");
	sfx_armas[ARMA_UZI] = load_wav("sfx/uzi.wav");
	sfx_armas[ARMA_MINIGUN] = load_wav("sfx/minigun.wav");
	sfx_armas[ARMA_ESCOPETA] = load_wav("sfx/shotgun.wav");
	sfx_armas[ARMA_MISIL] = load_wav("sfx/misil.wav");
	sfx_armas[ARMA_COHETE] = load_wav("sfx/cohete.wav");
	sfx_armas[ARMA_LANZALLAMAS] = load_wav("sfx/llamas.wav");

	sfx_granada = load_wav("sfx/granada.wav");
	sfx_item = load_wav("sfx/pickup.wav");

	bgm_songs[0] = "bgm/02_graveyard_mod.ogg";
	bgm_songs[1] = "bgm/03_heavy_metal_xm.ogg";
	bgm_songs[2] = "bgm/04_industrial_rock_mod.ogg";
	bgm_songs[3] = "bgm/05_graveyard_dwarfgoat_xm.ogg";

	// reproduce la musica
	bgm_id = load_song( bgm_songs[ rand(0,3) ] );
	play_song (bgm_id, -1);

	//scroll.ratio = 0;

	// inicio del nivel
	switch ( nivel )
		case NIVEL_PANTALLA_1:

			// obtiene las durezas
			techo = map_get_pixel(fpg_nivel,1,0,0);
			suelo1 = map_get_pixel(fpg_nivel,1,1,0);
			suelo2 = map_get_pixel(fpg_nivel,1,2,0);

			// inicia scrolls
			start_scroll(0, fpg_nivel, 3, 2, 0, 0);
			start_scroll(1, fpg_nivel, 4, 0, 0, 1);

			// relaciona scrolls
			scroll[1].follow = 0;
			scroll[1].ratio = 50;

		end

		case NIVEL_PANTALLA_2:

			// obtiene las durezas
			techo = map_get_pixel(fpg_nivel,1,0,0);
			suelo1 = map_get_pixel(fpg_nivel,1,1,0);
			suelo2 = map_get_pixel(fpg_nivel,1,2,0);

			// inicia el scroll
			start_scroll(0, fpg_nivel, 2, 0, 0 ,0);

			// crea algunos powerups
			item_arma(975,170);
			item_arma(975,170);
			item_arma(975,170);
		end

		case NIVEL_PANTALLA_3:
			suelo1 = map_get_pixel(fpg_nivel,1,95,215);
			techo = map_get_pixel(fpg_nivel,1,10,65);
			start_scroll(0, fpg_nivel, 2, 0, 0 ,0);
		end

		case NIVEL_PANTALLA_4:
			suelo1 = map_get_pixel(fpg_nivel,1,215,170);
			techo = map_get_pixel(fpg_nivel,1,20,220);
			start_scroll(0, fpg_nivel, 2, 0, 0 ,0);

			item_arma(180,155);
			item_arma(190,155);
			item_arma(200,155);
			item_arma(210,155);
			item_arma(220,155);
		end

		case NIVEL_PANTALLA_5:
			suelo1 = map_get_pixel(fpg_nivel,1,0,70);
			techo = map_get_pixel(fpg_nivel,1,0,0);
			start_scroll(0, fpg_nivel, 2, 0, 0 ,0);
		end

		case NIVEL_PANTALLA_6:
			suelo1 = map_get_pixel(fpg_nivel,1,2,90);
			techo = map_get_pixel(fpg_nivel,1,2,30);
			start_scroll(0, fpg_nivel, 2, 0, 0 ,0);
		end
	end

	carla_muerta = true;

	controlar_granadas();
	controlar_zombies();
	controlar_gui();
	controlar_objetivos(finalx, finaly, objetivo);
	controlar_armas();

	loop

		// si se apreta menu sale
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = NIVEL_MENU;
			signal(id, S_KILL_TREE);
		end

		// si se apreta pause pone pause
		if ( jkeys_state[_JKEY_SELECT] and pausa_posible)
			pausa_posible = false;
			if ( juego_pausado )
				resume_song();
				signal(id, S_WAKEUP_TREE);
				signal(id_menu_pausa, S_KILL);
				juego_pausado = false;
			else
				pause_song();
				signal(id, S_FREEZE_TREE);
				signal(id, S_WAKEUP);
				juego_pausado = true;
				id_menu_pausa = menu_pausa();
			end
		end
		if (pausa_posible == false and not jkeys_state[_JKEY_SELECT])
			pausa_posible = true;
		end

		// reinicia a carla si quedan vidas, sino, terminar partida
		if ( carla_muerta == true )
			carla_muerta = false;
			carla_muriendo = false;
			partida.vidas--;
			partida.granadas = 5;

			if ( partida.vidas >= 0 )
				partida.salud = 100;
				carla(carlax, carlay);
			else
				nivel_cambio = true;
				nivel = NIVEL_GAMEOVER;
				signal(id,s_kill_tree);
			end

		end

		frame;
	end

onexit

	// descarga de recursos del juego
	unload_fpg (fpg_carla);
	unload_fpg (fpg_zombie);
	unload_fpg (fpg_armas);
	unload_fpg (fpg_gui);
	unload_fpg (fpg_items);

	unload_wav(sfx_armas[ARMA_PISTOLA]);
	unload_wav(sfx_armas[ARMA_UZI]);
	unload_wav(sfx_armas[ARMA_MINIGUN]);
	unload_wav(sfx_armas[ARMA_ESCOPETA]);
	unload_wav(sfx_armas[ARMA_MISIL]);
	unload_wav(sfx_armas[ARMA_COHETE]);
	unload_wav(sfx_armas[ARMA_LANZALLAMAS]);

	unload_wav(sfx_granada);

	stop_scroll(0);
	stop_scroll(1);

end

process menu_pausa();

begin
	file = fpg_system;
	graph = 22;
	x = 160;
	y = 120;
	loop
		frame;
	end

end


process controlar_objetivos(x,y,objetivo)

private

	objetivo_cumplido;

end

begin

	file = fpg_system;
	graph = 20;
	alpha = 0;

	ctype = c_scroll;
	cnumber = c_0;

	zombies_muertos = 0;
	zombies_necesarios = objetivo;

	loop

		if ( zombies_muertos >= zombies_necesarios )
			alpha = 128;
		end

		// compruebo colision con carla
		if ( collision ( type carla ) and ( zombies_muertos >= zombies_necesarios ) )
			objetivo_cumplido = true;
		end

		/*
		// paso de pantalla modo debug
		while ( key(_backspace) )
			frame;
			//objetivo_cumplido = true;
			zombies_muertos = zombies_necesarios;
		end
		*/

		// paso de pantalla
		if ( objetivo_cumplido )
			partida.nivel++;
			partida.vidas++;
			save( "savegame.dat", partida );
			nivel_cambio = true;
			nivel = partida.nivel;
			signal ( father, S_KILL_TREE );
		end

		frame;
	end

end

