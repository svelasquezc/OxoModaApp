-- MySQL Script generated by MySQL Workbench
-- Tue Feb  2 18:01:27 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema negocio_r
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema negocio_r
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `negocio_r` DEFAULT CHARACTER SET utf8 ;
USE `negocio_r` ;

-- -----------------------------------------------------
-- Table `negocio_r`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`producto` (
  `codigo` VARCHAR(100) NOT NULL COMMENT 'codigo unico de identificacion para productos.',
  `descripcion` TEXT NULL COMMENT 'descripcion arbitraria que el usuario puede asignar a un producto para ayudar a su identificacion.',
  `costo` INT NULL COMMENT 'precio de costo.',
  `pventa_contado` INT NULL,
  `pventa_credito` INT NULL,
  `pventa_mayor` INT NULL,
  `fingreso` DATE NULL,
  `stock` INT NULL,
  `iva` INT NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `negocio_r`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`cliente` (
  `id` VARCHAR(20) NOT NULL COMMENT 'nit o cedula del cliente',
  `nombre` VARCHAR(100) NULL COMMENT 'nombre completo',
  `tel1` VARCHAR(40) NULL COMMENT 'telefono 1 2 3...',
  `tel2` VARCHAR(40) NULL,
  `tel3` VARCHAR(40) NULL,
  `direccion` VARCHAR(100) NULL COMMENT 'direccion, acepta cualquier String.',
  `email` VARCHAR(100) NULL COMMENT 'correo electronico',
  `descripcion` TEXT NULL COMMENT 'una descripcion absolutamente arbitraria que puede servir para cualquier proposito, recordacion etc.',
  `cumple` DATE NULL COMMENT 'solo fecha de cumpleaños sin año',
  `tipo` VARCHAR(50) NULL COMMENT 'Este atributo indica si el cliente es normal o por mayor.',
  `Ubicacion` VARCHAR(120) NULL,
  `forma_cobro` VARCHAR(50) NULL COMMENT 'hay clientes de credito que van a hacer el abono a la factura voluntariamente en el local, mientras qwue hay otros que a los que hay que ir a cobrar. esta columna permite distinguir  entre ambos tipos y porder generar una lista de cobro.',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `negocio_r`.`vendedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`vendedor` (
  `id` VARCHAR(20) NOT NULL COMMENT 'cedula del vendedor.\n\npor defecto se inicia la tabla con un vendedor ficticio para usarlo como valor generico en caso de no querer hacer uso de esta funcionalidad.',
  `nombre` VARCHAR(100) NULL COMMENT 'Nombre completo con apellidos.',
  `tel1` VARCHAR(50) NULL,
  `tel2` VARCHAR(50) NULL,
  `direccion` VARCHAR(50) NULL COMMENT 'direccion de residencia del vendedor',
  `email` VARCHAR(50) NULL,
  `descripcion` TEXT NULL COMMENT 'una descripcion arbitraria que se puede agregar al trabajador si se desea o sonsidere pertinente.',
  `nacimiento` DATE NULL COMMENT 'fecha de nacimiento del vendedor.',
  `fregistro` DATE NULL COMMENT 'Fecha en la que ingreso a trabajar el vendedor.',
  `estado` INT NULL COMMENT 'atributo que indica si el vendedor aun esta activo.\nsi esta activo => 1\nen caso contrario => 0\n\n',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `negocio_r`.`factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`factura` (
  `consecutivo` INT NOT NULL AUTO_INCREMENT COMMENT 'Consecutivo de la factura, es su identificador unico y debe ser configurado segun requerimeintos de la DIAN',
  `saldo` INT NULL COMMENT 'Estadoo de la factura: \nCobrada: \'archivada\'\nPor cobrar: \'activa\'',
  `Cliente_id` VARCHAR(20) NOT NULL COMMENT 'El nit o el cc del cliente que genero esta factura.',
  `fecha` DATE NULL COMMENT 'Fecha en la que se genero la factura.',
  `hora` TIME NULL COMMENT 'instante en que se genero la factura.',
  `Vendedor_id` VARCHAR(20) NOT NULL,
  `forma_pago` VARCHAR(100) NULL,
  `intervalo_pago` INT NULL,
  PRIMARY KEY (`consecutivo`),
  INDEX `fk_Factura_Cliente_idx` (`Cliente_id` ASC) VISIBLE,
  INDEX `fk_Factura_Vendedor1_idx` (`Vendedor_id` ASC) VISIBLE,
  CONSTRAINT `fk_Factura_Cliente`
    FOREIGN KEY (`Cliente_id`)
    REFERENCES `negocio_r`.`cliente` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Factura_Vendedor1`
    FOREIGN KEY (`Vendedor_id`)
    REFERENCES `negocio_r`.`vendedor` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `negocio_r`.`devoluciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`devoluciones` (
  `consecutivo` INT NOT NULL AUTO_INCREMENT,
  `Factura_consecutivo` INT NOT NULL,
  `pventa` INT NULL COMMENT 'el valor de venta de cada prenda',
  `cantidad` INT NULL COMMENT 'el numero de prendas que se desea devolver\n',
  `fecha` DATE NULL COMMENT 'fecha de generacion de la nota a la factura.',
  `hora` TIME NULL COMMENT 'hora de la generacion de la notafactura',
  `Vendedor_id` VARCHAR(20) NOT NULL COMMENT 'vendedor que realiza el registro de la devolucion.',
  `Producto_codigo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`consecutivo`),
  INDEX `fk_NotaCredito_Factura1_idx` (`Factura_consecutivo` ASC) VISIBLE,
  INDEX `fk_NotaCredito_Vendedor1_idx` (`Vendedor_id` ASC) VISIBLE,
  INDEX `fk_NotaCredito_Producto1_idx` (`Producto_codigo` ASC) VISIBLE,
  CONSTRAINT `fk_NotaCredito_Factura1`
    FOREIGN KEY (`Factura_consecutivo`)
    REFERENCES `negocio_r`.`factura` (`consecutivo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_NotaCredito_Vendedor1`
    FOREIGN KEY (`Vendedor_id`)
    REFERENCES `negocio_r`.`vendedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_NotaCredito_Producto1`
    FOREIGN KEY (`Producto_codigo`)
    REFERENCES `negocio_r`.`producto` (`codigo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `negocio_r`.`productoRecord`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`productoRecord` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'identificacion autoincremento.',
  `Factura_consecutivo` INT NOT NULL COMMENT 'El concecutivo de la factur a la que pertenece esta venta',
  `cantidad` INT NULL COMMENT 'Cantidad vendida del producto P, identificado con Producto_codigo.\n',
  `costo` INT NULL,
  `pventa` INT NULL,
  `Producto_codigo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_FacturaRecord_Factura1_idx` (`Factura_consecutivo` ASC) VISIBLE,
  INDEX `fk_FacturaRecord_Producto1_idx` (`Producto_codigo` ASC) VISIBLE,
  CONSTRAINT `fk_FacturaRecord_Factura1`
    FOREIGN KEY (`Factura_consecutivo`)
    REFERENCES `negocio_r`.`factura` (`consecutivo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_FacturaRecord_Producto1`
    FOREIGN KEY (`Producto_codigo`)
    REFERENCES `negocio_r`.`producto` (`codigo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `negocio_r`.`configuracion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`configuracion` (
  `idconf` VARCHAR(100) NOT NULL COMMENT 'un nombre unico para identificar el valor de configuracion',
  `valor` VARCHAR(100) NULL COMMENT 'el vaalor de la configuracion. \n\nun ejemplo puede ser el valor del iva por defecto.\npuede ser idconf=iva_x_defecto\ny valor=19.',
  PRIMARY KEY (`idconf`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `negocio_r`.`cupones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`cupones` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'identificador unico del bono.',
  `Cliente_id` VARCHAR(20) NOT NULL COMMENT 'cc o nit del cliente.\n\nEn el comprobante de bono se imprime el ',
  `valor` INT NULL,
  `fecha` DATE NULL,
  `estado` INT NULL COMMENT 'Este campo indica si el bono ya fue cobrado o no.\n\n1 => el bono esta activo.\n\n0 => el bono ya fue cobrado.',
  `pass` INT NULL COMMENT 'Un numero aleatorio de 4 digitos para hacer mas robusto el procedimiento de redimir un bono.\n\nel numero aleatorio y el cc o nit del cliente se imprimen en el comprobante de bono.\n\na la hora de redimir un bono ',
  `Factura_consecutivo_gen` INT NOT NULL COMMENT 'Id de la factura en que se genera el cupon.',
  `Vendedor_id` VARCHAR(20) NOT NULL,
  `factura_consecutivo_spend` INT NOT NULL COMMENT 'Id de la factura en que se gasta el cupon\n',
  PRIMARY KEY (`id`),
  INDEX `fk_Bonos_Cliente1_idx` (`Cliente_id` ASC) VISIBLE,
  INDEX `fk_Cupones_Factura_gen_idx` (`Factura_consecutivo_gen` ASC) VISIBLE,
  INDEX `fk_Cupones_Vendedor1_idx` (`Vendedor_id` ASC) VISIBLE,
  INDEX `fk_cupones_factura1_spend_idx` (`factura_consecutivo_spend` ASC) VISIBLE,
  CONSTRAINT `fk_Bonos_Cliente1`
    FOREIGN KEY (`Cliente_id`)
    REFERENCES `negocio_r`.`cliente` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Cupones_Factura_gen`
    FOREIGN KEY (`Factura_consecutivo_gen`)
    REFERENCES `negocio_r`.`factura` (`consecutivo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Cupones_Vendedor1`
    FOREIGN KEY (`Vendedor_id`)
    REFERENCES `negocio_r`.`vendedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cupones_factura_spend`
    FOREIGN KEY (`factura_consecutivo_spend`)
    REFERENCES `negocio_r`.`factura` (`consecutivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `negocio_r`.`abonos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `negocio_r`.`abonos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor` INT NULL,
  `fecha` DATE NULL,
  `hora` TIME NULL,
  `Cliente_id` VARCHAR(20) NOT NULL,
  `Factura_consecutivo` INT NOT NULL,
  `Vendedor_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Abonos_Cliente1_idx` (`Cliente_id` ASC) VISIBLE,
  INDEX `fk_Abonos_Factura1_idx` (`Factura_consecutivo` ASC) VISIBLE,
  INDEX `fk_Abonos_Vendedor1_idx` (`Vendedor_id` ASC) VISIBLE,
  CONSTRAINT `fk_Abonos_Cliente1`
    FOREIGN KEY (`Cliente_id`)
    REFERENCES `negocio_r`.`cliente` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Abonos_Factura1`
    FOREIGN KEY (`Factura_consecutivo`)
    REFERENCES `negocio_r`.`factura` (`consecutivo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Abonos_Vendedor1`
    FOREIGN KEY (`Vendedor_id`)
    REFERENCES `negocio_r`.`vendedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;