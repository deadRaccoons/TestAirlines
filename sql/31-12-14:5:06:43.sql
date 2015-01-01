--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2014-12-31 23:06:00 CST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 189 (class 3079 OID 12694)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3037 (class 0 OID 0)
-- Dependencies: 189
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 196 (class 1255 OID 57661)
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
-- TOC entry 210 (class 1255 OID 58191)
-- Name: fcancelado(); Type: FUNCTION; Schema: public; Owner: mamelines
--

CREATE FUNCTION fcancelado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin 
    update viajes set realizado = 'c' where idviaje = new.idviaje;
    return new;
  end;
$$;


ALTER FUNCTION public.fcancelado() OWNER TO mamelines;

--
-- TOC entry 203 (class 1255 OID 57662)
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
-- TOC entry 204 (class 1255 OID 57663)
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
-- TOC entry 205 (class 1255 OID 57664)
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
-- TOC entry 206 (class 1255 OID 57665)
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
-- TOC entry 207 (class 1255 OID 57666)
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
-- TOC entry 208 (class 1255 OID 57667)
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
-- TOC entry 209 (class 1255 OID 57668)
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
-- TOC entry 170 (class 1259 OID 58347)
-- Name: administrador; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE administrador (
    correo text NOT NULL,
    nombres text NOT NULL,
    apellidos text NOT NULL
);


ALTER TABLE public.administrador OWNER TO mamelines;

--
-- TOC entry 171 (class 1259 OID 58353)
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
-- TOC entry 172 (class 1259 OID 58362)
-- Name: avions; Type: VIEW; Schema: public; Owner: mamelines
--

CREATE VIEW avions AS
 SELECT avion.modelo,
    avion.marca,
    avion.capacidadprimera,
    avion.capacidadturista
   FROM avion
  WHERE (avion.idavion < 21);


ALTER TABLE public.avions OWNER TO mamelines;

--
-- TOC entry 173 (class 1259 OID 58366)
-- Name: cancelados; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE cancelados (
    idviaje integer NOT NULL
);


ALTER TABLE public.cancelados OWNER TO mamelines;

--
-- TOC entry 174 (class 1259 OID 58369)
-- Name: ciudades; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE ciudades (
    nombre text NOT NULL,
    pais text NOT NULL,
    distancia integer,
    descripcion text NOT NULL,
    zonahora text NOT NULL,
    aeropuerto text NOT NULL,
    "IATA" text,
    slug text,
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    photo_file_size integer,
    photo_updated_at timestamp without time zone,
    CONSTRAINT ciudad_distancia_check CHECK ((distancia >= 0))
);


ALTER TABLE public.ciudades OWNER TO mamelines;

--
-- TOC entry 175 (class 1259 OID 58376)
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
-- TOC entry 188 (class 1259 OID 66018)
-- Name: nosotros_infos; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE nosotros_infos (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.nosotros_infos OWNER TO mamelines;

--
-- TOC entry 187 (class 1259 OID 66016)
-- Name: nosotros_infos_id_seq; Type: SEQUENCE; Schema: public; Owner: mamelines
--

CREATE SEQUENCE nosotros_infos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nosotros_infos_id_seq OWNER TO mamelines;

--
-- TOC entry 3038 (class 0 OID 0)
-- Dependencies: 187
-- Name: nosotros_infos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mamelines
--

ALTER SEQUENCE nosotros_infos_id_seq OWNED BY nosotros_infos.id;


--
-- TOC entry 176 (class 1259 OID 58383)
-- Name: promocion; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE promocion (
    idpromocion integer NOT NULL,
    codigopromocion character varying(255) NOT NULL,
    iniciopromo date NOT NULL,
    finpromo date NOT NULL,
    ciudad text NOT NULL,
    descripcion text NOT NULL,
    slug text NOT NULL,
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    photo_file_size integer,
    photo_updated_at timestamp without time zone,
    porcentaje double precision
);


ALTER TABLE public.promocion OWNER TO mamelines;

--
-- TOC entry 177 (class 1259 OID 58389)
-- Name: promociones; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE promociones (
    idpromocion integer NOT NULL,
    codigopromocion character varying(255) NOT NULL,
    iniciopromo date NOT NULL,
    finpromo date NOT NULL,
    ciudad text NOT NULL,
    descripcion text NOT NULL,
    slug text NOT NULL,
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    photo_file_size integer,
    photo_updated_at timestamp without time zone
);


ALTER TABLE public.promociones OWNER TO mamelines;

--
-- TOC entry 178 (class 1259 OID 58395)
-- Name: promociones_idpromocion_seq; Type: SEQUENCE; Schema: public; Owner: mamelines
--

CREATE SEQUENCE promociones_idpromocion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promociones_idpromocion_seq OWNER TO mamelines;

--
-- TOC entry 3039 (class 0 OID 0)
-- Dependencies: 178
-- Name: promociones_idpromocion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mamelines
--

ALTER SEQUENCE promociones_idpromocion_seq OWNED BY promociones.idpromocion;


--
-- TOC entry 179 (class 1259 OID 58397)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO mamelines;

--
-- TOC entry 180 (class 1259 OID 58400)
-- Name: tarjeta; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE tarjeta (
    notarjeta character varying(16) NOT NULL,
    valor integer NOT NULL,
    idusuario integer NOT NULL,
    disponible character varying(1) NOT NULL,
    CONSTRAINT tarjeta_disponible_check CHECK (((disponible)::text = ANY (ARRAY[('y'::character varying)::text, ('n'::character varying)::text])))
);


ALTER TABLE public.tarjeta OWNER TO mamelines;

--
-- TOC entry 186 (class 1259 OID 58523)
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
    slug text,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    CONSTRAINT usuarios_genero_check CHECK ((genero = ANY (ARRAY[('H'::character varying)::text, ('M'::character varying)::text])))
);


ALTER TABLE public.usuarios OWNER TO mamelines;

--
-- TOC entry 185 (class 1259 OID 58521)
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
-- TOC entry 3040 (class 0 OID 0)
-- Dependencies: 185
-- Name: usuarios_idusuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mamelines
--

ALTER SEQUENCE usuarios_idusuario_seq OWNED BY usuarios.idusuario;


--
-- TOC entry 181 (class 1259 OID 58413)
-- Name: valor; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE valor (
    idvalor integer NOT NULL,
    costomilla double precision NOT NULL,
    fecha date NOT NULL,
    tipomoneda text NOT NULL,
    tipomedida text NOT NULL,
    CONSTRAINT valorc2 CHECK ((costomilla > (0)::double precision))
);


ALTER TABLE public.valor OWNER TO mamelines;

--
-- TOC entry 182 (class 1259 OID 58420)
-- Name: viajes; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE viajes (
    idviaje integer NOT NULL,
    origen text NOT NULL,
    destino text NOT NULL,
    fechasalida date NOT NULL,
    horasalida time with time zone NOT NULL,
    fechallegada date NOT NULL,
    horallegada time with time zone NOT NULL,
    distancia integer NOT NULL,
    tiempo interval NOT NULL,
    costoviaje double precision NOT NULL,
    realizado character(1) NOT NULL,
    idavion integer,
    CONSTRAINT viaje_check CHECK ((destino <> origen)),
    CONSTRAINT viajesc CHECK ((realizado = ANY (ARRAY['y'::bpchar, 'n'::bpchar, 'c'::bpchar])))
);


ALTER TABLE public.viajes OWNER TO mamelines;

