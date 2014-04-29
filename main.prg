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

const

	// niveles del juego
	intro 		= 0;
	menu 		= 1;
	opciones 	= 2;
	ayuda 		= 3;
	creditos 	= 4;
	pantalla1	= 5;
	pantalla2	= 6;
	pantalla3	= 7;
	pantalla4	= 8;
	pantalla5	= 9;
	pantalla6	= 10;
	gameover	= 11;

	// estados del jugador
	reposo = 0;
	camina = 1;
	saltoh = 2;
	saltov = 3;
	// variantes
	ade	= 0;
	arr	= 1;
	aba	= 2;
	// direccion
	izq = 1;
	der = 0;

	// armas
	pistola = 0;
	uzi = 1;
	minigun = 2;
	escopeta = 3;
	misil = 4;
	cohete = 5;
	lanzallamas = 6;
	
	const_granadas = 8;
	
	// tipos de ataque
	tiro = 0;
	fuego = 1;
	poder = 2;

	// direccion de disparo
	arriba = 3;
	derecha = 2;
	abajo = 4;
	izquierda = 1;

END

/* -------------------------------------------------------------------------- */

global
	
	//version del juego
	string version = "1.2";
	
end

/* -------------------------------------------------------------------------- */

include "prg/jkeys.prg";		//controla la entrada por joystick
include "prg/globals.prg";		//declaracion de variables
include "prg/funciones.prg";	//funciones de movimientos y colisiones

include "prg/volumen.prg";		//controla el volumen del juego
include "prg/niveles.prg";		//contrla el nivel que se ejecuta
include "prg/intro.prg";		//intro del juego
include "prg/menu.prg";			//controlador del menu principal
include "prg/menu2.prg";		//las opciones del menu
include "prg/juego.prg";		//las opciones del menu
include "prg/carla.prg";		//personaje principal
include "prg/armas.prg";
include "prg/enemigos.prg";
include "prg/gui.prg";
include "prg/items.prg";

begin

	// inicializacion de video
	if ( os_id == OS_GP2X_WIZ)

		set_mode(320, 240, 16, mode_fullscreen);
	
	else

		//scale_mode = SCALE_NOFILTER;
		scale_resolution = 09600720;
		set_title("Zombies 2012 (v" + version + ")");		
		set_mode(320, 240, 16, mode_window);

		/* screenshot mode */
		/*
		scale_resolution = 03200240;
		set_mode(320, 240, 16, mode_window + mode_frameless);
		*/

		
	end
	
	set_fps(30, 0);
	//write_var(0, 0, 0, 0, fps);
	

	//graficos "del sistema"
	fpg_sistema = load_fpg("fpg/sist.fpg");
	bgm_intro = load_song ( "bgm/01_graveyard_boss_it.ogg" );

	
	// procesos de inicializacion
	iniciar_armas();
    asignar_teclas_pc();
	
	// procesos controladores
	control_volumen();
    control_teclas();
	control_niveles();

end

/* -------------------------------------------------------------------------- */
