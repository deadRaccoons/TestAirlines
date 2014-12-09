/*Esto es un comentario*/
--esto tambien
/*
los constraint son por si queremos modificar una llave primaria
o si queremos que haya (aparte de la llave primaria) una tupla que no se repita
*/

create table valor(
  idvalor int primary key check(idvalor > 0 and idvalor < 2),
  costomilla double precision not null,
  fecha date not null,
  tipomoneda text not null,
  tipomedida text not null 
);
create or replace function fvalor() returns trigger as $tvalor$
  begin 
    new.fecha = (select current_date);
    if (select max(idvalor) from valor) is null then new.idvalor = 1;
    return new;
    end if;
    new.idvalor = (select max(idvalor) from valor) + 1;
    return new;
  end;
$tvalor$ language plpgsql;

create trigger tvalor
before insert on valor
for each row
execute procedure fvalor()


--tabla avion
create table avion(
  idAvion int primary key,
  modelo varchar(6) NOT NULL,
  marca text not null,
  capacidadPrimera int NOT NULL check(capacidadPrimera > 0),
  capacidadTurista int NOT NULL check(capacidadTurista > 0),
  disponible varchar(1) not null check(disponible in ('y', 'n')),
  fecha date,
  velocidad integer not null
);

create or replace function favion() returns trigger as $tavion$
  begin 
    if (select max(idavion) from avion) is null then new.idAvion = 1;
    return new;
    end if;
    new.idavion = (select max(idavion) from avion) + 1;
    return new;
  end;
$tavion$ language plpgsql;

create trigger tavion
before insert on avion
for each row
execute procedure favion()


create or replace view avions 
as select modelo, marca, capacidadprimera, capacidadturista 
from avion;

--como insertar en la tabla avion
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values (/* 'string' */, /* 'string' */, /*int*/, /*int*/, /*'char'*/);


--tabla ciudad
drop table ciudads
CREATE TABLE ciudads(
  nombre text NOT NULL,
  pais text NOT NULL,
  distancia int NOT NULL check(distancia >= 0),
  descripcion text not null,
  zonahoraria text not null
);
alter table ciudads
add constraint ciudadsc
primary key (nombre);
drop table ciudads


--tabla login
CREATE TABLE logins(
  correo text not null,
  contraseña varchar(18) not null,
  activo char(1) not null check(activo in ('y', 'n'))
);
alter table logins
add constraint loginc
primary key (correo);


--tabla usuario
CREATE TABLE usuarios(
  correo text NOT NULL references login(correo),
  idusuario int NOT NULL,
  nombres text NOT NULL,
  apellidoPaterno text NOT NULL,
  apellidoMaterno text NOT NULL,
  nacionalidad text NOT NULL,
  genero varchar(1) NOT NULL check (genero in ('H', 'M')),
  fechaNacimiento date NOT NULL,
  url_imagen text
);
ALTER TABLE usuario
ADD CONSTRAINT usuarioc
PRIMARY KEY (idusuario);

create or replace function fusuarios() returns trigger as $tusuarios$
  begin 
    if (select max(idusuario) from usuarios) is null then new.usuario = 1;
    return new;
    end if;
    new.idusuario = (select max(idusuario) from usuarios) + 1;
    return new;
  end;
$tusuarios$ language plpgsql;

create or replace trigger tusuarios
before insert on usuarioss
for each row
execute procedure fusuarios()

--forma en como se insertaran los usuarios
insert into usuario
values (/*'string'*/, /*(select max(dni) from usuario) + 1*/, /*'string'*/, /*'string'*/, /*'string'*/, /*'string'*/, /*'char'*/);


create table tarjeta(
  noTarjeta varchar(16) not null primary key,
  valor int not null,
  idusuario int not null references usuarios(idusuario),
  disponible varchar(1) not null check(disponible in ('y', 'n'))
);

--tabla promocion
CREATE TABLE promocion(
  idPromocion integer not null,
  porcentaje double precision not null check(porcentaje > 0 and porcentaje < 1),
  fechaEntrada date not null,
  vigencia date not null check(vigencia >= fechaEntrada),
  descripcion text not null,
  activo varchar(1) not null,
  unique (porcentaje, fechaEntrada, vigencia)
);

