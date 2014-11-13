/*Esto es un comentario*/
--esto tambien
/*
los constraint son por si queremos modificar una llave primaria
o si queremos que haya (aparte de la llave primaria) una tupla que no se repita
*/

create table valor(
  idvalor int primary key,
  costomilla double precision not null,
  fecha date not null,
  tipomoneda text not null,
  tipomedida text not null 
);
create or replace function fvalor() returns trigger as $tvalor$
  begin 
    new.fecha = (select current_date);
    if (select max(idvalor) from valor) is null then new.idvalor = 1;
    return null;
    end if;
    new.idvalor = (select max(idvalor) from valor) + 1;
    return new;
  end;
$tvalors$ language plpgsql;

create trigger tvalor
before insert on valor
for each row
execute procedure fvalor()

create database mameline;

--tabla avion
create table avions(
  idAvion int primary key,
  modelo varchar(6) NOT NULL,
  marca text not null,
  capacidadPrimera int NOT NULL check(capacidadPrimera > 0),
  capacidadTurista int NOT NULL check(capacidadTurista > 0),
  disponible varchar(1) not null check(disponible in ('y', 'n'))
);

create or replace function favions() returns trigger as $tavions$
  begin 
    if (select max(idavion) from avions) is null then new.idAvion = 1;
    return new
    end if;
    new.idavion = (select max(idavions) from avions) + 1;
    return new;
  end;
$tavions$ language plpgsql;

create trigger tavions
before insert on avions
for each row
execute procedure favions()

--como insertar en la tabla avion
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values (/* 'string' */, /* 'string' */, /*int*/, /*int*/, /*'char'*/);

/*
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values ('AC-90', 'Airbong' , 40, 100, 'y');
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values ('D-23', 'Airbong', 23, 80, 'y');
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values ('A-12D', 'McMarell', 20, 60, 'y');
*/


--tabla ciudad
--tiempoviaje es en minutos
drop table ciudads
CREATE TABLE ciudads(
  nombre text NOT NULL,
  pais text NOT NULL,
  distancia int NOT NULL check(distancia >= 0),
  descripcion text not null
);
alter table ciudads
add constraint ciudadsc
primary key (nombre);
drop table ciudads

--como insertar en la tabla ciudad
insert into ciudad
values (/* 'string' */, /* 'string' */, /*float*/, /*int*/);

/*
insert into ciudad
values ('Acapulco', 'Mexico', 400.00, 30);
insert into ciudad
values ('Monterrey', 'Mexico', 650.00, 200);
insert into ciudad
values ('Guadalajara', 'Mexico', 500.00, 70);
*/


--tabla login
CREATE TABLE login(
  correo text not null,
  contraseña varchar(18) not null,
  activo char(1) not null check(activo in ('y', 'n'))
);
alter table login
add constraint loginc
primary key (correo);

create or replace function flogin() returns trigger as $tlogin$
  begin 
    new.activo = 'y';
    return new;
  end;
$tlogin$ language plpgsql;

create trigger tlogin
before insert on login
for each row
execute procedure flogin()

--como insertar en la tabla login
insert into login
values (/*'string'*/, /*'string'*/, /*'char'*/);

/*
insert into login
values ('dsaa@hotmail.com', '1234', 'n');
insert into login
values ('vfgbf@hotmail.com', '123ab', 'n');
insert into login
values ('sffd@hotmail.com', '23ge', 'n');
insert into login
values ('htdf@hotmail.com', 'abcs', 'n');
insert into login
values ('sggds@hotmail.com', 'porsa', 'n');
insert into login
values ('lksd@hotmail.com', 'perd', 'n');
insert into login
values ('kfds@hotmail.com', 'jghg', 'n');
insert into login
values ('str@hotmail.com', 'str', 'n');
insert into login
values ('stri@hotmail.com', 'ring', 'n');
insert into login
values ('strin@hotmail.com', 'trin', 'n');
*/

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
    if (select min(idusuario) from usuarios) <> 1 then new.usuario = 1;
    end if;
    else new.idusuario = (select max(idusuario) from usuarios) + 1;
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


--tarjetas que posee el usuario
CREATE TABLE tarjetausuario(
  noTarjeta varchar(16) not null references tarjetas,
  idusuario int not null references usuarios(idusuario)
);

create table tarjetas(
  noTarjeta varchar(16) not null primary key,
  valor int,
  saldo double precision
);