--
-- TOC entry 183 (class 1259 OID 58428)
-- Name: vuelos; Type: TABLE; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE TABLE vuelos (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.vuelos OWNER TO mamelines;

--
-- TOC entry 184 (class 1259 OID 58431)
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
-- TOC entry 3041 (class 0 OID 0)
-- Dependencies: 184
-- Name: vuelos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mamelines
--

ALTER SEQUENCE vuelos_id_seq OWNED BY vuelos.id;


--
-- TOC entry 2859 (class 2604 OID 66021)
-- Name: id; Type: DEFAULT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY nosotros_infos ALTER COLUMN id SET DEFAULT nextval('nosotros_infos_id_seq'::regclass);


--
-- TOC entry 2851 (class 2604 OID 58433)
-- Name: idpromocion; Type: DEFAULT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY promociones ALTER COLUMN idpromocion SET DEFAULT nextval('promociones_idpromocion_seq'::regclass);


--
-- TOC entry 2857 (class 2604 OID 58526)
-- Name: idusuario; Type: DEFAULT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY usuarios ALTER COLUMN idusuario SET DEFAULT nextval('usuarios_idusuario_seq'::regclass);


--
-- TOC entry 2856 (class 2604 OID 58435)
-- Name: id; Type: DEFAULT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY vuelos ALTER COLUMN id SET DEFAULT nextval('vuelos_id_seq'::regclass);


--
-- TOC entry 3012 (class 0 OID 58347)
-- Dependencies: 170
-- Data for Name: administrador; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY administrador (correo, nombres, apellidos) FROM stdin;
tabo@gmail.com	Ricardo	Taboada
micorreo	minombre	miapellido
kub@hotmail.com	Jorge	Ascencio
micorreo@gmail.com	Minombre	Miapellido
\.


--
-- TOC entry 3013 (class 0 OID 58353)
-- Dependencies: 171
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
21	A320	Airbus	50	80	y
22	747-8	Boeing	110	190	y
23	737	Boeing	70	115	y
24	777	Boeing	90	140	y
25	787-DL	Boeing	60	100	y
26	A380	Airbus	70	100	y
27	A340	Airbus	80	130	y
28	DC-10	McDonnell Douglas	70	110	y
29	DC-9	McDonnell Douglas	90	130	y
30	MD-90	McDonnell Douglas	90	160	y
31	AN-148	Antonov	60	80	y
32	170	Embraer	70	100	y
33	MD-80	McDonnell Douglas	130	190	y
34	A330	Airbus	110	160	y
35	767	Boeing	80	150	y
36	ConcBA	Concorde British Air	130	190	y
37	CS-100	Bombardier Aerospace	80	130	y
38	ERJ175	Embraer	80	130	y
39	ERJ195	Embraer	100	150	y
40	MA60	Lao Airlines	20	80	y
41	A320	Airbus	50	80	y
42	747-8	Boeing	110	190	y
43	737	Boeing	70	115	y
44	777	Boeing	90	140	y
45	787-DL	Boeing	60	100	y
46	A380	Airbus	70	100	y
47	A340	Airbus	80	130	y
48	DC-10	McDonnell Douglas	70	110	y
49	DC-9	McDonnell Douglas	90	130	y
50	MD-90	McDonnell Douglas	90	160	y
51	AN-148	Antonov	60	80	y
52	170	Embraer	70	100	y
53	MD-80	McDonnell Douglas	130	190	y
54	A330	Airbus	110	160	y
55	767	Boeing	80	150	y
56	ConcBA	Concorde British Air	130	190	y
57	CS-100	Bombardier Aerospace	80	130	y
58	ERJ175	Embraer	80	130	y
59	ERJ195	Embraer	100	150	y
60	MA60	Lao Airlines	20	80	y
61	A320	Airbus	50	80	y
62	747-8	Boeing	110	190	y
63	737	Boeing	70	115	y
64	777	Boeing	90	140	y
65	787-DL	Boeing	60	100	y
66	A380	Airbus	70	100	y
67	A340	Airbus	80	130	y
68	DC-10	McDonnell Douglas	70	110	y
69	DC-9	McDonnell Douglas	90	130	y
70	MD-90	McDonnell Douglas	90	160	y
71	AN-148	Antonov	60	80	y
72	170	Embraer	70	100	y
73	MD-80	McDonnell Douglas	130	190	y
74	A330	Airbus	110	160	y
75	767	Boeing	80	150	y
76	ConcBA	Concorde British Air	130	190	y
77	CS-100	Bombardier Aerospace	80	130	y
78	ERJ175	Embraer	80	130	y
79	ERJ195	Embraer	100	150	y
80	MA60	Lao Airlines	20	80	y
81	A320	Airbus	50	80	y
82	747-8	Boeing	110	190	y
83	737	Boeing	70	115	y
84	777	Boeing	90	140	y
85	787-DL	Boeing	60	100	y
86	A380	Airbus	70	100	y
87	A340	Airbus	80	130	y
88	DC-10	McDonnell Douglas	70	110	y
89	DC-9	McDonnell Douglas	90	130	y
90	MD-90	McDonnell Douglas	90	160	y
91	AN-148	Antonov	60	80	y
92	170	Embraer	70	100	y
93	MD-80	McDonnell Douglas	130	190	y
94	A330	Airbus	110	160	y
95	767	Boeing	80	150	y
96	ConcBA	Concorde British Air	130	190	y
97	CS-100	Bombardier Aerospace	80	130	y
98	ERJ175	Embraer	80	130	y
99	ERJ195	Embraer	100	150	y
100	MA60	Lao Airlines	20	80	y
101	A320	Airbus	50	80	y
102	747-8	Boeing	110	190	y
103	737	Boeing	70	115	y
104	777	Boeing	90	140	y
105	787-DL	Boeing	60	100	y
106	A380	Airbus	70	100	y
107	A340	Airbus	80	130	y
108	DC-10	McDonnell Douglas	70	110	y
109	DC-9	McDonnell Douglas	90	130	y
110	MD-90	McDonnell Douglas	90	160	y
111	AN-148	Antonov	60	80	y
112	170	Embraer	70	100	y
113	MD-80	McDonnell Douglas	130	190	y
114	A330	Airbus	110	160	y
115	767	Boeing	80	150	y
116	ConcBA	Concorde British Air	130	190	y
117	CS-100	Bombardier Aerospace	80	130	y
118	ERJ175	Embraer	80	130	y
119	ERJ195	Embraer	100	150	y
120	MA60	Lao Airlines	20	80	y
121	A320	Airbus	50	80	y
122	747-8	Boeing	110	190	y
123	737	Boeing	70	115	y
124	777	Boeing	90	140	y
125	787-DL	Boeing	60	100	y
126	A380	Airbus	70	100	y
127	A340	Airbus	80	130	y
128	DC-10	McDonnell Douglas	70	110	y
129	DC-9	McDonnell Douglas	90	130	y
130	MD-90	McDonnell Douglas	90	160	y
131	AN-148	Antonov	60	80	y
132	170	Embraer	70	100	y
133	MD-80	McDonnell Douglas	130	190	y
134	A330	Airbus	110	160	y
135	767	Boeing	80	150	y
136	ConcBA	Concorde British Air	130	190	y
137	CS-100	Bombardier Aerospace	80	130	y
138	ERJ175	Embraer	80	130	y
139	ERJ195	Embraer	100	150	y
140	MA60	Lao Airlines	20	80	y
141	A320	Airbus	50	80	y
142	747-8	Boeing	110	190	y
143	737	Boeing	70	115	y
144	777	Boeing	90	140	y
145	787-DL	Boeing	60	100	y
146	A380	Airbus	70	100	y
147	A340	Airbus	80	130	y
148	DC-10	McDonnell Douglas	70	110	y
149	DC-9	McDonnell Douglas	90	130	y
150	MD-90	McDonnell Douglas	90	160	y
151	AN-148	Antonov	60	80	y
152	170	Embraer	70	100	y
153	MD-80	McDonnell Douglas	130	190	y
154	A330	Airbus	110	160	y
155	767	Boeing	80	150	y
156	ConcBA	Concorde British Air	130	190	y
157	CS-100	Bombardier Aerospace	80	130	y
158	ERJ175	Embraer	80	130	y
159	ERJ195	Embraer	100	150	y
160	MA60	Lao Airlines	20	80	y
\.


--
-- TOC entry 3014 (class 0 OID 58366)
-- Dependencies: 173
-- Data for Name: cancelados; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY cancelados (idviaje) FROM stdin;
4
5
8
\.


--
-- TOC entry 3015 (class 0 OID 58369)
-- Dependencies: 174
-- Data for Name: ciudades; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY ciudades (nombre, pais, distancia, descripcion, zonahora, aeropuerto, "IATA", slug, photo_file_name, photo_content_type, photo_file_size, photo_updated_at) FROM stdin;
Ciudad de México	México	0	dasda	CST	Aeropuerto Internacional de la Ciudad de México	MEX	ciudad-de-mexico	\N	\N	\N	\N
El Cairo	Egipto	7583	fssd	EET	Cairo International Airport	CIA	el-cairo	\N	\N	\N	\N
Estambul	Turquia	7089	fssd	EET	Aeropuerto Internacional Atatürk	EIA	estambul	\N	\N	\N	\N
Florencia	Italia	6253	fssd	CET	ad	FIA	florencia	\N	\N	\N	\N
Frankfur	Alemania	5939	fssd	CET	Frankfurt Airport	FAI	frankfur	\N	\N	\N	\N
Hamburgo	Alemania	5867	jhiu	CET	Aeropuerto de Hamburgo-Fuhlsbüttel	HAI	hamburgo	\N	\N	\N	\N
Hong Kong	China	8790	fssd	HKT	Hong Kong International Airport	HKA	hong-kong	\N	\N	\N	\N
Incheon	Corea del Sur	7502	fssd	KST	Incheon International Airport	ICN	incheon	\N	\N	\N	\N
Jeju Do	Corea del Sur	7497	fssd	KST	Jeju International Airport	JCS	jeju-do	\N	\N	\N	\N
Jerusalén	Israel	7720	fssd	IST	Aeropuerto Internacional Ben Gurión	JEI	jerusalen	\N	\N	\N	\N
Munich	Alemania	6089	fssd	CET	Munich Airport	MUX	munich	\N	\N	\N	\N
Porto Alegre	Brasil	4498	fssd	AMT	Aeropuerto de Porto Alegre	PAB	porto-alegre	\N	\N	\N	\N
Seul	Corea del Sur	7492	fssd	KST	Gimpo International Airport	SCN	seul	\N	\N	\N	\N
Tokio	Japan	7002	fssd	JST	Tokyo International Airport Haneda	TKP	tokio	\N	\N	\N	\N
Tokoname	Japan	7182	fssd	JST	Central Japan International Airport	TKN	tokoname	\N	\N	\N	\N
Vancouver	Canada	2452	fssd	PST	Vancouver International Airport	VCC	vancouver	\N	\N	\N	\N
Busan	Corea del Sur	7516	fssd	KST	Gimhae International Airport	BSC	busan	fearless-skyscraper-cat-windows-8-wallpaper-1280x800.jpg	image/jpeg	203492	2014-12-23 17:58:20.864356
Berlin	Alemania	6047	Berlín es la capital de Alemania y uno de los dieciséis estados federados alemanes. Se localiza al noreste de Alemania, a escasos 70 km de la frontera con Polonia. Por la ciudad fluyen los ríos Spree, Havel, Panke, Dahme y Wuhle	CET	Aeropuerto de Berlin Tegel	TXL	berlin	tech_berlin16__01__630x420.jpg	image/jpeg	150019	2014-12-23 17:31:56.703682
Amsterdam	Holanda	5713	Ámsterdam o Amsterdam, según la pronunciación etimológica, es la capital oficial de los Países Bajos. La ciudad está situada entre la bahía del IJ, al norte, y a las orillas del río Amstel, al sureste. 	CET	Amsterdam Schiphol Airport	NED	amsterdam	amsterdam-atardecer.jpg	image/jpeg	194152	2014-12-23 17:23:58.405869
Abu Dhabi	Emiratos Árabes Unidos	8894	fssd	GMT	Aeropuerto Internacional de Abu Dabi	EAU	abu-dhabi	\N	\N	\N	\N
Buenos Aires	Argentina	4545	Buenos Aires, formalmente Ciudad Autónoma de Buenos Aires ―también llamada Capital Federal por ser sede del gobierno federal ― es una de las veinticuatro entidades federales y capital de la República Argentina	-03	Aeropuerto de Buenos Aires Ezeiza	EZE	buenos-aires	buenos-aires.jpg	image/jpeg	714618	2014-12-23 17:33:39.233428
Dubai	Emiratos Árabes Unidos	8902	fssd	GMT	Aeropuerto Internacional de Dubái	EAD	dubai	\N	\N	\N	\N
Pekin	China	7746	fssd	+08	Beijing Capital International Airport	PKC	pekin	\N	\N	\N	\N
Shangai	China	8012	fssd	+08	Shanghai Hongqiao International Airport	SHC	shangai	\N	\N	\N	\N
\.


--
-- TOC entry 3016 (class 0 OID 58376)
-- Dependencies: 175
-- Data for Name: logins; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY logins (correo, secreto, activo) FROM stdin;
yorchek@hotmail.com	8755e6091050fea8ce7f540d816bd0076dc80264	y
ndrd.thn@hotmail.com	1d8518b5ffe107be80a067d9f3b686125d51e251	y
n@m.com	1d8518b5ffe107be80a067d9f3b686125d51e251	y
ndrd@ciencias.unam.mx	1d8518b5ffe107be80a067d9f3b686125d51e251	n
kuber@hotmail.com	1d8518b5ffe107be80a067d9f3b686125d51e251	n
joelandia.92@gmail.com	7110eda4d09e062aa5e4a390b0a572ac0d2c0220	n
ziuduomepoo@gmail.com	12bea32b25a03f16b7cadfce9a25a42e626bd61f	n
toquo@gmail.com	bb875cd4e7dea8f7783a5d228e63241ed1727e16	n
wuvioqiucoseso@yahoo.com	182b91585dd36933a760cd6036ca8de9f88749c5	n
kaawuowie@live.com	11c2ecfcd45ee19b44b75aed238e1c2c0a52eda6	n
zuofuexudeboxe@hotmail.com	f1ea9ffb882d77fb08c0b7149e89cee315ce5871	n
mezaequedaa@live.com	ed3d6c59df22ae98da4f07cd7f69d95beeb73728	n
qio@gmail.com	cb327dc00ce7155dd1b14da9ce297073a746209a	n
xavi@hotmail.com	11035b5a60c181732046c072fc45dae580e1274a	n
sirayozui@hotmail.com	f9759436593ebcd6345372e3722c65c167f92647	n
sisoacupohe@live.com	e755f480430e93dbd9a31700bbe12a7a49105528	n
ropibeafu@hotmail.com	71db9d9c08f62d6b888758e7d6c0fee87cfda074	n
muyiaqaaxujea@hotmail.com	51b258924212b6b43ff713edaa0262e19779c3da	n
qimidoho@gmail.com	407ad76fc36171d2734832681b1edbbd6bce9ad1	n
doxaco@hotmail.com	811e8b809528f7cb46ee34ca0f2df62481bdbfc1	n
wuojo@hotmail.com	38ae81ea2bfa84571b00441f8ddc0afc09e36206	n
mipugai@yahoo.com	394b8f297a5c2c808ee0bf05a6356f777944174e	n
buyizi@hotmail.com	e3c00aaef225424dece39b636bdef3ddf4b906b2	n
gebugui@gmail.com	5c2b01c5f9a2ca150adda2be0c015f41671c8554	n
peukeo@yahoo.com	c62e09ff5a82c07160a1f86ec1cc166a393bb104	n
gaigiejezaica@yahoo.com	3e3b772cff160b0d4437897ec13b2c05661c3131	n
kiude@yahoo.com	886fd9373abeb90b7bdc4535ea5b076a4580d303	n
zeasereokuzue@hotmail.com	3510437faf77c62393346407f6ab5cc05f454716	n
gaufavu@gmail.com	d8577309f1bb51d3c0c904df8e1835ef8216be19	n
muo@gmail.com	d30c44bcf9ef166e202de14353288883c8be3a87	n
juodiaqizixi@yahoo.com	22fc53c970bca5f2df4964d427de28dc41e8c6ac	n
voaveosoero@hotmail.com	4edbb6e6290ea030caceae0e648ff791e41b14d4	n
mayaviciupa@gmail.com	c8cb7cc8f145a8647bf3ec7138521e049087797b	n
ceara@live.com	00776b2988b88993a109b447c54f6019c59ee538	n
xue@hotmail.com	b0242301ae9a8da644a7c95f481d1ebf8dbf1ade	n
poebacuo@gmail.com	ac22bb43341ecf5d384e208a427d0cdbd4a1153e	n
dewuje@gmail.com	a7e2e7153fca3dcba6a6c15f02d7d71bed5df4a5	n
coefaa@live.com	8e464ce6b42c78cb8d3b04152a6a00145b989520	n
ceneayaajikege@live.com	9ea89caf8f8fed3d4b0014a7a5640abfd3003b6a	n
baveo@yahoo.com	ea53f294c70bf0b733010ffc848910bb80e714bc	n
cifa@live.com	8531c8ec0722661499c7dee741d9f701ce3c4e09	n
gezugea@live.com	4462a39e43d630dcc310d9d16724d2f511b3d6a4	n
fuoleepohuomueya@gmail.com	e1aab1508d13051d3f331108d52a0ef49b1f491a	n
dowaboqacu@hotmail.com	66d06aa6462d711ef47ac0bc58c26a59271fd4cb	n
qikaluili@gmail.com	f5f2588dfa729ae6205786001d30b9a503bf86ed	n
mibavaropawoi@live.com	88c2afd56dea67b0cc8ae29e7cd330c3e3c52fee	n
woxoucaruezi@hotmail.com	ad9b2a7ace1cee75b5c560b7ea1fa6834cb54ea2	n
toamue@hotmail.com	f725a4b87480961c72118b6c4a33181f930c7fc3	n
dii@hotmail.com	f6dca7c59617ecd3fe23b3663c9a6b7bb3e26ff7	n
bee@live.com	5ea0bad6ae8045b75d9cae31d35159c276180dd8	n
jaasuavau@hotmail.com	ec88eea10e0ad944a26cc04e63df71a3494fba3a	n
ni@hotmail.com	cf3401f7599cf2b183877d3117e72f9dbdb3a703	n
siohucodeyiu@yahoo.com	f271cb5ce33cef44360afe34b6b3618d68192b9f	n
muce@hotmail.com	f6d5004152fae26f94837e611f8620800c3784c9	n
hou@hotmail.com	4af3ba462426af4964852bd079a9a47620bcb457	n
sezee@gmail.com	12fc38325b7a73ba4f63b2d6b9bb1ecd0a8326b6	n
moeteihumafexua@yahoo.com	3cdc988404def62d070a672fa62bd9bd709f2a76	n
xivaluitee@hotmail.com	2c5bcee077876389c496e8230cb74f5b74856cb7	n
ridi@yahoo.com	ef7c219b31a1bbe6c7cd51341bb6519c30ab86aa	n
foba@live.com	a814453d246c508790862f9e8eba23939af49a86	n
zauluucio@live.com	7ec199436c0c29154dea87532be602b0e18cd9f3	n
poqiuhoigoifee@yahoo.com	3e34f87f30be745cb12e365381048c5d40ae6a00	n
muacoyepeekoeva@gmail.com	d98241381c69b7625068f7d99ec6bc615d92442f	n
ci@yahoo.com	071b8c4a96e151e68916a05cf2a24423178bdd5f	n
nea@gmail.com	b4404e9b711aca3c733205d7e6afc874b82e1ab4	n
pace@live.com	89337964ca214ca37b92fb2a32cdfcac23b4e4a3	n
ruucajaoqaigeo@hotmail.com	5d34c9e034ff4d881fb3d5b1666b0c3ecb571240	n
raaxii@yahoo.com	8add8124376e61cb74b74689f1727783729c561a	n
duujaokaximii@gmail.com	2814b5f3678e08104328b752a09dec5a740d0385	n
bozeibeazazi@live.com	a3973a981ebc40ca6691b2112b1314e0e2261ab1	n
jojazawiixii@live.com	9e5cd586bc8f0774bab75c884c5dc424e43b7d57	n
xiuroubotugee@live.com	03f9999364d69ca043ef24836ef24d48ad75ba8a	n
wao@gmail.com	d59bf56cac0d123ccd8d0a26cfa41a511883bace	n
xuinuoloa@live.com	b47c46fc0759d31f6bc14058afebd52944af90ec	n
rudexu@yahoo.com	cd06d2286c3cf78c9f0a941642c5ed97582840dc	n
fula@yahoo.com	ee7c26fa9e3889e25552e61b537c766ab67dfd15	n
jolewunutaivu@yahoo.com	3d5da52aa13bd7e3042171da944d0f63ab7b5d37	n
yuliefoorae@hotmail.com	692486e79a60ba022e0e3ef37bd527ba121c512d	n
ruqunaijeewo@hotmail.com	99bd956613b72b7352485749147e37b295c63edd	n
nu@live.com	2b287a079427ea4f9feb2826e647a56139a846ec	n
nua@gmail.com	d85cd6b0f0d26578477712a694ab861cebe98973	n
weviaxeque@gmail.com	5a0a85737b2eabff565e0dd9ec3ac61cf4390c77	n
jelue@live.com	ee6b620bdb75d56a710083c908c8f657306a559f	n
meutoopoi@gmail.com	0c778874dc90158e12dd93ef95893d05177f5136	n
tauwoumea@live.com	d535c4baa181768cc89c83ff5385364675af7669	n
xikusupuuzoa@yahoo.com	72641494aa295c4f8bc2eef1c39fcf2a95a2b9d8	n
pu@hotmail.com	980ce22d0e103284f05f208f76db9704017b5937	n
niipaqamu@live.com	8038299239fa40a88673deacfa6c86841d13c32f	n
sisotale@live.com	c5bfc54b32816f044a88c619e1720442a9693b29	n
liucixeohe@gmail.com	cddc2703fec662d7259ea57cbad4942c75bc5698	n
baaqia@live.com	407ae093bec5b85b4cdbe511793c55eacec5520f	n
niku@yahoo.com	864077985b50f455eef12b8ce368504464a52dbf	n
seuhiicuvexayeo@hotmail.com	f2b68f3b9a1b167a1d65155d8ea4343f1aed0c21	n
jodiwacilafu@yahoo.com	fb6b29575582efcf2f37e37f02df55b1264a8866	n
nizoavio@live.com	41572326f48c09583a28d61226ce07705d061a22	n
mibiocibe@live.com	dc7e52ec56e1d02dc146f5eb85828378cb153ca1	n
kieceizeasavae@gmail.com	21f67545c4d6e09c8027dc9acb1d2eba3106179b	n
jeiqujivocuo@live.com	adfd11afd5134dffa08bcaa7ac29ac64ac9bf2e5	n
habetapimuza@yahoo.com	3a77b9de5963bdee9c23dbd87ea4ae1e950eaa3e	n
gu@gmail.com	a832412a2bc8c6731fed090d75fdfc690608ed39	n
solauyui@yahoo.com	21953edf916c42c95b45a7a55d61c31f1eba166b	n
ju@gmail.com	9ee18dfaef1c8176d4f44ff87d3676695f7c035b	n
bo@gmail.com	82edb8c8ae3a28dd3fd9f23d8038ececf9007769	n
dofaebiwehoo@hotmail.com	b0317b8f2be8cdee86736014975b5e3ccc2f8ba4	n
viere@yahoo.com	1a786bbe0e2191a4c04941a78845f4af7c049e67	n
xuqebu@hotmail.com	750a9d34b88e81bebbccc62f8caab5a67142fe13	n
yibietoo@yahoo.com	4d8a848140d0a7ae57eb954aef7fe7bcc16a1e71	n
savivizevifi@live.com	f944aff538d1f5eb3b2586e242a7353358e34cd6	n
micorreo@gmail.com	8755e6091050fea8ce7f540d816bd0076dc80264	y
un	da39a3ee5e6b4b0d3255bfef95601890afd80709	y
tabo@gmail.com	secreto	y
micorreo	1d8518b5ffe107be80a067d9f3b686125d51e251	y
kub@hotmail.com	1d8518b5ffe107be80a067d9f3b686125d51e251	y
m@m.ccc	1d8518b5ffe107be80a067d9f3b686125d51e251	n
kuberjorg3n@hotmail.com	8755e6091050fea8ce7f540d816bd0076dc80264	n
	da39a3ee5e6b4b0d3255bfef95601890afd80709	y
ndrd@mem.om	1d8518b5ffe107be80a067d9f3b686125d51e251	y
ndrd@meme.com	1d8518b5ffe107be80a067d9f3b686125d51e251	n
\.


--
-- TOC entry 3029 (class 0 OID 66018)
-- Dependencies: 188
-- Data for Name: nosotros_infos; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY nosotros_infos (id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3042 (class 0 OID 0)
-- Dependencies: 187
-- Name: nosotros_infos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mamelines
--

SELECT pg_catalog.setval('nosotros_infos_id_seq', 1, false);


--
-- TOC entry 3017 (class 0 OID 58383)
-- Dependencies: 176
-- Data for Name: promocion; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY promocion (idpromocion, codigopromocion, iniciopromo, finpromo, ciudad, descripcion, slug, photo_file_name, photo_content_type, photo_file_size, photo_updated_at, porcentaje) FROM stdin;
1	Viena fin de semana	2014-12-13	2014-12-23	Viena	Fin de semana en viena	viena-fin-de-semana	fearless-skyscraper-cat-windows-8-wallpaper-1280x800.jpg	image/jpeg	203492	2014-12-23 16:46:01.146069	0.849999999999999978
2	parixmas	2014-12-23	2014-12-23	Paris	Navidad en Paris | 550 USD	x	1012_xmas_Paris_(40).jpg	image/jpeg	273902	2014-12-23 16:51:30.68282	0.900000000000000022
\.


--
-- TOC entry 3018 (class 0 OID 58389)
-- Dependencies: 177
-- Data for Name: promociones; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY promociones (idpromocion, codigopromocion, iniciopromo, finpromo, ciudad, descripcion, slug, photo_file_name, photo_content_type, photo_file_size, photo_updated_at) FROM stdin;
1	Viena fin de semana	2014-12-13	2014-12-23	Viena	Fin de semana en viena	viena-fin-de-semana	fearless-skyscraper-cat-windows-8-wallpaper-1280x800.jpg	image/jpeg	203492	2014-12-23 16:46:01.146069
2	parixmas	2014-12-23	2014-12-23	Paris	Navidad en Paris | 550 USD	parixmas	1012_xmas_Paris_(40).jpg	image/jpeg	273902	2014-12-23 16:51:30.68282
\.


--
-- TOC entry 3043 (class 0 OID 0)
-- Dependencies: 178
-- Name: promociones_idpromocion_seq; Type: SEQUENCE SET; Schema: public; Owner: mamelines
--

SELECT pg_catalog.setval('promociones_idpromocion_seq', 2, true);


--
-- TOC entry 3020 (class 0 OID 58397)
-- Dependencies: 179
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
20141125054720
20141223162830
20141231235735
20150101022941
\.


--
-- TOC entry 3021 (class 0 OID 58400)
-- Dependencies: 180
-- Data for Name: tarjeta; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY tarjeta (notarjeta, valor, idusuario, disponible) FROM stdin;
1233-213-312	40005	11	y
\.


--
-- TOC entry 3027 (class 0 OID 58523)
-- Dependencies: 186
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY usuarios (correo, idusuario, nombres, apellidopaterno, apellidomaterno, nacionalidad, genero, fechanacimiento, slug, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at) FROM stdin;
kaawuowie@live.com	8	Rene	Flores	Flores	Mexico	H	1965-06-12	rene	\N	\N	\N	\N
zuofuexudeboxe@hotmail.com	9	Felipe Javier	Cruz	Cantero	Mexico	H	1967-12-01	felipe-javier	\N	\N	\N	\N
mezaequedaa@live.com	10	Catarina	Sanchez	Betanzos	Mexico	M	1975-12-10	catarina	\N	\N	\N	\N
qio@gmail.com	11	Marlene	Pérez	Portillo	Mexico	M	1963-02-17	marlene	\N	\N	\N	\N
xavi@hotmail.com	12	David Mariano	Fuentes	Soto	Mexico	H	1971-04-26	david-mariano	\N	\N	\N	\N
sisoacupohe@live.com	14	Guillermo	Pérez	Salas	Mexico	H	1986-09-05	guillermo	\N	\N	\N	\N
ropibeafu@hotmail.com	15	Yaren Mariela	Amaya	Maldonado	Mexico	M	1963-02-19	yaren-mariela	\N	\N	\N	\N
muyiaqaaxujea@hotmail.com	16	Felipe Julio	Ramírez	Amaya	Mexico	H	1962-08-06	felipe-julio	\N	\N	\N	\N
qimidoho@gmail.com	17	Enrique	Alcantara	Espíndola	Mexico	H	1974-07-01	enrique	\N	\N	\N	\N
doxaco@hotmail.com	18	Ivon Rosa	Pérez	Correa	Mexico	M	1995-04-06	ivon-rosa	\N	\N	\N	\N
mipugai@yahoo.com	20	Itzel Aline	López	Cantero	Mexico	M	1966-08-07	itzel-aline	\N	\N	\N	\N
buyizi@hotmail.com	21	Felipe Octavio	Flores	Espada	Mexico	H	1960-11-13	felipe-octavio	\N	\N	\N	\N
gebugui@gmail.com	22	Ivan Miguel	Baez	Fuentes	Mexico	H	1970-06-19	ivan-miguel	\N	\N	\N	\N
peukeo@yahoo.com	23	Paola Ana	Sanchez	Álvarez	Mexico	M	1971-11-20	paola-ana	\N	\N	\N	\N
gaigiejezaica@yahoo.com	24	Sofia Diana	Correa	Ascencio	Mexico	M	1978-11-06	sofia-diana	\N	\N	\N	\N
kiude@yahoo.com	25	Marcelo	Ávalos	Islas	Mexico	H	1988-03-22	marcelo	\N	\N	\N	\N
gaufavu@gmail.com	27	Andrés Roman	Castillo	De la Rosa	Mexico	H	1960-07-02	andres-roman	\N	\N	\N	\N
muo@gmail.com	28	Ricardo Enrique	Regalado	Abrego	Mexico	H	1980-11-04	ricardo-enrique	\N	\N	\N	\N
juodiaqizixi@yahoo.com	29	Isis	Ávalos	Ávalos	Mexico	M	1973-02-17	isis	\N	\N	\N	\N
voaveosoero@hotmail.com	30	Sandra Gianelli	Macias	De la Rosa	Mexico	M	1986-09-19	sandra-gianelli	\N	\N	\N	\N
mayaviciupa@gmail.com	31	Ximena	Flores	Flores	Mexico	M	1986-05-07	ximena	\N	\N	\N	\N
ceara@live.com	32	Joel	Castillo	Flores	Mexico	H	1991-03-12	joel	\N	\N	\N	\N
poebacuo@gmail.com	34	Jazmin Estefania	Sanchez	Islas	Mexico	M	1987-09-17	jazmin-estefania	\N	\N	\N	\N
dewuje@gmail.com	35	Ivon	Bustos	Torres	Mexico	M	1990-04-29	ivon	\N	\N	\N	\N
coefaa@live.com	36	Vanessa Yessica	Pérez	Rivera	Mexico	M	1980-05-12	vanessa-yessica	\N	\N	\N	\N
ceneayaajikege@live.com	37	Ángel Ángel	Betanzos	Ascencio	Mexico	H	1983-01-25	angel-angel	\N	\N	\N	\N
baveo@yahoo.com	38	Liliana	Espíndola	Beltran	Mexico	M	1992-10-26	liliana	\N	\N	\N	\N
cifa@live.com	39	Salvador	Moreno	Bustos	Mexico	H	1989-01-06	salvador	\N	\N	\N	\N
fuoleepohuomueya@gmail.com	41	Cuauhtemoc Oscar	López	Carrillo	Mexico	H	1979-12-21	cuauhtemoc-oscar	\N	\N	\N	\N
dowaboqacu@hotmail.com	42	Alfonso Oscar	Rojas	Alcantara	Mexico	H	1972-07-23	alfonso-oscar	\N	\N	\N	\N
qikaluili@gmail.com	43	Santiago	Abrego	Cruz	Mexico	H	1967-12-01	santiago	\N	\N	\N	\N
mibavaropawoi@live.com	44	Enrique Tomas	Quintana	Aguilar	Mexico	H	1968-08-11	enrique-tomas	\N	\N	\N	\N
toamue@hotmail.com	46	Felipe	Ramírez	Pérez	Mexico	H	1994-11-06	felipe-f8ea5cd3-1399-4531-aad5-da057a861a6f	\N	\N	\N	\N
dii@hotmail.com	47	Ivon Marlene	Soto	Guardado	Mexico	M	1994-11-11	ivon-marlene	\N	\N	\N	\N
bee@live.com	48	Oscar	Soto	Rojas	Mexico	H	1964-09-13	oscar	\N	\N	\N	\N
jaasuavau@hotmail.com	49	Mauricio Santiago	Sandoval	Ochoa	Mexico	H	1994-03-30	mauricio-santiago	\N	\N	\N	\N
ni@hotmail.com	50	Octavio	Cruz	Carrillo	Mexico	H	1978-08-05	octavio	\N	\N	\N	\N
muce@hotmail.com	52	Mayra Damaris	Osnaya	Castillo	Mexico	M	1991-07-10	mayra-damaris	\N	\N	\N	\N
hou@hotmail.com	53	Pedro Ulises	Rojas	Islas	Mexico	H	1993-03-28	pedro-ulises	\N	\N	\N	\N
sezee@gmail.com	54	Juana Sara	López	De la Rosa	Mexico	M	1964-11-26	juana-sara	\N	\N	\N	\N
moeteihumafexua@yahoo.com	55	Daniel	Robles	Cruz	Mexico	H	1963-09-04	daniel	\N	\N	\N	\N
xivaluitee@hotmail.com	56	Adael	Bustos	Alcantara	Mexico	H	1976-12-23	adael	\N	\N	\N	\N
ridi@yahoo.com	57	Joel Mariano	Bustos	Cabrera	Mexico	H	1996-01-04	joel-mariano	\N	\N	\N	\N
foba@live.com	58	Carlos	Fernandez	Beltran	Mexico	H	1964-06-13	carlos	\N	\N	\N	\N
zauluucio@live.com	59	Victor	Espada	Navarro	Mexico	H	1975-09-17	victor	\N	\N	\N	\N
muacoyepeekoeva@gmail.com	61	Paola	Jiménez	Carrillo	Mexico	M	1969-02-04	paola	\N	\N	\N	\N
ci@yahoo.com	62	Viridiana	Cabrera	Alcantara	Mexico	M	1984-08-03	viridiana	\N	\N	\N	\N
nea@gmail.com	63	Ximena Rosa	Prospero	Ramírez	Mexico	M	1970-10-31	ximena-rosa	\N	\N	\N	\N
pace@live.com	64	Gianelli	Rodríguez	Abrego	Mexico	M	1985-11-26	gianelli	\N	\N	\N	\N
ruucajaoqaigeo@hotmail.com	65	Tamara	Álvarez	Sanchez	Mexico	M	1984-11-07	tamara	\N	\N	\N	\N
duujaokaximii@gmail.com	67	Ana Ximena	De la Rosa	Moreno	Mexico	M	1963-09-17	ana-ximena	\N	\N	\N	\N
bozeibeazazi@live.com	68	Victor	Cabrera	Prospero	Mexico	H	1988-10-17	victor-e143d1b6-d75c-4669-bb9d-f5467f3ba159	\N	\N	\N	\N
jojazawiixii@live.com	69	Ivon Marlene	Abrego	Maldonado	Mexico	M	1978-02-18	ivon-marlene-120af845-c90e-4b06-96fb-ce21f37d31f2	\N	\N	\N	\N
xiuroubotugee@live.com	70	Luis	Macias	Hernández	Mexico	H	1966-08-07	luis	\N	\N	\N	\N
xuinuoloa@live.com	72	Valeria Mariela	Álvarez	Portillo	Mexico	M	1986-05-04	valeria-mariela	\N	\N	\N	\N
rudexu@yahoo.com	73	Felipe Alberto	Navarro	Fierro	Mexico	H	1976-07-18	felipe-alberto	\N	\N	\N	\N
fula@yahoo.com	74	Roxana	Soto	López	Mexico	M	1979-05-26	roxana	\N	\N	\N	\N
jolewunutaivu@yahoo.com	75	Pedro	Robles	Correa	Mexico	H	1965-09-12	pedro	\N	\N	\N	\N
yuliefoorae@hotmail.com	76	Diana Viridiana	Tello	Flores	Mexico	M	1990-01-07	diana-viridiana	\N	\N	\N	\N
nu@live.com	78	Zaira	Beltran	Maldonado	Mexico	M	1993-08-06	zaira	\N	\N	\N	\N
nua@gmail.com	79	Francisco	Jiménez	Velasco	Mexico	H	1974-04-21	francisco	\N	\N	\N	\N
weviaxeque@gmail.com	80	Sofia Mariela	Jiménez	Castillo	Mexico	M	1993-07-21	sofia-mariela	\N	\N	\N	\N
jelue@live.com	81	Adael Leonardo	Fernandez	Islas	Mexico	H	1971-11-27	adael-leonardo	\N	\N	\N	\N
meutoopoi@gmail.com	82	Hugo Rodrigo	Guardado	Delgado	Mexico	H	1970-09-29	hugo-rodrigo	\N	\N	\N	\N
tauwoumea@live.com	83	Rodrigo	Cortés	Ascencio	Mexico	H	1964-12-19	rodrigo	\N	\N	\N	\N
wuvioqiucoseso@yahoo.com	7	Felipe	Correa	Cruz	Mexico	H	1990-04-09	felipe	\N	\N	\N	\N
sirayozui@hotmail.com	13	Itzel	Cortés	Santiago	Mexico	M	1977-02-25	itzel	\N	\N	\N	\N
wuojo@hotmail.com	19	Roxana Mariana	Robles	Valdez	Mexico	M	1976-12-12	roxana-mariana	\N	\N	\N	\N
zeasereokuzue@hotmail.com	26	Ricardo Juan	Rojas	Ochoa	Mexico	H	1988-10-02	ricardo-juan	\N	\N	\N	\N
xue@hotmail.com	33	Victor Esteban	Rojas	Robles	Mexico	H	1974-03-22	victor-esteban	\N	\N	\N	\N
gezugea@live.com	40	Alix Dulce	Alcantara	Portillo	Mexico	M	1987-11-11	alix-dulce	\N	\N	\N	\N
woxoucaruezi@hotmail.com	45	Alberto Axel	Fernandez	Velasco	Mexico	H	1982-12-24	alberto-axel	\N	\N	\N	\N
siohucodeyiu@yahoo.com	51	Liliana	Sandoval	Delgado	Mexico	M	1963-04-21	liliana-01eaabc3-d9e5-4097-8f0d-cb0b9ffecf7e	\N	\N	\N	\N
poqiuhoigoifee@yahoo.com	60	Juana Guadalupe	Fierro	Díaz	Mexico	M	1976-09-19	juana-guadalupe	\N	\N	\N	\N
raaxii@yahoo.com	66	Enrique	López	Quintana	Mexico	H	1965-08-21	enrique-5d13e37c-3ad5-4d52-ae07-701c62c66332	\N	\N	\N	\N
wao@gmail.com	71	Andrea Zoe	Durán	Osnaya	Mexico	M	1972-05-16	andrea-zoe	\N	\N	\N	\N
ruqunaijeewo@hotmail.com	77	Joel Pedro	Robles	Quintana	Mexico	H	1987-04-23	joel-pedro	\N	\N	\N	\N
xikusupuuzoa@yahoo.com	84	Adrian	Aguilar	Osnaya	Mexico	H	1971-11-06	adrian	\N	\N	\N	\N
pu@hotmail.com	85	Daniela Isabel	Velasco	Fuentes	Mexico	M	1995-02-22	daniela-isabel	\N	\N	\N	\N
niipaqamu@live.com	86	David	Alcantara	Regalado	Mexico	H	1980-08-06	david	\N	\N	\N	\N
sisotale@live.com	87	Sofia	Flores	López	Mexico	M	1981-07-17	sofia	\N	\N	\N	\N
liucixeohe@gmail.com	88	Liliana	Navarro	Durán	Mexico	M	1965-05-01	liliana-e35583ec-3cb5-429e-ae8b-9f8ef7c691e9	\N	\N	\N	\N
baaqia@live.com	89	Juan	Maldonado	Beltran	Mexico	H	1992-10-08	juan	\N	\N	\N	\N
niku@yahoo.com	90	Jesús Oscar	Navarro	Sandoval	Mexico	H	1993-11-13	jesus-oscar	\N	\N	\N	\N
seuhiicuvexayeo@hotmail.com	91	Fernando	Velasco	Cortés	Mexico	H	1960-02-19	fernando	\N	\N	\N	\N
jodiwacilafu@yahoo.com	92	Viridiana	Castillo	Moreno	Mexico	M	1976-08-14	viridiana-aa67164b-e914-4f5f-a9f3-72cc1a770c8d	\N	\N	\N	\N
nizoavio@live.com	93	Andrea	Amaya	Cortés	Mexico	M	1993-01-09	andrea	\N	\N	\N	\N
mibiocibe@live.com	94	Rodrigo	Ramírez	Fernandez	Mexico	H	1982-10-16	rodrigo-e92d95ee-adad-4677-bb69-93642b99ae12	\N	\N	\N	\N
kieceizeasavae@gmail.com	95	Ximena Vanessa	Flores	Castillo	Mexico	M	1961-12-01	ximena-vanessa	\N	\N	\N	\N
jeiqujivocuo@live.com	96	Sandra Maribel	Flores	Tello	Mexico	M	1989-01-07	sandra-maribel	\N	\N	\N	\N
habetapimuza@yahoo.com	97	Fernanda Viridiana	Cortés	Rojas	Mexico	M	1986-04-26	fernanda-viridiana	\N	\N	\N	\N
gu@gmail.com	98	Axel	Correa	Hernández	Mexico	H	1974-01-10	axel	\N	\N	\N	\N
solauyui@yahoo.com	99	Israel	Macias	Salas	Mexico	H	1966-12-14	israel	\N	\N	\N	\N
ju@gmail.com	100	Jazmin	Carrillo	Ávalos	Mexico	M	1985-07-12	jazmin	\N	\N	\N	\N
bo@gmail.com	101	Angelica	Velasco	Herrera	Mexico	M	1969-08-03	angelica	\N	\N	\N	\N
dofaebiwehoo@hotmail.com	102	Saul Pedro	Velasco	Jiménez	Mexico	H	1977-07-18	saul-pedro	\N	\N	\N	\N
viere@yahoo.com	103	Victor Alfonso	Guardado	Alcantara	Mexico	H	1981-10-12	victor-alfonso	\N	\N	\N	\N
xuqebu@hotmail.com	104	Ángel	Ramírez	Moreno	Mexico	H	1988-12-17	angel	\N	\N	\N	\N
yibietoo@yahoo.com	105	Diana	Baez	Baez	Mexico	M	1975-04-25	diana	\N	\N	\N	\N
savivizevifi@live.com	106	Alma	Fernandez	Fernandez	Mexico	M	1969-06-15	alma	\N	\N	\N	\N
ndrd@meme.com	6	Jonathan de Jesus	Lopez	Andrade	Mx	H	2014-12-31	jonathan-de-jesus	10653296_10154861262545634_5432922133193849718_n.jpg	image/jpeg	29234	2015-01-01 03:26:21.611633
\.


--
-- TOC entry 3044 (class 0 OID 0)
-- Dependencies: 185
-- Name: usuarios_idusuario_seq; Type: SEQUENCE SET; Schema: public; Owner: mamelines
--

SELECT pg_catalog.setval('usuarios_idusuario_seq', 9, true);


--
-- TOC entry 3022 (class 0 OID 58413)
-- Dependencies: 181
-- Data for Name: valor; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY valor (idvalor, costomilla, fecha, tipomoneda, tipomedida) FROM stdin;
1	0.119999999999999996	2014-12-20	Dolar	Milla
2	0.110000000000000001	2014-12-21	Dolar	Milla
3	0.149999999999999994	2014-12-22	Dolar	Milla
4	0.130000000000000004	2014-12-23	Dolar	Milla
5	0.140000000000000013	2014-12-24	Dolar	Milla
6	0.130000000000000004	2014-12-26	Dolar	Milla
7	0.119999999999999996	2014-12-27	Dolar	Milla
8	0.110000000000000001	2014-12-28	Dolar	Milla
9	0.119999999999999996	2014-12-29	Dolar	Milla
10	0.130000000000000004	2014-12-30	Dolar	Milla
11	0.23000000000000001	2014-12-31	dollar	milla
\.


--
-- TOC entry 3023 (class 0 OID 58420)
-- Dependencies: 182
-- Data for Name: viajes; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY viajes (idviaje, origen, destino, fechasalida, horasalida, fechallegada, horallegada, distancia, tiempo, costoviaje, realizado, idavion) FROM stdin;
27	Jeju Do	Hong Kong	2014-12-28	08:00:00+09	2014-12-28	09:00:00+08	1076	02:00:00	129.120000000000005	y	26
18	Buenos Aires	Porto Alegre	2014-12-27	13:00:00-03	2014-12-27	21:00:00+04	524	01:00:00	62.8799999999999955	y	17
5	Florencia	Amsterdam	2015-01-01	01:00:00+01	2015-01-01	02:00:00+01	663	01:00:00	79.5600000000000023	c	5
8	Ciudad de Mexico	Buenos Aires	2014-12-23	13:00:00-06	2014-12-24	04:00:00-03	4598	12:00:00	551.759999999999991	c	7
45	Florencia	Ciudad de Mexico	2014-12-29	08:00:00+01	2014-12-29	18:00:00-06	6253	17:00:00	750.360000000000014	y	43
4	Amsterdam	Berlin	2015-01-01	01:00:00+01	2015-01-01	01:00:00+01	359	00:00:00	43.0799999999999983	c	4
26	Amsterdam	Frankfur	2014-12-28	07:00:00+01	2014-12-28	07:00:00+01	226	00:00:00	27.1199999999999974	y	25
32	Ciudad de Mexico	Munich	2014-12-28	11:00:00-06	2014-12-29	11:00:00+01	6126	17:00:00	735.120000000000005	y	30
2	Incheon	Abu Dhabi	2015-01-10	01:00:00+09	2015-01-10	03:00:00+00	4281	11:00:00	513.720000000000027	n	2
41	Ciudad de Mexico	Hamburgo	2014-12-28	23:00:00-06	2014-12-29	22:00:00+01	5892	16:00:00	707.039999999999964	y	39
28	Vancouver	Incheon	2014-12-28	08:00:00-08	2014-12-29	15:00:00+09	5268	14:00:00	632.159999999999968	y	27
29	Vancouver	Seul	2014-12-28	09:00:00-08	2014-12-29	16:00:00+09	5252	14:00:00	630.240000000000009	y	28
3	Ciudad de Mexico	Amsterdam	2015-01-10	01:00:00-06	2015-01-10	23:00:00+01	5733	15:00:00	687.959999999999923	n	3
1	Ciudad de Mexico	Berlin	2014-12-22	14:00:00-06	2014-12-23	13:00:00+01	6050	16:00:00	726	y	1
24	Ciudad de Mexico	Porto Alegre	2014-12-28	06:00:00-06	2014-12-29	04:00:00+04	4678	12:00:00	561.360000000000014	y	23
25	Ciudad de Mexico	Buenos Aires	2014-12-28	06:00:00-06	2014-12-29	03:00:00+03	4598	12:00:00	551.759999999999991	y	24
30	Berlin	Seul	2014-12-28	10:00:00+01	2014-12-29	08:00:00+09	5055	14:00:00	606.600000000000023	y	29
6	Berlin	Ciudad de Mexico	2014-12-25	14:00:00+01	2014-12-25	23:00:00-06	6050	16:00:00	726	y	1
7	Ciudad de Mexico	Buenos Aires	2014-12-23	06:00:00-06	2014-12-23	21:00:00-03	4598	12:00:00	551.759999999999991	y	6
31	Abu Dhabi	Seul	2014-12-28	10:00:00+00	2014-12-29	06:00:00+09	4295	11:00:00	515.399999999999977	y	2
9	Ciudad de Mexico	Amsterdam	2014-12-24	16:00:00-06	2014-12-25	14:00:00+01	5733	15:00:00	687.959999999999923	y	8
10	Ciudad de Mexico	Florencia	2014-12-24	17:00:00-06	2014-12-25	17:00:00+01	6253	17:00:00	750.360000000000014	y	9
11	Ciudad de Mexico	Hamburgo	2014-12-24	17:00:00-06	2014-12-25	16:00:00+01	5892	16:00:00	707.039999999999964	y	10
12	Ciudad de Mexico	Munich	2014-12-25	01:00:00-06	2014-12-26	01:00:00+01	6126	17:00:00	735.120000000000005	y	11
13	Ciudad de Mexico	Porto Alegre	2014-12-25	05:00:00-06	2014-12-26	03:00:00+04	4678	12:00:00	561.360000000000014	y	12
14	Ciudad de Mexico	Vancouver	2014-12-25	07:00:00-06	2014-12-25	11:00:00-08	2255	06:00:00	270.599999999999966	y	13
15	Ciudad de Mexico	Amsterdam	2014-12-25	08:00:00-06	2014-12-26	06:00:00+01	5733	15:00:00	687.959999999999923	y	14
17	Seul	Jeju Do	2014-12-26	23:00:00+09	2014-12-26	23:00:00+09	283	00:00:00	33.9600000000000009	y	16
23	Busan	Estambul	2014-12-27	01:00:00+09	2014-12-27	08:00:00+02	5142	14:00:00	617.039999999999964	y	22
16	Ciudad de Mexico	Vancouver	2014-12-26	23:00:00-06	2014-12-27	03:00:00-08	2255	06:00:00	270.599999999999966	y	15
19	Buenos Aires	Vancouver	2014-12-27	15:00:00-03	2014-12-28	05:00:00-08	6847	19:00:00	821.639999999999986	y	18
20	Porto Alegre	El Cairo	2014-12-27	18:00:00+04	2014-12-28	10:00:00+02	6831	18:00:00	819.719999999999914	y	19
21	Munich	Busan	2014-12-27	18:00:00+01	2014-12-28	17:00:00+09	5519	15:00:00	662.279999999999973	y	20
22	Amsterdam	Dubai	2014-12-27	19:00:00+01	2014-12-28	02:00:00+00	3210	08:00:00	385.199999999999989	y	21
63	Abu Dhabi	Amsterdam	2015-02-01	00:00:00+00	2015-02-01	09:00:00+01	3212	08:00:00	385.439999999999998	n	32
64	Ciudad de Mexico	Berlin	2015-01-04	08:00:00-06	2015-01-05	07:00:00+01	6051	16:00:00	726.120000000000005	n	1
65	Ciudad de Mexico	Buenos Aires	2015-01-04	04:00:00-06	2015-01-05	01:00:00+03	4598	12:00:00	551.759999999999991	n	42
66	Florencia	Buenos Aires	2015-01-04	07:00:00+01	2015-01-05	04:00:00+03	6967	19:00:00	836.039999999999964	n	61
33	Ciudad de Mexico	Munich	2014-12-28	12:00:00-06	2014-12-29	12:00:00+01	6126	17:00:00	735.120000000000005	y	31
34	Munich	Abu Dhabi	2014-12-28	11:00:00+01	2014-12-28	17:00:00+00	2839	07:00:00	340.680000000000007	y	32
35	Florencia	Jerusalen	2014-12-28	12:00:00+01	2014-12-28	17:00:00+02	1543	04:00:00	185.159999999999997	y	33
36	Dubai	Jerusalen	2014-12-28	13:00:00+00	2014-12-28	18:00:00+02	1299	03:00:00	155.879999999999995	y	34
37	Incheon	Pekin	2014-12-28	19:00:00+09	2014-12-28	03:00:00-08	581	01:00:00	69.7199999999999989	y	35
56	Buenos Aires	Ciudad de Mexico	2014-12-29	12:00:00-03	2014-12-29	21:00:00-06	4598	12:00:00	551.759999999999991	y	54
38	Incheon	Shangai	2014-12-28	20:00:00+09	2014-12-28	04:00:00-08	524	01:00:00	62.8799999999999955	y	36
39	Seul	Tokio	2014-12-28	21:00:00+09	2014-12-28	22:00:00+09	717	01:00:00	86.039999999999992	y	37
40	Vancouver	Tokoname	2014-12-28	23:00:00-08	2014-12-30	05:00:00+09	5000	13:00:00	600	y	38
42	Vancouver	Tokio	2014-12-29	01:00:00-08	2014-12-30	07:00:00+09	4844	13:00:00	581.279999999999973	y	40
43	Vancouver	Incheon	2014-12-29	06:00:00-08	2014-12-30	13:00:00+09	5268	14:00:00	632.159999999999968	y	41
44	Munich	Ciudad de Mexico	2014-12-29	07:00:00+01	2014-12-29	17:00:00-06	6126	17:00:00	735.120000000000005	y	42
46	Frankfur	Ciudad de Mexico	2014-12-29	09:00:00+01	2014-12-29	18:00:00-06	5947	16:00:00	713.639999999999986	y	44
47	El Cairo	Abu Dhabi	2014-12-29	09:00:00+02	2014-12-29	11:00:00+00	1471	04:00:00	176.519999999999982	y	45
48	Amsterdam	Jeju Do	2014-12-29	10:00:00+01	2014-12-30	09:00:00+09	5548	15:00:00	665.759999999999991	y	46
49	Frankfur	Dubai	2014-12-29	10:00:00+01	2014-12-29	17:00:00+00	3008	08:00:00	360.95999999999998	y	47
50	Florencia	Estambul	2014-12-29	11:00:00+01	2014-12-29	14:00:00+02	924	02:00:00	110.879999999999995	y	48
51	El Cairo	Florencia	2014-12-29	11:00:00+02	2014-12-29	14:00:00+01	1450	04:00:00	174	y	49
52	Florencia	Busan	2014-12-29	11:00:00+01	2014-12-30	10:00:00+09	5736	15:00:00	688.319999999999936	y	50
53	Vancouver	El Cairo	2014-12-29	11:00:00-08	2014-12-30	16:00:00+02	6965	19:00:00	835.799999999999955	y	51
54	Amsterdam	Frankfur	2014-12-29	12:00:00+01	2014-12-29	12:00:00+01	226	00:00:00	27.1199999999999974	y	52
55	Amsterdam	Munich	2014-12-29	12:00:00+01	2014-12-29	13:00:00+01	416	01:00:00	49.9200000000000017	y	53
57	Porto Alegre	Ciudad de Mexico	2014-12-29	12:00:00+04	2014-12-29	14:00:00-06	4678	12:00:00	561.360000000000014	y	55
58	Ciudad de Mexico	Vancouver	2014-12-29	11:00:00-06	2014-12-29	15:00:00-08	2255	06:00:00	270.599999999999966	y	56
59	Ciudad de Mexico	Porto Alegre	2014-12-29	12:00:00-06	2014-12-30	10:00:00+04	4678	12:00:00	561.360000000000014	y	57
60	Ciudad de Mexico	Berlin	2014-12-29	13:00:00-06	2014-12-30	12:00:00+01	6051	16:00:00	726.120000000000005	y	58
61	Ciudad de Mexico	Hamburgo	2014-12-29	13:00:00-06	2014-12-30	12:00:00+01	5892	16:00:00	707.039999999999964	y	59
62	Ciudad de Mexico	Buenos Aires	2014-12-29	14:00:00-06	2014-12-30	11:00:00+03	4598	12:00:00	551.759999999999991	y	60
\.


--
-- TOC entry 3024 (class 0 OID 58428)
-- Dependencies: 183
-- Data for Name: vuelos; Type: TABLE DATA; Schema: public; Owner: mamelines
--

COPY vuelos (id, created_at, updated_at) FROM stdin;
1	2014-12-19 18:45:06.177961	2014-12-19 18:45:06.177961
\.


--
-- TOC entry 3045 (class 0 OID 0)
-- Dependencies: 184
-- Name: vuelos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mamelines
--

SELECT pg_catalog.setval('vuelos_id_seq', 1, true);


--
-- TOC entry 2861 (class 2606 OID 58437)
-- Name: adiministradorc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY administrador
    ADD CONSTRAINT adiministradorc PRIMARY KEY (correo);


--
-- TOC entry 2863 (class 2606 OID 58439)
-- Name: adminc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY administrador
    ADD CONSTRAINT adminc UNIQUE (correo);


--
-- TOC entry 2865 (class 2606 OID 58441)
-- Name: administrador_correo_key; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY administrador
    ADD CONSTRAINT administrador_correo_key UNIQUE (correo);


--
-- TOC entry 2867 (class 2606 OID 58443)
-- Name: avions_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY avion
    ADD CONSTRAINT avions_pkey PRIMARY KEY (idavion);


--
-- TOC entry 2869 (class 2606 OID 58445)
-- Name: cancelados_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY cancelados
    ADD CONSTRAINT cancelados_pkey PRIMARY KEY (idviaje);


--
-- TOC entry 2871 (class 2606 OID 58447)
-- Name: ciudadc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY ciudades
    ADD CONSTRAINT ciudadc PRIMARY KEY (nombre);


--
-- TOC entry 2873 (class 2606 OID 58449)
-- Name: loginc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY logins
    ADD CONSTRAINT loginc PRIMARY KEY (correo);


--
-- TOC entry 2894 (class 2606 OID 66023)
-- Name: nosotros_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY nosotros_infos
    ADD CONSTRAINT nosotros_infos_pkey PRIMARY KEY (id);


--
-- TOC entry 2875 (class 2606 OID 58451)
-- Name: proomocionsc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY promocion
    ADD CONSTRAINT proomocionsc PRIMARY KEY (idpromocion);


--
-- TOC entry 2878 (class 2606 OID 58453)
-- Name: tarjeta_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY tarjeta
    ADD CONSTRAINT tarjeta_pkey PRIMARY KEY (notarjeta);


--
-- TOC entry 2890 (class 2606 OID 58534)
-- Name: usuarioc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarioc UNIQUE (correo);


--
-- TOC entry 2892 (class 2606 OID 58532)
-- Name: usuariosc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuariosc PRIMARY KEY (idusuario);


--
-- TOC entry 2880 (class 2606 OID 58459)
-- Name: valor_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY valor
    ADD CONSTRAINT valor_pkey PRIMARY KEY (idvalor);


--
-- TOC entry 2882 (class 2606 OID 58461)
-- Name: valorc; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY valor
    ADD CONSTRAINT valorc UNIQUE (fecha);


--
-- TOC entry 2884 (class 2606 OID 58463)
-- Name: viaje_origen_destino_fechasalida_horasalida_key; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY viajes
    ADD CONSTRAINT viaje_origen_destino_fechasalida_horasalida_key UNIQUE (origen, destino, fechasalida, horasalida);


--
-- TOC entry 2886 (class 2606 OID 58465)
-- Name: viajec; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY viajes
    ADD CONSTRAINT viajec PRIMARY KEY (idviaje);


--
-- TOC entry 2888 (class 2606 OID 58467)
-- Name: vuelos_pkey; Type: CONSTRAINT; Schema: public; Owner: mamelines; Tablespace: 
--

ALTER TABLE ONLY vuelos
    ADD CONSTRAINT vuelos_pkey PRIMARY KEY (id);


--
-- TOC entry 2876 (class 1259 OID 58468)
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: mamelines; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- TOC entry 3011 (class 2618 OID 58469)
-- Name: rviaje; Type: RULE; Schema: public; Owner: mamelines
--

CREATE RULE rviaje AS
    ON UPDATE TO viajes
   WHERE ((old.realizado = 'y'::bpchar) OR (old.realizado = 'c'::bpchar)) DO INSTEAD NOTHING;


--
-- TOC entry 2899 (class 2620 OID 58470)
-- Name: tavion; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tavion BEFORE INSERT ON avion FOR EACH ROW EXECUTE PROCEDURE favion();


--
-- TOC entry 2902 (class 2620 OID 58540)
-- Name: tusuarios; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tusuarios BEFORE INSERT ON usuarios FOR EACH ROW EXECUTE PROCEDURE fusuarios();


--
-- TOC entry 2900 (class 2620 OID 58472)
-- Name: tvalor; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tvalor BEFORE INSERT ON valor FOR EACH ROW EXECUTE PROCEDURE fvalor();


--
-- TOC entry 2901 (class 2620 OID 58473)
-- Name: tviaje; Type: TRIGGER; Schema: public; Owner: mamelines
--

CREATE TRIGGER tviaje BEFORE INSERT ON viajes FOR EACH ROW EXECUTE PROCEDURE fviaje();


--
-- TOC entry 2895 (class 2606 OID 58474)
-- Name: administrador_correo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY administrador
    ADD CONSTRAINT administrador_correo_fkey FOREIGN KEY (correo) REFERENCES logins(correo);


--
-- TOC entry 2896 (class 2606 OID 58479)
-- Name: cancelados_idviaje_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY cancelados
    ADD CONSTRAINT cancelados_idviaje_fkey FOREIGN KEY (idviaje) REFERENCES viajes(idviaje);


--
-- TOC entry 2898 (class 2606 OID 58535)
-- Name: usuarios_correo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_correo_fkey FOREIGN KEY (correo) REFERENCES logins(correo);


--
-- TOC entry 2897 (class 2606 OID 58494)
-- Name: viaje_idavion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mamelines
--

ALTER TABLE ONLY viajes
    ADD CONSTRAINT viaje_idavion_fkey FOREIGN KEY (idavion) REFERENCES avion(idavion);


--
-- TOC entry 3036 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-12-31 23:06:01 CST

--
-- PostgreSQL database dump complete
--

