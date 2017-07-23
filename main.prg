import "mod_draw";
import "mod_joy";
import "mod_key";
import "mod_map";
import "mod_math";
import "mod_proc";
import "mod_grproc";
import "mod_rand";
import "mod_screen";
import "mod_scroll";
import "mod_sound";
import "mod_text";
import "mod_video";
import "mod_file";
import "mod_debug";
import "mod_wm";

/* -------------------------------------------------------------------------- */

global

	string game_version = "1.3-rc1";

end

/* -------------------------------------------------------------------------- */

include "prg/jkeys.prg";			//controla la entrada por joystick
include "prg/globals.prg";			//declaracion de variables
include "prg/funciones.prg";		//funciones de movimientos y colisiones

include "prg/volumen.prg";			//controla el volumen del juego
include "prg/niveles.prg";			//contrla el nivel que se ejecuta
include "prg/intro.prg";			//intro del juego
include "prg/menu.prg";				//controlador del menu principal
include "prg/menu2.prg";			//las opciones del menu
include "prg/menu_opciones.prg";	//menu de opciones
include "prg/juego.prg";			//las opciones del menu
include "prg/carla.prg";			//personaje principal
include "prg/armas.prg";
include "prg/enemigo_zombie.prg";
include "prg/gui.prg";
include "prg/items.prg";

/* -------------------------------------------------------------------------- */

begin

	// inicializacion de video
	if ( os_id == OS_GP2X_WIZ || os_id == OS_CAANOO)

		set_mode(320, 240, 16, MODE_FULLSCREEN);

	else

		//scale_mode = SCALE_NOFILTER;
		scale_resolution = SCALE_3X;
		set_title("Zombies 2012 (v" + game_version + ")");
		set_mode(320, 240, 16, MODE_WINDOW);

	end

	set_fps(30, 0);


	#ifdef DEBUG
		// salto intro
		nivel = NIVEL_MENU;
		game_version = game_version + " DBG";
		write_var(0, 0, 0, 0, fps);
	#endif


	//graficos "del sistema"
	fpg_system = load_fpg("fpg/system.fpg");
	bgm_intro = load_song ( "bgm/01_graveyard_boss_it.ogg" );


	// procesos de inicializacion
	inicializar_armas();
	inicializar_opciones();
    asignar_teclas_pc();

	// procesos controladores
	control_volumen();
    control_teclas();
	control_niveles();

end

/* -------------------------------------------------------------------------- */