alter table promocion
add constraint proomocionc
primary key (idPromocion);

create or replace function fpromocion() returns trigger as $tpromocion$
  begin 
    new.porcentaje = 1 - (new.porcentaje / 100);
    if new.fechaentrada < (select current_date) then return new;
    end if;
    if (select max(idpromocion) from promocion) is null then new.idpromocion = 1;
    return new;
    end if;
    new.idpromocion = (select max(idpromocion) from promocion) + 1;
    return new;
  end;
$tpromocion$ language plpgsql;

create trigger tpromocion
before insert on promocion
for each row
execute procedure fpromocion()


--tabla viaje
CREATE TABLE viaje(
  idViaje int not null,
  origen text not null references ciudads(nombre),
  destino text not null references ciudads(nombre) check(destino <> origen),  
  fechasalida date not null,
  horasalida time with time zone not null,
  fechallegada date not null,
  horallegada time with time zone not null,
  distancia int not null,
  tiempo interval not null,
  costoViaje double precision not null,
  realizado char(1) not null check (realizado in ('y', 'n')),
  unique(origen, destino, fechasalida, horasalida)
);

alter table viaje
add constraint viajec
primary key (idViaje);

create or replace function fviaje() returns trigger as $tviaje$
  begin 
    update viaje set realizado = 'y' where fechasalida + horasalida <= (select current_timestamp);
    new.horasalida = cast(new.horasalida::time without time zone ||' '|| (select zonahora from ciudads where nombre = new.origen) as time with time zone);
    new.tiempo = cast((new.distancia/180 * 60) ||' minutes' as interval);
    new.costoViaje = cast(new.distancia * (select costomilla from valor) as double precision);
    new.horallegada = (new.horasalida + new.tiempo)::time with time zone at time zone (select zonahora from ciudads where nombre = new.destino);
    new.fechallegada = cast(cast(((select current_date)+ new.horasalida + new.tiempo)::timestamp with time zone at time zone (select zonahora from ciudads where nombre = new.destino) as timestamp) as date);
    new.realizado = 'n';
    if (select max(idviaje) from viaje) is null then new.idviaje = 1;
	return new;
    end if;
    new.idviaje = (select max(idviaje) from viaje) + 1;
    return new;
  end;
$tviaje$ language plpgsql;

create trigger tviaje
before insert on viaje
for each row
execute procedure fviaje();

create or replace rule rviaje as on update
to viaje
do instead nothing

insert into valor values (null, .12, null, 'dollar', 'milla');
insert into viaje values (null, 'Berlin', 'Ciudad de México', '09-12-2014', '14:00', null, null, 6700, null, null, 'n');
update viaje set costoViaje = 2.3 where idViaje = 1
delete from viaje

/*
--tabla asignado
CREATE TABLE asignado(
  idViaje serial not null references viaje(idViaje),
  idAvion serial not null references avion(idAvion)
);
alter table  asignado
add constraint asignadoc
unique (idViaje);
*/


--tabla viajepromocion
CREATE TABLE promocionespecial(
  idViaje serial not null references viaje(idViaje),
  idpromocion serial not null references promocion(idpromocion),
  unique (idViaje)
);


--tabla pasajero (los usuarios que han viajado y los que viajes han tomado)
CREATE TABLE boleto(
  idboleto integer,
  idusuario serial not null references usuario(idusuario),
  idViaje serial not null,
  clase text not null check (clase in ('Primera', 'Turista')),
  asiento integer not null,
  fechasalida date,
  horasalida time,
  fechallegada date,
  horallegada time,
  costototal double precision
);
alter table pasajero
add constraint pasajeroc1
unique (idViaje, clase, asiento);

create table aplica(
  idviaje integer references viaje(idviaje),
  codigopromocion integer references promocions(codigopromocion),
  idusuario integer references usuarios(idusuario)
);

create table administrador (
  correo text not null references logins(correo),
  nombres text not null,
  apellidos text not null,
);
alter table administrador
add constraint adiministradorc
primary key (correo)