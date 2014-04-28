process iniciar_intro();
private
	timer;
	estado_intro = 0;
	limite = 110;
end
begin

	put_screen (fpg_intro,1);

	loop
	
		timer++;
		
		if ( timer == limite )
			limite = 130;
			timer = 0;
			switch (estado_intro)
				case 0:
					estado_intro = 1;
					cambio(2);
				end
				case 1:
					estado_intro = 2;
					cambio(3);
				end
				case 2:
					estado_intro = 3;
					cambio(0);
					break;
				end
			end
		end
		
		frame;
		
	end

end

process cambio(grafico);
private
	velocidad = 8;
	estado = 0;
	contador = 0;
end
begin
	file = fpg_intro;
	graph = 5;
	alpha = 0;
	
	x = 160;
	y = 120;
	
	loop
		
		switch (estado)
		
			case 0:	// aparecer
				alpha += velocidad;
				if ( alpha > 256 )
					estado = 1;
				end
			end
			
			case 1: //cambiar imagen y esperar
				contador++;
				if ( contador > 10 )
				
					if ( grafico == 0) 
						clear_screen();
						nivel_cambio = true;
						nivel = menu;
					else
						put_screen(fpg_intro, grafico);
					end
					
					estado = 2;
				end
			end
			
			case 2:	//desaparecer
				alpha -= velocidad;
				if (alpha <= 0 )
					break;
				end
			end
		end
	
		frame;
	end
end
