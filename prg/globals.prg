global

	// ID de FPGs
	int fpg_intro;
	int fpg_menu;
	int fpg_menu2;
	int fpg_sistema;
	int fpg_volumen;
	int fpg_nivel;
	int fpg_carla;
	int fpg_zombie;
	int fpg_armas;
	int fpg_gui;
	int fpg_items;
	
	// ID de sonidos
	int menu_cursor;
	int sfx_armas[6];
	int sfx_granada;
	int sfx_item;
	
	// ID de musica
	int bgm_intro;
	string bgm_songs[3];
	int bgm_id;

	// niveles del juego
	int nivel = intro;
	int nivel_cambio = true;
	int nivel_cargado[15];

	//menu principal
	menu_seleccion = 1;

	// volumen
	volumen = 64;

	// estados carla
	carla_est;
	carla_var;
	carla_dir;
	carla_posx;
	carla_posy;
	
	carla_disparox;
	carla_disparoy;
	carla_auxx;
	carla_auxy;

	int carla_disparando;
	int carla_hit;	// si esta siendo golpeada
	
	carla_muriendo = false;	// si carla se murio, pero todavia no tiene que respawnear
	carla_muerta = true;	// si carla tiene que respawnear

	gravedad = 1;
	
	zombies_muertos;
	zombies_necesarios;

	// niveles y movimientos
	suelo1;
	suelo2;
	techo;
	
	// arma seleccionada por el jugador
	int arma_actual;
	
	// propiedades de las armas
	struct armas[6]
		int alcance;
		int velocidad;
		int dano;
		int retraso_manual;
		int retraso_auto;
		int rafaga;
		int autodisparo;
		int tipo_ataque;
	end

	// todos los datos necesarios para guardar una partida
	struct partida;

		// globales
		int salud;
		int vidas;
		int puntos;
		int nivel;

		// armas y municiones actuales
		int armas[6];
		int municion[6];
		int granadas;
		int granada_tipo;

	end

end