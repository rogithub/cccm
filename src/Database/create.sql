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
    monto numeric(18,8),
    fechaCaptura timestamp without time zone,
    fechaAplicacion timestamp without time zone,
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

-- Table: public.Compras

-- DROP TABLE public.Compras;
CREATE SEQUENCE Compras_id_seq START 1;
CREATE TABLE public.Compras
(
    id bigint NOT NULL DEFAULT nextval('Compras_id_seq'::regclass),
    proveedorId bigint,
    fecha timestamp without time zone,
    docIdFacturaPdf bigint,
    docIdFacturaXml bigint,
    ivaPorcien numeric(18,8),
    activo boolean,
    CONSTRAINT Compras_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Compras
    OWNER to postgres;

ALTER TABLE ONLY public.Compras
    ADD CONSTRAINT Compras_proveedorId_fkey FOREIGN KEY (proveedorId) REFERENCES public.Proveedores(id);
ALTER TABLE ONLY public.Compras
    ADD CONSTRAINT Compras_IdFacturaPdf_fkey FOREIGN KEY (docIdFacturaPdf) REFERENCES public.Documentos(id);
ALTER TABLE ONLY public.Compras
    ADD CONSTRAINT Compras_IdFacturaXml_fkey FOREIGN KEY (docIdFacturaXml) REFERENCES public.DocumentosXml(id);


-- Table: public.ComprasMateriales

-- DROP TABLE public.ComprasMateriales;
CREATE SEQUENCE ComprasMateriales_id_seq START 1;
CREATE TABLE public.ComprasMateriales
(
    id bigint NOT NULL DEFAULT nextval('ComprasMateriales_id_seq'::regclass),
    compraId bigint,
    materialId bigint,
    cantidad numeric(18,8),
    precio numeric(18,8),
    CONSTRAINT ComprasMateriales_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ComprasMateriales
    OWNER to postgres;

ALTER TABLE ONLY public.ComprasMateriales
    ADD CONSTRAINT ComprasMateriales_compraId_fkey FOREIGN KEY (compraId) REFERENCES public.Compras(id);
ALTER TABLE ONLY public.ComprasMateriales
    ADD CONSTRAINT ComprasMateriales_materialId_fkey FOREIGN KEY (materialId) REFERENCES public.Materiales(id);

-- Table: public.ComprasServicios

-- DROP TABLE public.ComprasServicios;
CREATE SEQUENCE ComprasServicios_id_seq START 1;
CREATE TABLE public.ComprasServicios
(
    id bigint NOT NULL DEFAULT nextval('ComprasServicios_id_seq'::regclass),
    compraId bigint,
    descripcion character varying(500),
    cantidad numeric(18,8),
    precio numeric(18,8),
    CONSTRAINT ComprasServicios_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ComprasServicios
    OWNER to postgres;

ALTER TABLE ONLY public.ComprasServicios
    ADD CONSTRAINT ComprasServicios_compraId_fkey FOREIGN KEY (compraId) REFERENCES public.Compras(id);

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
    docIdFacturaPdf bigint,
    docIdFacturaXml bigint,
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
ALTER TABLE ONLY public.Cotizaciones
    ADD CONSTRAINT Cotizaciones_IdFacturaPdf_fkey FOREIGN KEY (docIdFacturaPdf) REFERENCES public.Documentos(id);
ALTER TABLE ONLY public.Cotizaciones
    ADD CONSTRAINT Cotizaciones_IdFacturaXml_fkey FOREIGN KEY (docIdFacturaXml) REFERENCES public.DocumentosXml(id);

-- Table: public.Presupuestos

-- DROP TABLE public.Presupuestos;
CREATE SEQUENCE Presupuestos_id_seq START 1;
CREATE TABLE public.Presupuestos
(
    id bigint NOT NULL DEFAULT nextval('Presupuestos_id_seq'::regclass),
    cantidad numeric(18,8),
    descripcion character varying(500),
    gastosPorcien numeric(18,8),
    gananciasPorcien numeric(18,8),
    ivaPorcien numeric(18,8),
    cotizacionId bigint,
    CONSTRAINT Presupuestos_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.Presupuestos
    OWNER to postgres;

ALTER TABLE ONLY public.Presupuestos
    ADD CONSTRAINT Presupuestos_cotizacionId_fkey FOREIGN KEY (cotizacionId) REFERENCES public.Cotizaciones(id);


-- Table: public.ServiciosItems

-- DROP TABLE public.ServiciosItems;
CREATE SEQUENCE ServiciosItems_id_seq START 1;
CREATE TABLE public.ServiciosItems
(
    id bigint NOT NULL DEFAULT nextval('ServiciosItems_id_seq'::regclass),
    presupuestoId bigint,
    cantidad numeric(18,8),
    descripcion character varying(500),
    precio numeric(18,8),
    CONSTRAINT ServiciosItems_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ServiciosItems
    OWNER to postgres;

ALTER TABLE ONLY public.ServiciosItems
    ADD CONSTRAINT ServiciosItems_presupuestoId_fkey FOREIGN KEY (presupuestoId) REFERENCES public.Presupuestos(id);

-- Table: public.MaterialesItems

-- DROP TABLE public.MaterialesItems;
CREATE SEQUENCE MaterialesItems_id_seq START 1;
CREATE TABLE public.MaterialesItems
(
    id bigint NOT NULL DEFAULT nextval('MaterialesItems_id_seq'::regclass),
    presupuestoId bigint,
    materialId bigint,
    cantidad numeric(18,8),
    precio numeric(18,8),
    CONSTRAINT MaterialesItems_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.MaterialesItems
    OWNER to postgres;

ALTER TABLE ONLY public.MaterialesItems
    ADD CONSTRAINT MaterialesItems_presupuestoId_fkey FOREIGN KEY (presupuestoId) REFERENCES public.Presupuestos(id);
ALTER TABLE ONLY public.MaterialesItems
    ADD CONSTRAINT MaterialesItems_materialId_fkey FOREIGN KEY (materialId) REFERENCES public.Materiales(id);


-- Table: public.AbonosCotizaciones

-- DROP TABLE public.AbonosCotizaciones;
CREATE SEQUENCE AbonosCotizaciones_id_seq START 1;
CREATE TABLE public.AbonosCotizaciones
(
    id bigint NOT NULL DEFAULT nextval('AbonosCotizaciones_id_seq'::regclass),
    cotizacionId bigint,
    ingresoId bigint,
    CONSTRAINT AbonosCotizaciones_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.AbonosCotizaciones
    OWNER to postgres;

ALTER TABLE ONLY public.AbonosCotizaciones
    ADD CONSTRAINT AbonosCotizaciones_cotizacionId_fkey FOREIGN KEY (cotizacionId) REFERENCES public.Cotizaciones(id);
ALTER TABLE ONLY public.AbonosCotizaciones
    ADD CONSTRAINT AbonosCotizaciones_ingresoId_fkey FOREIGN KEY (ingresoId) REFERENCES public.Ingresos(id);
