const

	CONST_ONSCREEN_Y	= 230;
	CONST_OFFSCREEN_Y	= 260;
	CONST_OFFTIMER		= 50;

end

process control_volumen();

private

	volume_keylock;
	inactivo = 200;	//tiempo desde que se uso
	velocidad = 3;

end

begin

	fpg_volumen = load_fpg("fpg/volumen.fpg");

	file = fpg_volumen;
	graph = volumen / 16;

	x = 160;
	y = 260;

	set_channel_volume(-1,volumen);
	set_song_volume(volumen);

	loop
		if ( jkeys_state[_jkey_volup] and volumen < 128 and volume_keylock)
			volume_keylock = false;
			volumen+= 16;
			set_channel_volume(-1,volumen);
			set_song_volume(volumen);
			inactivo = 0;
		end

		if ( jkeys_state[_jkey_voldown] and volumen > 0 and volume_keylock)
			volume_keylock = false;
			volumen-= 16;
			set_channel_volume(-1,volumen);
			set_song_volume(volumen);
			inactivo = 0;
		end

		if (not jkeys_state[_jkey_volup] and not jkeys_state[_jkey_voldown] and volume_keylock == false)
			volume_keylock = true;
		end

		inactivo++;

		// aparicion y desaparicion
		if ( inactivo < CONST_OFFTIMER )
			if ( y > CONST_ONSCREEN_Y )
				y-= velocidad;
			end
		else
			if ( y < CONST_OFFSCREEN_Y )
				y+= velocidad;
			end
		end


		graph = volumen / 16;
		if ( graph == 0 ) graph = 9; end

		frame;
	end

end
