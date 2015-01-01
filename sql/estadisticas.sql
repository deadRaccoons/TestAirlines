select fechasalida, count(*) from viajes group by fechasalida order by fechasalida

--para avion
update avion set disponible = 'n' where idavion = 1
update avion set disponible = 'y' where idavion = 1
select sum(distancia) from viajes where idavion = 1 and realizado = 'y'
select destino from viajes where idavion = 1 order by fechallegada desc limit 1