--tabla promocion
CREATE TABLE promocions(
  idPromocion integer not null,
  porcentaje double precision not null check(porcentaje > 0 and porcentaje < 1),
  fechaEntrada date not null,
  vigencia date not null check(vigencia > fechaEntrada),
  unique (porcentaje, fechaEntrada, vigencia)
);
--insert into promocion values (10, 0.30, '12-11-2014', '13-11-2014')
alter table promocions
add constraint proomocionsc
primary key (idPromocion);

create or replace function fpromocions() returns trigger as $tpromocions$
  begin 
    new.porcentaje = 1 - new.porcentaje;
    if (select max(idpromocion) from promocions) is null then new.idpromocion = 1;
    return new;
    end if;
    new.idpromocion = (select max(idpromocion) from promocions) + 1;
    return new;
  end;
$tpromocions$ language plpgsql;

create trigger tpromocions
before insert on promocions
for each row
execute procedure fpromocions()

--como insertar en la tabla promocion
insert into promocion
values (/*(select max(idPromocion) from promocion) + 1*/, /*'string'*/, /*double*/, /*'dd-MM-yyyy'*/, /*'dd-MM-yyyy'*/);

--tabla viaje
CREATE TABLE viaje(
  idViaje int not null,
  origen text not null references ciudads(nombre),
  destino text not null references ciudads(nombre) check(destino <> origen),  
  fechasalida date not null,
  horasalida time not null,
  fechallegada date,
  horallegada time,
  distancia int,
  idAvion int not null references avions(idAvion),
  costoViaje double precision,
  realizado char(1) not null check (realizado in ('y', 'n'))
);
alter table viaje
add column tiempo interval
add constraint viajec
primary key (idViaje);

create or replace function fviaje() returns trigger as $tviaje$
  begin 
    if new.idviaje is null then new.idviaje = (select max(idviaje) from viaje) + 1;
    end if;
    if new.fechasalida = (select current_date) then new.date = null;
    end if;
    new.distancia = (select distancia from ciudads where new.destino = nombre) - (select distancia from ciudads where new.origen = nombre);
    if new.distancia < 0 then new.distancia = new.distancia * (-1);
    end if;
    new.tiempo = cast((cast(new.distancia as double precision)/ cast(180 as double precision)) as double precision) * cast('1 hour' as interval);
    new.horallegada = new.horasalida + ((cast(new.distancia as double precision)/ cast(180 as double precision)) * cast('01:00' as interval));
    new.fechallegada = new.fechasalida + new.horasalida + ((cast(new.distancia as double precision)/ cast(1080 as double precision)) * cast('01:00' as interval));
    new.costoViaje = new.distancia * (select costomilla from valor);
    update viaje set realizado = 'y' where fechasalida + horasalida <= (select current_timestamp);
    return new;
  end;
$tviaje$ language plpgsql;

create trigger tviaje
before insert on viaje
for each row
execute procedure fviaje()

insert into viaje values(null, 'Mexico', 'Ciudad de México', '13-11-2014', '16:00', null, null, null, 3, null, 'n', null)
--como insertar en la tabla viaje
insert into viaje
values (/*(select max(idViaje) from viaje) + 1*/, /*'string'*/, /*'string'*/, /*'dd-MM-yyyy'*/, /*'string'*/, /*'string'*/, /*int*/, /*double*/);
insert into viaje values (4, 'Mexico', 'Ciudad de México', '10-11-2014', '14:00', '01:00', null, 15, 30.00, 'n');
values (/*(select max(idViaje) from viaje) + 1*/, /*'string'*/, /*'string'*/, /*'dd-MM-yyyy'*/, /*'string'*/, /*'string'*/, /*int*/, /*double*/);

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
CREATE TABLE viajepromocion(
  idViaje serial not null references viaje(idViaje),
  idpromocion serial not null references promocion(idpromocion),
  unique (idViaje)
);


--tabla pasajero (los usuarios que han viajado y los que viajes han tomado)
CREATE TABLE pasajero(
  dni serial not null references usuario(dni),
  idViaje serial not null,
  clase text not null check (clase in ('Primera', 'Turista')),
  asiento integer not null
);
alter table pasajero
add constraint pasajeroc1
unique (idViaje, clase, asiento);

--como insertar en pasajero
insert into pasajero
values (/*int*/, /*int*/, /*'string'*/, /*int*/);
