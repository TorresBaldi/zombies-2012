import "mod_key";
import "mod_joy";
import "mod_proc";

/* -------------------------------------------------------------------------- */

const
    _JKEY_UP        =  0 ;
    _JKEY_UPLEFT    =  1 ;
    _JKEY_LEFT      =  2 ;
    _JKEY_DOWNLEFT  =  3 ;
    _JKEY_DOWN      =  4 ;
    _JKEY_DOWNRIGHT =  5 ;
    _JKEY_RIGHT     =  6 ;
    _JKEY_UPRIGHT   =  7 ;
    _JKEY_MENU      =  8 ;
    _JKEY_SELECT    =  9 ;
    _JKEY_L         = 10 ;
    _JKEY_R         = 11 ;
    _JKEY_A         = 12 ;
    _JKEY_B         = 13 ;
    _JKEY_X         = 14 ;
    _JKEY_Y         = 15 ;
    _JKEY_VOLUP     = 16 ;
    _JKEY_VOLDOWN   = 17 ;
    _JKEY_CLICK     = 18 ;

    _JKEY_LAST      = 19 ;

end

/* -------------------------------------------------------------------------- */

global
    int jkeys[_JKEY_LAST];
    int jkeys_state[_JKEY_LAST];
end

/* -------------------------------------------------------------------------- */

function asignar_teclas_pc()
begin
    jkeys[ _JKEY_UP        ] = _W ;
    jkeys[ _JKEY_UPLEFT    ] = 0 ;
    jkeys[ _JKEY_LEFT      ] = _A ;
    jkeys[ _JKEY_DOWNLEFT  ] = 0 ;
    jkeys[ _JKEY_DOWN      ] = _S ;
    jkeys[ _JKEY_DOWNRIGHT ] = 0 ;
    jkeys[ _JKEY_RIGHT     ] = _D ;
    jkeys[ _JKEY_UPRIGHT   ] = 0 ;
    jkeys[ _JKEY_MENU      ] = _ESC ;
    jkeys[ _JKEY_SELECT    ] = _ENTER ;
    jkeys[ _JKEY_L         ] = _Q ;
    jkeys[ _JKEY_R         ] = _E ;
    jkeys[ _JKEY_A         ] = _F ;
    jkeys[ _JKEY_B         ] = _H ;
    jkeys[ _JKEY_X         ] = _G ;
    jkeys[ _JKEY_Y         ] = _J ;
    jkeys[ _JKEY_VOLUP     ] = _O ;
    jkeys[ _JKEY_VOLDOWN   ] = _L ;
    jkeys[ _JKEY_CLICK     ] = 0 ;

end

/* -------------------------------------------------------------------------- */

process control_teclas()
private
    i;
begin

    signal_action( s_kill, s_ign );
    signal( type control_teclas, s_kill );
    signal_action( s_kill, s_dfl );

    loop
        for ( i = 0; i < _JKEY_LAST; i++ )
            if ( jkeys[i] )
                jkeys_state[i] = key( jkeys[i] );
            else
                jkeys_state[i] = 0;
            end
        end

        if ( os_id == OS_GP2X_WIZ && joy_number() ) /* Wiz */
            jkeys_state[ _JKEY_UP        ] |= joy_getbutton( 0, _JKEY_UP        );
            jkeys_state[ _JKEY_UPLEFT    ] |= joy_getbutton( 0, _JKEY_UPLEFT    );
            jkeys_state[ _JKEY_LEFT      ] |= joy_getbutton( 0, _JKEY_LEFT      );
            jkeys_state[ _JKEY_DOWNLEFT  ] |= joy_getbutton( 0, _JKEY_DOWNLEFT  );
            jkeys_state[ _JKEY_DOWN      ] |= joy_getbutton( 0, _JKEY_DOWN      );
            jkeys_state[ _JKEY_DOWNRIGHT ] |= joy_getbutton( 0, _JKEY_DOWNRIGHT );
            jkeys_state[ _JKEY_RIGHT     ] |= joy_getbutton( 0, _JKEY_RIGHT     );
            jkeys_state[ _JKEY_UPRIGHT   ] |= joy_getbutton( 0, _JKEY_UPRIGHT   );
            jkeys_state[ _JKEY_MENU      ] |= joy_getbutton( 0, _JKEY_MENU      );
            jkeys_state[ _JKEY_SELECT    ] |= joy_getbutton( 0, _JKEY_SELECT    );
            jkeys_state[ _JKEY_L         ] |= joy_getbutton( 0, _JKEY_L         );
            jkeys_state[ _JKEY_R         ] |= joy_getbutton( 0, _JKEY_R         );
            jkeys_state[ _JKEY_A         ] |= joy_getbutton( 0, _JKEY_A         );
            jkeys_state[ _JKEY_B         ] |= joy_getbutton( 0, _JKEY_B         );
            jkeys_state[ _JKEY_X         ] |= joy_getbutton( 0, _JKEY_X         );
            jkeys_state[ _JKEY_Y         ] |= joy_getbutton( 0, _JKEY_Y         );
            jkeys_state[ _JKEY_VOLUP     ] |= joy_getbutton( 0, _JKEY_VOLUP     );
            jkeys_state[ _JKEY_VOLDOWN   ] |= joy_getbutton( 0, _JKEY_VOLDOWN   );
            jkeys_state[ _JKEY_CLICK     ] |= joy_getbutton( 0, _JKEY_CLICK     );

            jkeys_state[ _JKEY_UP        ] |= jkeys_state[ _JKEY_UPLEFT    ] | jkeys_state[ _JKEY_UPRIGHT   ] ;
            jkeys_state[ _JKEY_DOWN      ] |= jkeys_state[ _JKEY_DOWNRIGHT ] | jkeys_state[ _JKEY_DOWNLEFT  ] ;
            jkeys_state[ _JKEY_LEFT      ] |= jkeys_state[ _JKEY_UPLEFT    ] | jkeys_state[ _JKEY_DOWNLEFT  ] ;
            jkeys_state[ _JKEY_RIGHT     ] |= jkeys_state[ _JKEY_UPRIGHT   ] | jkeys_state[ _JKEY_DOWNRIGHT ] ;
        end

        frame;
    end
end

/* -------------------------------------------------------------------------- */