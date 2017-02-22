process iniciar_menu_ayuda()

begin

	if ( os_id == OS_GP2X_WIZ)
		put(fpg_system, 33, 160, 120);
	else
		put(fpg_system, 32, 160, 120);
	end

	loop
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = NIVEL_MENU;
			break;
		end
		frame;
	end

end
process iniciar_menu_creditos()

begin
	put(fpg_system, 30, 160, 120);
	loop
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = NIVEL_MENU;
			break;
		end
		frame;
	end

end
process iniciar_menu_gameover()

begin
	put(fpg_system, 34, 160, 120);
	loop
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = NIVEL_MENU;
			break;
		end
		frame;
	end

end
