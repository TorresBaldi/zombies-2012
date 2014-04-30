process iniciar_menu_opciones()

begin

	put_screen(fpg_system, 31);
	
	loop
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = menu;
			break;
		end
		frame;
	end

end
process iniciar_menu_ayuda()

begin
	
	if ( os_id == OS_GP2X_WIZ)
		put_screen(fpg_system, 33);
	else
		put_screen(fpg_system, 32);
	end
	
	loop
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = menu;
			break;
		end
		frame;
	end

end
process iniciar_menu_creditos()

begin
	put_screen(fpg_system, 30);
	loop
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = menu;
			break;
		end
		frame;
	end

end
process iniciar_menu_gameover()

begin
	put_screen(fpg_system, 34);
	loop
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = menu;
			break;
		end
		frame;
	end

end
