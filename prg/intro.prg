process iniciar_intro();

private

	image_current = 0;
	image_max = 2;

end

begin

	while ( image_current < image_max )

		image_current++;

		intro_slide(image_current);

		frame;

	end

	nivel_cambio = true;
	nivel = NIVEL_MENU;



end

function intro_slide( image );

private

	int i;

	int fade_speed = 10;
	int wait_speed = 60;

	int phase;

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
	while( i < wait_speed )
		i++;
		frame;
	end

	// fade out
	while ( alpha > 0 )
		alpha -= fade_speed;
		frame;
	end

end
