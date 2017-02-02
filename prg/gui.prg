process controlar_gui();

private

	id_icono;

	id_municion;
	id_puntos;
	id_vidas;
	id_granadas;
	id_zombies;

	zombies_restantes;

end

begin
	file = fpg_gui;

	x = 1;
	y = 1;

	id_icono = gui_icono_arma();
	id_puntos = write_var(0, 87, 38, 5, partida.puntos);
	id_granadas = write_var(0, 50, 24, 4, partida.granadas);
	id_vidas = write_var(0, 83, 24, 4, partida.vidas);

	loop

		zombies_restantes = zombies_necesarios - zombies_muertos;

		IF  ( zombies_restantes <= 0 )
			id_zombies = write(0, 315, 5, 5, "Done! Now find the exit!");
		ELSE
			id_zombies = write(0, 315, 5, 5, "Zombies Left: " + zombies_restantes);
		END

		if ( arma_actual <> pistola )
			id_municion = write_var (0, 17, 38, 4,partida.municion[arma_actual]);
		else
			id_municion = write (0, 17, 38, 4,"INF");
		end

		graph = (partida.salud / 10) + 30;

		frame;

		delete_text ( id_municion );
		delete_text ( id_zombies );

	end

onexit

	delete_text ( id_municion );
	delete_text ( id_puntos );
	delete_text ( id_vidas );
	delete_text ( id_granadas );
	delete_text ( id_zombies );

	signal(id_icono, S_KILL);

end

process gui_icono_arma()

begin
	file = fpg_gui;
	x = 16;
	y = 16;
	z = father.z -1;
	loop
		graph = arma_actual + 10;
		frame;
	end
end
