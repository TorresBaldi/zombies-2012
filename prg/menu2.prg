process iniciar_menu_opciones()

begin

	put_screen(fpg_menu2, 1);
	
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
		put_screen(fpg_menu2, 4);
	else
		put_screen(fpg_menu2, 3);
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
	put_screen(fpg_menu2, 2);
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
	put_screen(fpg_sistema, 20);
	loop
		if ( jkeys_state[_JKEY_MENU] )
			nivel_cambio = true;
			nivel = menu;
			break;
		end
		frame;
	end

end
