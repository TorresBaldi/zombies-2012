CONST

    // niveles del juego
    NIVEL_INTRO         = 0;
    NIVEL_MENU          = 1;
    NIVEL_OPCIONES      = 2;
    NIVEL_AYUDA         = 3;
    NIVEL_CREDITOS      = 4;
    NIVEL_PANTALLA_1    = 5;
    NIVEL_PANTALLA_2    = 6;
    NIVEL_PANTALLA_3    = 7;
    NIVEL_PANTALLA_4    = 8;
    NIVEL_PANTALLA_5    = 9;
    NIVEL_PANTALLA_6    = 10;
    NIVEL_GAMEOVER      = 11;

    // estados del jugador
    EST_REPOSO = 0;
    EST_CAMINA = 1;
    EST_SALTOH = 2;
    EST_SALTOV = 3;

    // variantes
    VAR_ADE = 0;
    VAR_ARR = 1;
    VAR_ABA = 2;

    // direccion
    DIR_IZQ = 1;
    DIR_DER = 0;

    // armas
    ARMA_PISTOLA        = 0;
    ARMA_UZI            = 1;
    ARMA_MINIGUN        = 2;
    ARMA_ESCOPETA       = 3;
    ARMA_MISIL          = 4;
    ARMA_COHETE         = 5;
    ARMA_LANZALLAMAS    = 6;

    // direccion de disparo
    DISPARO_ARRIBA      = 3;
    DISPARO_DERECHA     = 2;
    DISPARO_ABAJO       = 4;
    DISPARO_IZQUIERDA   = 1;

    //estados del zombie
    ESTADO_PATRULLANDO      = 0;
    ESTADO_ACERCANDOSE      = 1;
    ESTADO_ATACANDO_LEJOS   = 2;
    ESTADO_ATACANDO_CERCA   = 3;

    //opciones
    OPC_FULLSCREEN  = 0;
    OPC_SCALE       = 1;
    OPC_QUALITY     = 2;
    OPC_VOLMASTER   = 3;
    OPC_VOLSFX      = 4;
    OPC_VOLBGM      = 5;
    OPC_LAST        = 5;

    // scale resolution
    SCALE_1X = 03200240;
    SCALE_2X = 06400480;
    SCALE_3X = 09600720;

END

GLOBAL

    // ID de FPGs
    int fpg_intro;
    int fpg_system;
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
    int nivel = NIVEL_INTRO;
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
    int carla_hit;  // si esta siendo golpeada

    carla_muriendo = false; // si carla se murio, pero todavia no tiene que respawnear
    carla_muerta = true;    // si carla tiene que respawnear

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

        //opciones del juego
        struct opciones[5]
            int min_value;
            int max_value;
            int value;
            int show_on_pc;
            int show_on_wiz;
        end

    end

END
