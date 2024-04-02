-- BD. POSTGRESQL. 
-- TABLA
CREATE TABLE ecomsys.tmpCatalogoProducto (
	ideprod int4 NOT NULL,
	codprod varchar(30) NOT NULL,
	nomprod varchar(200) NOT NULL,
	fecregi date NULL,
	CONSTRAINT pktmp_ideprod PRIMARY KEY (ideprod)
);

CREATE UNIQUE INDEX ax_nomprod ON tmpCatalogoProducto USING btree (nomprod);
CREATE UNIQUE INDEX ax_codprod ON tmpCatalogoProducto USING btree (codprod);

-- SECUENCIADOR
CREATE SEQUENCE ecomsys.sq_tmpCatalogoProducto
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- PROCEDIMIENTO
CREATE OR REPLACE FUNCTION ecomsys.instProducto(
    in p_ideprod int4,
    in p_nomprod varchar(30),
    in p_fecregi varchar(10),
    OUT p_cursor REFCURSOR,
    OUT p_codprod varchar(30),
    OUT p_mensaje varchar(100)
)
AS $$
BEGIN
	p_codprod := TO_CHAR(p_ideprod,'P0000');

    INSERT INTO ecomsys.tmpCatalogoProducto (ideprod,codprod,nomprod,fecregi) VALUES (p_ideprod,p_codprod,p_nomprod,p_fecregi::date);
    
    OPEN p_cursor FOR SELECT ideprod,codprod,nomprod,fecregi FROM ecomsys.tmpCatalogoProducto;

	p_mensaje := 'Registro insertado correctamente';
END;
$$ LANGUAGE plpgsql;