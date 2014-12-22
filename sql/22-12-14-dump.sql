--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: favion(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION favion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      begin 
        if new.idavion is null then new.idavion = (select max(idavion) from avions) + 1;
        end if;
      return new;
      end;
      $$;


ALTER FUNCTION public.favion() OWNER TO mamelines;

--
-- Name: fhoras(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION fhoras() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin
    new.horasalida = cast(new.horasalida::time without time zone ||' '|| (select zonahora from ciudads where nombre = new.origen) as time with time zone);
    new.horallegada = (new.horasalida + new.tiempo)::time with time zone at time zone (select zonahora from ciudads where nombre = new.destino);
    new.fechallegada = cast(cast(((select current_date)+ new.horasalida + new.tiempo)::timestamp with time zone at time zone (select zonahora from ciudads where nombre = new.destino) as timestamp) as date);
    return new;
  end;
$$;


ALTER FUNCTION public.fhoras() OWNER TO mamelines;

--
-- Name: fpromocion(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION fpromocion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin 
    new.porcentaje = 1 - new.porcentaje;
    if (select max(idpromocion) from promocion) is null then new.idpromocion = 1;
    return new;
    end if;
    new.idpromocion = (select max(idpromocion) from promocion) + 1;
    return new;
  end;
$$;


ALTER FUNCTION public.fpromocion() OWNER TO mamelines;

--
-- Name: fpromocions(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION fpromocions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        begin 
          if new.idpromocion is null then new.idpromocion = (select max(idpromocion) from promocions) + 1;
          end if;
        return new;
      end;
    $$;


ALTER FUNCTION public.fpromocions() OWNER TO mamelines;

--
-- Name: fusuarios(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION fusuarios() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      begin 
        if new.idusuario is null then new.idusuario = (select max(idusuario) from usuarios) + 1;
        end if;
        return new;
      end;
      $$;


ALTER FUNCTION public.fusuarios() OWNER TO mamelines;

--
-- Name: fvalor(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION fvalor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin 
    new.fecha = (select current_date);
    if (select max(idvalor) from valor) is null then new.idvalor = 1;
    return null;
    end if;
    new.idvalor = (select max(idvalor) from valor) + 1;
    return new;
  end;
$$;


ALTER FUNCTION public.fvalor() OWNER TO mamelines;

--
-- Name: fvalors(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION fvalors() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin 
    if (select max(idvalor) from valor) is null then new.idvalor = 1;
    return null;
    end if;
    new.idvalor = (select max(idvalor) from valor) + 1;
    return new;
  end;
$$;


ALTER FUNCTION public.fvalors() OWNER TO mamelines;

--
-- Name: fviaje(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION fviaje() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.fviaje() OWNER TO mamelines;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: administrador; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE administrador (
    correo text NOT NULL,
    nombres text NOT NULL,
    apellidos text NOT NULL
);


ALTER TABLE public.administrador OWNER TO mamelines;

--
-- Name: avion; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE avion (
    idavion integer NOT NULL,
    modelo character varying(6) NOT NULL,
    marca text NOT NULL,
    capacidadprimera integer NOT NULL,
    capacidadturista integer NOT NULL,
    disponible character varying(1),
    CONSTRAINT avions_capacidadprimera_check CHECK ((capacidadprimera > 0)),
    CONSTRAINT avions_capacidadturista_check CHECK ((capacidadturista > 0)),
    CONSTRAINT avions_disponible_check CHECK (((disponible)::text = ANY (ARRAY[('y'::character varying)::text, ('n'::character varying)::text])))
);


ALTER TABLE public.avion OWNER TO mamelines;

--
-- Name: avions; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE avions (
    idavion integer NOT NULL,
    modelo character varying(6) NOT NULL,
    marca text NOT NULL,
    capacidadprimera integer NOT NULL,
    capacidadturista integer NOT NULL,
    disponible character varying(1),
    CONSTRAINT avions_capacidadprimera_check CHECK ((capacidadprimera > 0)),
    CONSTRAINT avions_capacidadturista_check CHECK ((capacidadturista > 0)),
    CONSTRAINT avions_disponible_check CHECK (((disponible)::text = ANY (ARRAY[('y'::character varying)::text, ('n'::character varying)::text])))
);


ALTER TABLE public.avions OWNER TO mamelines;

--
-- Name: ciudads; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE ciudads (
    nombre text NOT NULL,
    pais text NOT NULL,
    distancia integer,
    descripcion text NOT NULL,
    zonahora text NOT NULL,
    aeropuerto text NOT NULL,
    "IATA" text,
    CONSTRAINT ciudad_distancia_check CHECK ((distancia >= 0))
);


ALTER TABLE public.ciudads OWNER TO mamelines;

--
-- Name: horas; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE horas (
    origen text NOT NULL,
    destino text NOT NULL,
    fechasalida date NOT NULL,
    horasalida time with time zone NOT NULL,
    tiempo interval,
    fechallegada date,
    horallegada time with time zone
);


ALTER TABLE public.horas OWNER TO mamelines;

--
-- Name: logins; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE logins (
    correo text NOT NULL,
    secreto character varying(50) NOT NULL,
    activo character(1) NOT NULL,
    CONSTRAINT logins_activo_check CHECK ((activo = ANY (ARRAY['y'::bpchar, 'n'::bpchar])))
);


ALTER TABLE public.logins OWNER TO mamelines;

--
-- Name: promocion; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE promocion (
    idpromocion integer NOT NULL,
    porcentaje double precision NOT NULL,
    fechaentrada date NOT NULL,
    vigencia date NOT NULL,
    CONSTRAINT promocion_check CHECK ((vigencia > fechaentrada)),
    CONSTRAINT promocion_porcentaje_check CHECK (((porcentaje > (0)::double precision) AND (porcentaje < (1)::double precision)))
);


ALTER TABLE public.promocion OWNER TO mamelines;

--
-- Name: promociones; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE promociones (
    idpromocion integer NOT NULL,
    codigopromocion character varying(10) NOT NULL,
    porcentaje double precision NOT NULL,
    fechaentrada date NOT NULL,
    vigencia date NOT NULL,
    CONSTRAINT promocions_porcentaje_check CHECK (((porcentaje > (0)::double precision) AND (porcentaje < (1)::double precision)))
);


ALTER TABLE public.promociones OWNER TO mamelines;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO mamelines;

--
-- Name: tarjeta; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE tarjeta (
    notarjeta character varying(16) NOT NULL,
    idusuario integer NOT NULL,
    valor integer,
    saldo numeric(10,2)
);


ALTER TABLE public.tarjeta OWNER TO mamelines;

--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE usuarios (
    correo text NOT NULL,
    idusuario integer NOT NULL,
    nombres text NOT NULL,
    apellidopaterno text NOT NULL,
    apellidomaterno text NOT NULL,
    nacionalidad text NOT NULL,
    genero text NOT NULL,
    fechanacimiento date NOT NULL,
    url_imagen text,
    CONSTRAINT usuarios_genero_check CHECK ((genero = ANY (ARRAY[('H'::character varying)::text, ('M'::character varying)::text])))
);


ALTER TABLE public.usuarios OWNER TO mamelines;

--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE; Schema: public; Owner: mamelines
--

CREATE SEQUENCE usuarios_idusuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_idusuario_seq OWNER TO mamelines;

--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mamelines
--

ALTER SEQUENCE usuarios_idusuario_seq OWNED BY usuarios.idusuario;


--
-- Name: valor; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE valor (
    idvalor integer NOT NULL,
    costomilla double precision NOT NULL,
    tipomoneda text NOT NULL,
    tipomedida text NOT NULL,
    CONSTRAINT valor_idvalor_check CHECK (((idvalor > 0) AND (idvalor < 2)))
);


ALTER TABLE public.valor OWNER TO mamelines;

--
-- Name: viajes; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE viajes (
    idviaje integer NOT NULL,
    origen text NOT NULL,
    destino text NOT NULL,
    fechasalida date NOT NULL,
    horasalida time without time zone NOT NULL,
    fechallegada date,
    horallegada time without time zone,
    distancia integer,
    idavion integer NOT NULL,
    costoviaje double precision,
    realizado character(1) NOT NULL,
    tiempo interval,
    CONSTRAINT viaje_check CHECK ((destino <> origen)),
    CONSTRAINT viaje_realizado_check CHECK ((realizado = ANY (ARRAY['y'::bpchar, 'n'::bpchar])))
);


ALTER TABLE public.viajes OWNER TO mamelines;

--
-- Name: vuelos; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE vuelos (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.vuelos OWNER TO mamelines;

--
-- Name: vuelos_id_seq; Type: SEQUENCE; Schema: public; Owner: mamelines
--

CREATE SEQUENCE vuelos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vuelos_id_seq OWNER TO mamelines;

--
-- Name: vuelos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mamelines
--

ALTER SEQUENCE vuelos_id_seq OWNED BY vuelos.id;


--
-- Name: idusuario; Type: DEFAULT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY usuarios ALTER COLUMN idusuario SET DEFAULT nextval('usuarios_idusuario_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY vuelos ALTER COLUMN id SET DEFAULT nextval('vuelos_id_seq'::regclass);


--
-- Data for Name: administrador; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY administrador (correo, nombres, apellidos) FROM stdin;
\.


--
-- Data for Name: avion; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY avion (idavion, modelo, marca, capacidadprimera, capacidadturista, disponible) FROM stdin;
1	A320	Airbus	50	80	y
2	747-8	Boeing	110	190	y
3	737	Boeing	70	115	y
4	777	Boeing	90	140	y
5	787-DL	Boeing	60	100	y
6	A380	Airbus	70	100	y
7	A340	Airbus	80	130	y
8	DC-10	McDonnell Douglas	70	110	y
9	DC-9	McDonnell Douglas	90	130	y
10	MD-90	McDonnell Douglas	90	160	y
11	AN-148	Antonov	60	80	y
12	170	Embraer	70	100	y
13	MD-80	McDonnell Douglas	130	190	y
14	A330	Airbus	110	160	y
15	767	Boeing	80	150	y
16	ConcBA	Concorde British Air	130	190	y
17	CS-100	Bombardier Aerospace	80	130	y
18	ERJ175	Embraer	80	130	y
19	ERJ195	Embraer	100	150	y
20	MA60	Lao Airlines	20	80	y
1	A320	Airbus	50	80	y
2	747-8	Boeing	110	190	y
3	737	Boeing	70	115	y
4	777	Boeing	90	140	y
5	787-DL	Boeing	60	100	y
6	A380	Airbus	70	100	y
7	A340	Airbus	80	130	y
8	DC-10	McDonnell Douglas	70	110	y
9	DC-9	McDonnell Douglas	90	130	y
10	MD-90	McDonnell Douglas	90	160	y
11	AN-148	Antonov	60	80	y
12	170	Embraer	70	100	y
13	MD-80	McDonnell Douglas	130	190	y
14	A330	Airbus	110	160	y
15	767	Boeing	80	150	y
16	ConcBA	Concorde British Air	130	190	y
17	CS-100	Bombardier Aerospace	80	130	y
18	ERJ175	Embraer	80	130	y
19	ERJ195	Embraer	100	150	y
20	MA60	Lao Airlines	20	80	y
\.


--
-- Data for Name: avions; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY avions (idavion, modelo, marca, capacidadprimera, capacidadturista, disponible) FROM stdin;
1	A320	Airbus	50	80	y
2	747-8	Boeing	110	190	y
3	737	Boeing	70	115	y
4	777	Boeing	90	140	y
5	787-DL	Boeing	60	100	y
6	A380	Airbus	70	100	y
7	A340	Airbus	80	130	y
8	DC-10	McDonnell Douglas	70	110	y
9	DC-9	McDonnell Douglas	90	130	y
10	MD-90	McDonnell Douglas	90	160	y
11	AN-148	Antonov	60	80	y
12	170	Embraer	70	100	y
13	MD-80	McDonnell Douglas	130	190	y
14	A330	Airbus	110	160	y
15	767	Boeing	80	150	y
16	ConcBA	Concorde British Air	130	190	y
17	CS-100	Bombardier Aerospace	80	130	y
18	ERJ175	Embraer	80	130	y
19	ERJ195	Embraer	100	150	y
20	MA60	Lao Airlines	20	80	y
\.


--
-- Data for Name: ciudads; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY ciudads (nombre, pais, distancia, descripcion, zonahora, aeropuerto, "IATA") FROM stdin;
Abu Dhabi	Emiratos Árabes Unidos	8894	fssd	GST	Aeropuerto Internacional de Abu Dabi	EAU
Amsterdam	Holanda	5713	fssd	CET	Amsterdam Schiphol Airport	NED
Berlin	Alemania	6047	fssd	CET	dsf	BER
Buenos Aires	Argentina	4545	fssd	America/Cordoba	Aeropuerto Internacional de Ezeiza	BAR
Busan	Corea del Sur	7516	fssd	KST	Gimhae International Airport	BSC
Ciudad de México	México	0	dasda	CST	Aeropuerto Internacional de la Ciudad de México	MEX
Dubai	Emiratos Árabes Unidos	8902	fssd	GST	Aeropuerto Internacional de Dubái	EAD
El Cairo	Egipto	7583	fssd	EET	Cairo International Airport	CIA
Estambul	Turquia	7089	fssd	EET	Aeropuerto Internacional Atatürk	EIA
Florencia	Italia	6253	fssd	CET	ad	FIA
Frankfur	Alemania	5939	fssd	CET	Frankfurt Airport	FAI
Hamburgo	Alemania	5867	jhiu	CET	Aeropuerto de Hamburgo-Fuhlsbüttel	HAI
Hong Kong	China	8790	fssd	HKT	Hong Kong International Airport	HKA
Incheon	Corea del Sur	7502	fssd	KST	Incheon International Airport	ICN
Jeju Do	Corea del Sur	7497	fssd	KST	Jeju International Airport	JCS
Jerusalén	Israel	7720	fssd	IST	Aeropuerto Internacional Ben Gurión	JEI
Munich	Alemania	6089	fssd	CET	Munich Airport	MUX
Pekin	China	7746	fssd	CNT	Beijing Capital International Airport	PKC
Porto Alegre	Brasil	4498	fssd	AMT	Aeropuerto de Porto Alegre	PAB
Seul	Corea del Sur	7492	fssd	KST	Gimpo International Airport	SCN
Shangai	China	8012	fssd	CNT	Shanghai Hongqiao International Airport	SHC
Tokio	Japan	7002	fssd	JST	Tokyo International Airport Haneda	TKP
Tokoname	Japan	7182	fssd	JST	Central Japan International Airport	TKN
Vancouver	Canada	2452	fssd	PST	Vancouver International Airport	VCC
\.


--
-- Data for Name: horas; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY horas (origen, destino, fechasalida, horasalida, tiempo, fechallegada, horallegada) FROM stdin;
Ciudad de México	Berlin	2014-11-20	19:33:25.998385-06	02:30:00	2014-11-21	05:03:25.998385+01
Berlin	Ciudad de México	2014-11-21	00:43:00.146352-01	02:30:00	2014-11-19	22:13:00.146352-06
Ciudad de México	Berlin	2014-11-20	20:07:48.707139-06	02:30:00	2014-11-21	05:37:48.707139+01
Berlin	Ciudad de México	2014-11-21	20:10:02.66773+01	02:30:00	2014-11-20	15:40:02.66773-06
Berlin	Ciudad de México	2014-11-20	20:10:55.355825+01	02:30:00	2014-11-20	15:40:55.355825-06
\.


--
-- Data for Name: logins; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY logins (correo, secreto, activo) FROM stdin;
ndrd@ciencias.unam.mx	1d8518b5ffe107be80a067d9f3b686125d51e251	y
\.


--
-- Data for Name: promocion; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY promocion (idpromocion, porcentaje, fechaentrada, vigencia) FROM stdin;
1	0.800000000000000044	2014-11-12	2014-11-13
2	0.699999999999999956	2014-11-12	2014-11-13
\.


--
-- Data for Name: promociones; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY promociones (idpromocion, codigopromocion, porcentaje, fechaentrada, vigencia) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY schema_migrations (version) FROM stdin;
20141107074550
20141107075550
20141107151614
20141108004149
20141108011251
20141108014710
20141108020558
20141108025737
0
20141109022725
20141109042323
20141109044133
20141109045000
20141109050311
20141109051432
20141109202347
20141109204156
20141109205812
20141112034059
\.


--
-- Data for Name: tarjeta; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY tarjeta (notarjeta, idusuario, valor, saldo) FROM stdin;
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY usuarios (correo, idusuario, nombres, apellidopaterno, apellidomaterno, nacionalidad, genero, fechanacimiento, url_imagen) FROM stdin;
ndrd@ciencias.unam.mx	2	Jonathan de Jesus	Lopez	Andrade	mxn	H	2014-12-22	\N
\.


--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE SET; Schema: public; Owner: mamelines
--

SELECT pg_catalog.setval('usuarios_idusuario_seq', 2, true);


--
-- Data for Name: valor; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY valor (idvalor, costomilla, tipomoneda, tipomedida) FROM stdin;
1	0.23000000000000001	dollar	milla
\.


--
-- Data for Name: viajes; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY viajes (idviaje, origen, destino, fechasalida, horasalida, fechallegada, horallegada, distancia, idavion, costoviaje, realizado, tiempo) FROM stdin;
5	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-11	17:34:30	189	3	75.6000000000000085	n	01:34:30
3	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-11	17:34:30	189	3	75.6000000000000085	n	01:34:30
6	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-11	17:34:30	189	3	22.6799999999999997	n	01:34:30
7	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-11	17:00:00	189	3	22.6799999999999997	n	01:34:30
8	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-11	17:34:30	189	3	22.6799999999999997	n	01:34:30
9	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-11	16:08:43.384615	189	3	22.6799999999999997	n	00:08:43.384615
10	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-11	16:10:30	189	3	22.6799999999999997	n	00:10:30
11	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-15	03:37:53.333333	90322	3	10838.6399999999994	n	83:37:53.333333
4	Mexico	Ciudad de México	2014-11-11	16:00:00	2014-11-11	13:34:30	189	3	75.6000000000000085	n	01:34:30
1	Mexico	Ciudad de México	2014-11-11	12:00:00	2014-11-11	13:34:30	189	1	75.6000000000000085	y	01:34:30
2	Mexico	Ciudad de México	2014-11-08	13:00:00	2014-11-08	14:34:30	189	2	75.6000000000000085	y	01:34:30
12	Mexico	Ciudad de México	2014-11-13	16:00:00	2014-11-13	16:11:20	34	3	4.08000000000000007	n	00:11:20
\.


--
-- Data for Name: vuelos; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY vuelos (id, created_at, updated_at) FROM stdin;
1	2014-12-19 18:45:06.177961	2014-12-19 18:45:06.177961
\.


--
-- Name: vuelos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mamelines
--

SELECT pg_catalog.setval('vuelos_id_seq', 1, true);


--
-- Name: adiministradorc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY administrador
    ADD CONSTRAINT adiministradorc PRIMARY KEY (correo);


--
-- Name: adminc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY administrador
    ADD CONSTRAINT adminc UNIQUE (correo);


--
-- Name: administrador_correo_key; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY administrador
    ADD CONSTRAINT administrador_correo_key UNIQUE (correo);


--
-- Name: avions_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY avions
    ADD CONSTRAINT avions_pkey PRIMARY KEY (idavion);


--
-- Name: ciudadc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY ciudads
    ADD CONSTRAINT ciudadc PRIMARY KEY (nombre);


--
-- Name: horasc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY horas
    ADD CONSTRAINT horasc PRIMARY KEY (origen, destino, fechasalida, horasalida);


--
-- Name: loginc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY logins
    ADD CONSTRAINT loginc PRIMARY KEY (correo);


--
-- Name: promocion_porcentaje_fechaentrada_vigencia_key; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY promocion
    ADD CONSTRAINT promocion_porcentaje_fechaentrada_vigencia_key UNIQUE (porcentaje, fechaentrada, vigencia);


--
-- Name: proomocionc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY promocion
    ADD CONSTRAINT proomocionc PRIMARY KEY (idpromocion);


--
-- Name: proomocionsc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY promociones
    ADD CONSTRAINT proomocionsc PRIMARY KEY (idpromocion);


--
-- Name: tarjetas_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY tarjeta
    ADD CONSTRAINT tarjetas_pkey PRIMARY KEY (notarjeta);


--
-- Name: usuariosc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuariosc PRIMARY KEY (idusuario);


--
-- Name: valor_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY valor
    ADD CONSTRAINT valor_pkey PRIMARY KEY (idvalor);


--
-- Name: viajec; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY viajes
    ADD CONSTRAINT viajec PRIMARY KEY (idviaje);


--
-- Name: vuelos_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY vuelos
    ADD CONSTRAINT vuelos_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: rviaje; Type: RULE; Schema: public; Owner: mamelines
--

CREATE RULE rviaje AS
    ON UPDATE TO viajes DO INSTEAD NOTHING;


--
-- Name: tavion; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tavion BEFORE INSERT ON avions FOR EACH ROW EXECUTE PROCEDURE favion();


--
-- Name: tavion; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tavion BEFORE INSERT ON avion FOR EACH ROW EXECUTE PROCEDURE favion();


--
-- Name: thoras; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER thoras BEFORE INSERT ON horas FOR EACH ROW EXECUTE PROCEDURE fhoras();


--
-- Name: tpromocion; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tpromocion BEFORE INSERT ON promocion FOR EACH ROW EXECUTE PROCEDURE fpromocion();


--
-- Name: tpromocions; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tpromocions BEFORE INSERT ON promociones FOR EACH ROW EXECUTE PROCEDURE fpromocions();


--
-- Name: tvalor; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tvalor BEFORE INSERT ON valor FOR EACH ROW EXECUTE PROCEDURE fvalor();


--
-- Name: tvalors; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tvalors BEFORE INSERT ON valor FOR EACH ROW EXECUTE PROCEDURE fvalors();


--
-- Name: tviaje; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tviaje BEFORE INSERT ON viajes FOR EACH ROW EXECUTE PROCEDURE fviaje();


--
-- Name: administrador_correo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY administrador
    ADD CONSTRAINT administrador_correo_fkey FOREIGN KEY (correo) REFERENCES logins(correo);


--
-- Name: horas_destino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY horas
    ADD CONSTRAINT horas_destino_fkey FOREIGN KEY (destino) REFERENCES ciudads(nombre);


--
-- Name: horas_origen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY horas
    ADD CONSTRAINT horas_origen_fkey FOREIGN KEY (origen) REFERENCES ciudads(nombre);


--
-- Name: usuarios_correo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_correo_fkey FOREIGN KEY (correo) REFERENCES logins(correo);


--
-- Name: viaje_destino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY viajes
    ADD CONSTRAINT viaje_destino_fkey FOREIGN KEY (destino) REFERENCES ciudads(nombre);


--
-- Name: viaje_idavion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY viajes
    ADD CONSTRAINT viaje_idavion_fkey FOREIGN KEY (idavion) REFERENCES avions(idavion);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

