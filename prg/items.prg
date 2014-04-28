// 
// PROYECTO:	Zombies2012
// 
// ARCHIVO: 	objetos.prg
// 
// INFO: 		Objetos recogibles y/o destruibles en el escenario
// 


PROCESS ITEM_ARMA(X, Y);

private
	tipo;
	municion;
	tiempo;
end

BEGIN

	FILE = FPG_ITEMS;
	ctype = c_scroll;
	cnumber = c_0;
	tipo = rand(1,6);
	
	signal_action(S_KILL_TREE, S_IGN);
	
	switch (tipo)
		case uzi:
			municion = 90;
		end
		case minigun:
			municion = 90;
		end
		case escopeta:
			municion = 16;
		end
		case misil:
			municion = 5;
		end
		case cohete:
			municion = 6;
		end
		case lanzallamas:
			municion = 100;
		end
	end

	GRAPH = tipo;

	LOOP
	
		// desaparece con el tiempo
		tiempo++;
		IF ( tiempo > 200 )
			BREAK;
		END
		
		// si el personaje la toca, aumenta la municion
		IF ( collision (type carla) )
			play_wav (sfx_item,0);
			partida.armas[tipo] = TRUE;
			partida.municion[TIPO] += municion;
			
			BREAK;
		END
	
		FRAME;
	END
END
