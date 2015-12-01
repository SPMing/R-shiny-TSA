CREATE TABLE `spm1`.`facebook` (
  `Date` DATE NOT NULL,
  `Open` FLOAT NULL,
  `High` FLOAT NULL,
  `Low` FLOAT NULL,
  `Close` FLOAT NULL,
  `Volumn` INT NULL,
  `AdjClose` FLOAT NULL,
  PRIMARY KEY (`Date`));


CREATE TABLE `spm1`.`tesla` (
  `Date` DATE NOT NULL,
  `Open` FLOAT NULL,
  `High` FLOAT NULL,
  `Low` FLOAT NULL,
  `Close` FLOAT NULL,
  `Volumn` INT NULL,
  `AdjClose` FLOAT NULL,
  PRIMARY KEY (`Date`));
  
CREATE TABLE `spm1`.`gopro` (
  `Date` DATE NOT NULL,
  `Open` FLOAT NULL,
  `High` FLOAT NULL,
  `Low` FLOAT NULL,
  `Close` FLOAT NULL,
  `Volumn` INT NULL,
  `AdjClose` FLOAT NULL,
  PRIMARY KEY (`Date`));



LOAD DATA LOCAL INFILE  'C:/Users/Administrator/Desktop/table.csv'
INTO TABLE spm1.apple
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE  'C:/Users/Administrator/Desktop/tablefb.csv'
INTO TABLE spm1.facebook
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE  'C:/Users/Administrator/Desktop/tablegopro.csv'
INTO TABLE spm1.gopro
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from spm1.apple where Date > '2015-03-11';