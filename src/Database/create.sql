-- Table: public.Proveedores

-- DROP TABLE public.Proveedores;
CREATE SEQUENCE Proveedores_id_seq START 1;
CREATE TABLE public.Proveedores
(
    id bigint NOT NULL DEFAULT nextval('Proveedores_id_seq'::regclass),
    empresa character varying(300),
    contacto character varying(300),
    domicilio character varying(300),
    telefono character varying(100),
    email character varying(100),
    comentarios character varying(500),
    activo boolean,
    CONSTRAINT Proveedores_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Proveedores
    OWNER to postgres;


-- Table: public.Materiales

-- DROP TABLE public.Materiales;
CREATE SEQUENCE Materiales_id_seq START 1;
CREATE TABLE public.Materiales
(
    id bigint NOT NULL DEFAULT nextval('Materiales_id_seq'::regclass),
    nombre character varying(300),
    color character varying(300),
    unidad character varying(300),
    marca character varying(300),
    modelo character varying(300),
    comentarios character varying(500),
    activo boolean,
    CONSTRAINT Materiales_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Materiales
    OWNER to postgres;


-- Table: public.Documentos

-- DROP TABLE public.Documentos;
CREATE SEQUENCE Documentos_id_seq START 1;
CREATE TABLE public.Documentos
(
    id bigint NOT NULL DEFAULT nextval('Documentos_id_seq'::regclass),
    fileName character varying(300),
    bytes bytea,
    datechanged timestamp without time zone,
    CONSTRAINT Documentos_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Documentos
    OWNER to postgres;

-- Table: public.DocumentosXml

-- DROP TABLE public.DocumentosXml;
CREATE SEQUENCE DocumentosXml_id_seq START 1;
CREATE TABLE public.DocumentosXml
(
    id bigint NOT NULL DEFAULT nextval('DocumentosXml_id_seq'::regclass),
    fileName character varying(300),
    xml xml,
    datechanged timestamp without time zone,
    CONSTRAINT DocumentosXml_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.DocumentosXml
    OWNER to postgres;

-- Table: public.Cuentas

-- DROP TABLE public.Cuentas;
CREATE SEQUENCE Cuentas_id_seq START 1;
CREATE TABLE public.Cuentas
(
    id bigint NOT NULL DEFAULT nextval('Cuentas_id_seq'::regclass),
    banco character varying(300),
    clabe character varying(18),
    noCuenta character varying(18),
    beneficiario character varying(300),
    emailNotificacion character varying(300),
    nombre character varying(300),
    efectivo boolean,
    activo boolean,
    CONSTRAINT Cuentas_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Cuentas
    OWNER to postgres;


-- Table: public.Pagos

-- DROP TABLE public.Pagos;
CREATE SEQUENCE Pagos_id_seq START 1;
CREATE TABLE public.Pagos
(
    id bigint NOT NULL DEFAULT nextval('Pagos_id_seq'::regclass),
    motivo character varying(300),
    total numeric(18,8),
    fechaCaptura timestamp without time zone,
    fechaAplicacion timestamp without time zone,
    docIdFacturaPdf bigint,
    docIdFacturaXml bigint,
    docIdNotaRemision bigint,
    docIdTransfeBanco bigint,
    cuentaOrigenId bigint,
    cuentaDestinoId bigint,
    activo boolean,
    CONSTRAINT Pagos_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Pagos
    OWNER to postgres;

ALTER TABLE ONLY public.Pagos
    ADD CONSTRAINT Pagos_IdFacturaPdf_fkey FOREIGN KEY (docIdFacturaPdf) REFERENCES public.Documentos(id);
ALTER TABLE ONLY public.Pagos
    ADD CONSTRAINT Pagos_IdFacturaXml_fkey FOREIGN KEY (docIdFacturaXml) REFERENCES public.DocumentosXml(id);
ALTER TABLE ONLY public.Pagos
    ADD CONSTRAINT Pagos_IdNotaRemision_fkey FOREIGN KEY (docIdNotaRemision) REFERENCES public.Documentos(id);
ALTER TABLE ONLY public.Pagos
    ADD CONSTRAINT Pagos_IdTransfeBanco_fkey FOREIGN KEY (docIdTransfeBanco) REFERENCES public.Documentos(id);
ALTER TABLE ONLY public.Pagos
    ADD CONSTRAINT Pagos_cuentaOrigenId_fkey FOREIGN KEY (cuentaOrigenId) REFERENCES public.Cuentas(id);
ALTER TABLE ONLY public.Pagos
    ADD CONSTRAINT Pagos_cuentaDestinoId_fkey FOREIGN KEY (cuentaDestinoId) REFERENCES public.Cuentas(id);

-- Table: public.Egresos

-- DROP TABLE public.Egresos;
CREATE SEQUENCE Egresos_id_seq START 1;
CREATE TABLE public.Egresos
(
    id bigint NOT NULL DEFAULT nextval('Egresos_id_seq'::regclass),
    pagoId bigint,
    proveedorId bigint,
    activo boolean,
    CONSTRAINT Egresos_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Egresos
    OWNER to postgres;

ALTER TABLE ONLY public.Egresos
    ADD CONSTRAINT Egresos_pagoId_fkey FOREIGN KEY (pagoId) REFERENCES public.Pagos(id);
ALTER TABLE ONLY public.Egresos
    ADD CONSTRAINT Egresos_proveedorId_fkey FOREIGN KEY (proveedorId) REFERENCES public.Proveedores(id);

-- Table: public.ComprasMateriales

-- DROP TABLE public.ComprasMateriales;
CREATE SEQUENCE ComprasMateriales_id_seq START 1;
CREATE TABLE public.ComprasMateriales
(
    id bigint NOT NULL DEFAULT nextval('ComprasMateriales_id_seq'::regclass),
    egresoId bigint,
    materialId bigint,
    cantidad numeric(18,8),
    precioUnitario numeric(18,8),
    CONSTRAINT ComprasMateriales_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ComprasMateriales
    OWNER to postgres;

ALTER TABLE ONLY public.ComprasMateriales
    ADD CONSTRAINT ComprasMateriales_egresoId_fkey FOREIGN KEY (egresoId) REFERENCES public.Egresos(id);
ALTER TABLE ONLY public.ComprasMateriales
    ADD CONSTRAINT ComprasMateriales_materialId_fkey FOREIGN KEY (materialId) REFERENCES public.Materiales(id);

-- Table: public.DatosFacturacion

-- DROP TABLE public.DatosFacturacion;
CREATE SEQUENCE DatosFacturacion_id_seq START 1;
CREATE TABLE public.DatosFacturacion
(
    id bigint NOT NULL DEFAULT nextval('DatosFacturacion_id_seq'::regclass),
    nombre character varying(300),
    calle character varying(300),
    noExterior character varying(300),
    noInterior character varying(300),
    colonia character varying(300),
    ciudad character varying(300),
    estado character varying(100),
    cp character varying(30),
    rfc character varying(30),
    email character varying(300),
    CONSTRAINT DatosFacturacion_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.DatosFacturacion
    OWNER to postgres;

-- Table: public.Clientes

-- DROP TABLE public.Clientes;
CREATE SEQUENCE Clientes_id_seq START 1;
CREATE TABLE public.Clientes
(
    id bigint NOT NULL DEFAULT nextval('Clientes_id_seq'::regclass),
    facturacionId bigint,
    contacto character varying(300),
    empresa character varying(300),
    telefono character varying(300),
    email character varying(300),
    domicilio character varying(300),
    fechaCreado timestamp without time zone,
    activo boolean,
    CONSTRAINT Clientes_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Clientes
    OWNER to postgres;

ALTER TABLE ONLY public.Clientes
    ADD CONSTRAINT Clientes_facturacionId_fkey FOREIGN KEY (facturacionId) REFERENCES public.DatosFacturacion(id);


-- Table: public.ProveedoresCuentas

-- DROP TABLE public.ProveedoresCuentas;
CREATE SEQUENCE ProveedoresCuentas_id_seq START 1;
CREATE TABLE public.ProveedoresCuentas
(
    id bigint NOT NULL DEFAULT nextval('ProveedoresCuentas_id_seq'::regclass),
    proveedorId bigint,
    cuentaId bigint,
    CONSTRAINT ProveedoresCuentas_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ProveedoresCuentas
    OWNER to postgres;

ALTER TABLE ONLY public.ProveedoresCuentas
    ADD CONSTRAINT ProveedoresCuentas_proveedorId_fkey FOREIGN KEY (proveedorId) REFERENCES public.Proveedores(id);

ALTER TABLE ONLY public.ProveedoresCuentas
    ADD CONSTRAINT ProveedoresCuentas_cuentaId_fkey FOREIGN KEY (cuentaId) REFERENCES public.Cuentas(id);


-- Table: public.ClientesCuentas

-- DROP TABLE public.ClientesCuentas;
CREATE SEQUENCE ClientesCuentas_id_seq START 1;
CREATE TABLE public.ClientesCuentas
(
    id bigint NOT NULL DEFAULT nextval('ClientesCuentas_id_seq'::regclass),
    clienteId bigint,
    cuentaId bigint,
    CONSTRAINT ClientesCuentas_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ClientesCuentas
    OWNER to postgres;

ALTER TABLE ONLY public.ClientesCuentas
    ADD CONSTRAINT ClientesCuentas_clienteId_fkey FOREIGN KEY (clienteId) REFERENCES public.Clientes(id);

ALTER TABLE ONLY public.ClientesCuentas
    ADD CONSTRAINT ClientesCuentas_cuentaId_fkey FOREIGN KEY (cuentaId) REFERENCES public.Cuentas(id);

-- Table: public.Ingresos

-- DROP TABLE public.Ingresos;
CREATE SEQUENCE Ingresos_id_seq START 1;
CREATE TABLE public.Ingresos
(
    id bigint NOT NULL DEFAULT nextval('Ingresos_id_seq'::regclass),
    pagoId bigint,
    clienteId bigint,
    activo boolean,
    CONSTRAINT Ingresos_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Ingresos
    OWNER to postgres;

ALTER TABLE ONLY public.Ingresos
    ADD CONSTRAINT Ingresos_pagoId_fkey FOREIGN KEY (pagoId) REFERENCES public.Pagos(id);
ALTER TABLE ONLY public.Ingresos
    ADD CONSTRAINT Ingresos_clienteId_fkey FOREIGN KEY (clienteId) REFERENCES public.Clientes(id);

-- Table: public.Cotizaciones

-- DROP TABLE public.Cotizaciones;
CREATE SEQUENCE Cotizaciones_id_seq START 1;
CREATE TABLE public.Cotizaciones
(
    id bigint NOT NULL DEFAULT nextval('Cotizaciones_id_seq'::regclass),
    clienteId bigint,
    fecha timestamp without time zone,
    activo boolean,
    CONSTRAINT Cotizaciones_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Cotizaciones
    OWNER to postgres;

ALTER TABLE ONLY public.Cotizaciones
    ADD CONSTRAINT Cotizaciones_clienteId_fkey FOREIGN KEY (clienteId) REFERENCES public.Clientes(id);
