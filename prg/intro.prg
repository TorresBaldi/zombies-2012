process iniciar_intro();

private

	image = 0;
	image_max = 2;

end

begin

	while ( image < image_max )

		image++;

		intro_slide(image);

		frame;

	end

	nivel_cambio = true;
	nivel = NIVEL_MENU;

end

function intro_slide( image );

private

	int i;
	int fade_speed = 10;
	int wait_time = 60;

end

begin

	file = fpg_intro;
	graph = image;
	x = 160;
	y = 120;
	alpha = 0;

	// fade in
	while ( alpha < 255)
		alpha += fade_speed;
		frame;
	end

	//show
	while( i < wait_time )
		i++;
		frame;
	end

	// fade out
	while ( alpha > 0 )
		alpha -= fade_speed;
		frame;
	end

end
