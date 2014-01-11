-- ----------------------------------------------------------------------------------------
-- Modelo de base de datos taxServices
-- ----------------------------------------------------------------------------------------
-- autor <@eduardouio> <Marcelo>
-- copyrigth (c)taxServices.com 2014>
-- version 1.0
-- engine innodb
-- content <estrcutura del modelo de base de datos>
-- Versión del servidor: 5.5.32-0ubuntu0.12.04.1
-- ------------------------------------------------------------------------------------------

CREATE DATABASE taxServices;
USE taxServices;

    -- -------------------------------------------------------------------
    -- Estructura de la entidad cliente
    -- -------------------------------------------------------------------    
    create table cliente(
        id_cliente int not null auto_increment,
        apellidos varchar(80) not null ,        
        nombres varchar(80) not null,
        tel1 varchar(12) not null,
        tel2 varchar(12) default null,
        responsable varchar(50) not null ,
        equipo varchar(45),
        registro timestamp  default current_timestamp on update current_timestamp,
        primary key(apellidos, nombres),
        unique(id_cliente)
      ) engine=innodb
    COMMENT 'Esta tabla tiene registrado el cliente el responsable es la persona que hace 
    el ingreso del registro y el equipo es el nombre del equipo desde el que se ingresa los datos
    ';

    -- -------------------------------------------------------------------
    -- Estructura de la entidad venta
    -- -------------------------------------------------------------------    
    create table venta(
      nro_factura mediumint not null,      
      id_cliente int not null,
      responsable varchar(50),
      fechaVenta date,
      tipoRegistro enum('AFG','EFILE','EFILEDP','ITIN') not null,
      tiempoRetorno datetime,
      observacion text,     
      equipo varchar(45),
      registro timestamp  default current_timestamp on update current_timestamp,
      primary key(nro_factura, id_cliente),
      constraint fk_venta_cliente foreign key (id_cliente)
      references cliente(id_cliente) on update cascade
      )engine=innodb
      COMMENT 'Entidad encargada de registrar las ventas realizadas por taxServices 
          el tiempo de retorno solo se especifica si el tipo de registro es AFG'
    ;



    -- -------------------------------------------------------------------
    -- Estructura de la entidad tramite
    -- -------------------------------------------------------------------    
    create table tramite(
      nro_factura mediumint not null,
      estado enum('PROCESO','ALERTA','PRINTCHECK','PAGADO'),
      responsable varchar(50),
      notas text,
      equipo varchar(45),
      registro timestamp  default current_timestamp on update current_timestamp,
      primary key(nro_factura),
      constraint fk_tramite_venta foreign key(nro_factura)
      references venta(nro_factura) on update cascade
      )engine=innodb;



    -- -------------------------------------------------------------------
    -- Estructura de la entidad cheques
    -- -------------------------------------------------------------------        
    create table devolucion(
      nro_factura mediumint not null,
      nro_cheque varchar(20),
      valor decimal(6,3),
      entregado boolean default false,
      fecha_entrega datetime default null,
      primary key (nro_factura,nro_cheque),
      constraint fk_devolucion_venta foreign key(nro_factura)
      references venta(nro_factura) on update cascade
      )engine=innodb
    COMMENT 'acepta dos o mas pagos para un  mismo tramite, se controla por programacion
    que la suma de los pagos no supere al valor especificado en la venta';
