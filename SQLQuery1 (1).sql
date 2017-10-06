CREATE PARTITION FUNCTION ps_function01 (date)
AS RANGE LEFT FOR VALUES ( '01/01/2005', '01/01/2010', '01/01/2015');
GO



CREATE PARTITION SCHEME ps_scheme01
AS PARTITION ps_function01  TO 
('GP01','GP02','GP03','GP04') 
GO

CREATE TABLE Usuarios(
id int,
nombre varchar(125),
apellidos varchar(125),
direccion varchar(250),
fechaRegistro date,
stado tinyint) on ps_scheme01(fechaRegistro)

insert into Usuarios values(1,'Jonathan','Villena','manuel olguin','01/01/2007',1)
insert into Usuarios values(1,'Jonathan','Villena','manuel olguin','01/01/2004',1)
insert into Usuarios values(1,'Jonathan','Villena','manuel olguin','01/01/2011',1)
insert into Usuarios values(1,'Jonathan','Villena','manuel olguin','01/01/2016',1)

DECLARE @TableName sysname = 'UsuariosHistoricos';
  
SELECT OBJECT_NAME([object_id]) AS table_name, p.partition_number, fg.name, p.rows 
FROM sys.partitions p INNER JOIN sys.allocation_units au 
ON au.container_id = p.hobt_id INNER JOIN sys.filegroups fg 
ON fg.data_space_id = au.data_space_id 
WHERE p.object_id = OBJECT_ID(@TableName) 

alter partition scheme ps_scheme01
next used GP05

alter partition function ps_function01()
split range ('01/01/2017')

insert into Usuarios values(1,'Jonathan','Villena','manuel olguin','01/01/2018',1)


alter partition function ps_function01()
merge range ('01/01/2005')

CREATE TABLE UsuariosHistoricos(
id int,
nombre varchar(125),
apellidos varchar(125),
direccion varchar(250),
fechaRegistro date,
stado tinyint) on GP05


alter table Usuarios
switch partition 3
to UsuariosHistoricos


CREATE DATABASE Usuarios_SS ON
( NAME = Usuarios, 
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Usuarios.SS'
),
( NAME = Arch01, 
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Arch01.SS'
),
( NAME = Arch02, 
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Arch02.SS'
),
( NAME = Arch03, 
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Arch03.SS'
),
( NAME = Arch04, 
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Arch04.SS'
),
( NAME = Arch05, 
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Arch05.SS'
)AS SNAPSHOT OF Usuarios