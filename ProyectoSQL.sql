#CREACIÓN DE BASE DE DATOS PARA LOCAL DE ROPA DEPORTIVA

drop database if exists proyecto;
create database proyecto;
use proyecto;

#CREACIÓN DE TABLAS

create table Product(SKU varchar(5) not null,NombreProducto varchar(30),PrecioProducto float(4,2), Stock int(4),primary key(SKU));
create table CategoriaProducto(SKU varchar(5) not null,NombreCategoria varchar(30), foreign key(SKU) references Product(SKU),primary key(SKU,NombreCategoria));
create table CategoriaDescuento(CategoriaDescuento varchar(30) not null,Dto float(4,2),primary key(CategoriaDescuento));
create table Cliente(IdCliente int unsigned not null auto_increment,NombreCliente varchar(30),edad int,primary key (IdCliente));
create table Pais( nombrepais varchar(15),nombreciudad varchar(15),primary key(nombreciudad,nombrepais));
create table Pedidos(IdPedidos int unsigned not null auto_increment,IdCliente int unsigned not null, SKU varchar(5) not null,
					 CategoriaDescuento varchar(30) not null,Idciudad varchar(15) not null,Ingresos float(4,2),Unidades int,
                     CostoProducto float(4,2),CostoEnvio float(4,2), CostoEmpaque float(4,2),FechadePedido date,
					 foreign key (IdCliente) references Cliente(IdCliente), 
                     foreign key (SKU) references Product(SKU), foreign key (CategoriaDescuento) references CategoriaDescuento(CategoriaDescuento),
                     foreign key (Idciudad) references Pais(nombreciudad),
                     primary key(IdPedidos));

# El Id del cliente comenzara desde el 10000
alter table Cliente auto_increment=10000;

#Modificacion de tipo de dato
alter table Product modify PrecioProducto float(5,2);

#Armado de tabla Product. Estamos hablando de una tienda de ropa deportiva con los siguientes productos, con su respectivo precio y stock.
insert into Product values ("S01","Nike React Element",99.50,100),("S02","Nike Airmax 1",112.38,50),("S03","Under Armour Charged",52.00,70),
                           ("S04","Adidas Stan Smith",85.50,100),("S05","Air Jordan 1",168.60,40),("S06","Yeezy 700",464,20),
                           ("P01","Nike shorts 5 inch",45.50,60),("P02","Nike Shorts 7 inch",50.50,60), ("S07","Adidas Campus",55.60,80),
                           ("P03","Under Armour Shorts",30.90,60),("P04","Adidas Impact",45.60,30),("SP01","Nike React + Shorts",120.50,15),
                           ("SP02","Yeezy 700 + Adidas Impact",480.50,15),("C01","Nike Compresion",50.50,60),
                           ("C02","Adidas Compresion",51.00,60),("C03","UnderArmour Compresion",55.90,60),("C04","Zara Slim Fit",10.50,200),
                           ("C05","Zara Camiseta Larga",17.90,200),("C06","Zara heavy",25.00,150);
                           

update product set PrecioProducto = 100.00 where SKU="S01";
update product set PrecioProducto = 86.50 where SKU="S04";
                    
#Armado de Tabla CategoriaProducto simplificando la columna SKU con las siguientes lineas.
insert into CategoriaProducto(NombreCategoria,SKU) select "Shoes",SKU from Product where SKU like "S%" and SKU not like "%P%";
insert into CategoriaProducto(NombreCategoria,SKU) select "Pants",SKU from Product where SKU like "P%";
insert into CategoriaProducto(NombreCategoria,SKU) select "Camisetas",SKU from Product where SKU like "C%";
insert into CategoriaProducto(NombreCategoria,SKU) select "Combo",SKU from Product where SKU like "SP%";

#Armado de tabla CategoriaDescuento.
insert into CategoriaDescuento values("Non",0),("DayOfFull",0.15),("CyberMonday",0.2),("BlackFriday",0.25),("SpecialDay",0.35);

#Armado de tabla Cliente. El nombre del cliente generalmente no es necesario pero lo incluyo como muestra-
insert into Cliente(NombreCliente,edad) values("Lionel Messi",34),("Cristiano Ronaldo",37),("Manuel Bargas",22);
insert into Cliente(NombreCliente,edad) values("Lewandowski",31);
insert into Pais(nombrepais,nombreciudad) values ("Argentina","Rosario"),("Portugal","Lisboa"),("Polonia","Varsovia"),("Argentina","Buenos Aires");

#Armado de la tabla Pedidos como tabla Facts. En este caso es importante relacionar correctamente las demas tablas con esta.
alter table Pedidos modify ingresos float(5,2);
insert into Pedidos(IdCliente,SKU,CategoriaDescuento,idciudad,ingresos,Unidades,CostoProducto,CostoEnvio,CostoEmpaque,FechadePedido) values 
(10002,"S04","BlackFriday","Buenos Aires",((select PrecioProducto from Product where SKU ="S04")-((select PrecioProducto from Product where SKU ="S04")*
(select Dto from CategoriaDescuento where CategoriaDescuento="BlackFriday")))*1,1,60.00,10.00,5.00,"2022-02-15"), 
(10001,"P01","SpecialDay","Lisboa",((select PrecioProducto from Product where SKU ="P01")-((select PrecioProducto from Product where SKU ="P01")*
(select Dto from CategoriaDescuento where CategoriaDescuento="BlackFriday")))*1,1,12.00,5.00,3.00,"2022-02-12"),
(10003,"P03","Non","Varsovia",((select PrecioProducto from Product where SKU ="P03")-((select PrecioProducto from Product where SKU ="P03")*
(select Dto from CategoriaDescuento where CategoriaDescuento="Non")))*2,2,13.00,8.00,3.00,"2022-02-10"),
(10001,"S01","Non","Lisboa",((select PrecioProducto from Product where SKU ="S01")-((select PrecioProducto from Product where SKU ="S01")*
(select Dto from CategoriaDescuento where CategoriaDescuento="Non")))*1,1,40.50,20.00,10.00,"2022-02-18"),
(10001,"P03","BlackFriday","Lisboa",((select PrecioProducto from Product where SKU ="P03")-((select PrecioProducto from Product where SKU ="P03")*
(select Dto from CategoriaDescuento where CategoriaDescuento="BlackFriday")))*1,1,16.00,5.00,3.00,"2022-02-23"),
(10003,"S05","Non","Varsovia",((select PrecioProducto from Product where SKU ="S05")-((select PrecioProducto from Product where SKU ="S05")*
(select Dto from CategoriaDescuento where CategoriaDescuento="Non")))*1,1,30.00,10.00,5.00,"2022-02-27"),
(10002,"S05","SpecialDay","Buenos Aires",((select PrecioProducto from Product where SKU ="S05")-((select PrecioProducto from Product where SKU ="S05")*
(select Dto from CategoriaDescuento where CategoriaDescuento="SpecialDay")))*1,1,40.00,20.00,10.00,"2022-02-29"),
(10000,"S02","SpecialDay","Rosario",((select PrecioProducto from Product where SKU ="S02")-((select PrecioProducto from Product where SKU ="S02")*
(select Dto from CategoriaDescuento where CategoriaDescuento="SpecialDay")))*3,3,40.12,20.02,11.00,"2022-03-01"),
(10001,"C05","SpecialDay","Lisboa",((select PrecioProducto from Product where SKU ="C05")-((select PrecioProducto from Product where SKU ="C05")*
(select Dto from CategoriaDescuento where CategoriaDescuento="SpecialDay")))*1,1,12.00,5.00,3.00,"2022-03-5"),
(10001,"C06","SpecialDay","Lisboa",((select PrecioProducto from Product where SKU ="C06")-((select PrecioProducto from Product where SKU ="C06")*
(select Dto from CategoriaDescuento where CategoriaDescuento="SpecialDay")))*1,1,16.00,5.00,3.00,"2022-03-12"),
(10001,"S01","SpecialDay","Lisboa",((select PrecioProducto from Product where SKU ="S01")-((select PrecioProducto from Product where SKU ="S01")*
(select Dto from CategoriaDescuento where CategoriaDescuento="SpecialDay")))*1,1,41.12,18.00,19.00,"2022-03-12");

#Febrero 28 dias
update pedidos set FechadePedido="2022-02-28" where FechadePedido = "0000-00-00";

#Subconsultas y Joins

#Uso de join para verificar clientes y sus respectivos paises.
select distinct c.nombrecliente,pa.nombrepais from cliente as c join pedidos as p on c.idcliente=p.idcliente join pais as pa on pa.nombreciudad=p.idciudad;

#Clientes que mas gastaron en total en subconsultas y su alternativa con join.
select c.nombrecliente,(select sum(ingresos) from pedidos as p where c.idcliente=p.idcliente) as total from cliente as c group by c.nombrecliente;
select c.nombrecliente, (select sum(p.ingresos)) from cliente as c join pedidos as p on c.idcliente=p.idcliente group by c.nombrecliente;

#Subconsulta in para descubrir el nombre del cliente nacido en Lisboa.
select nombrecliente from cliente where idcliente in(select idcliente from pedidos where idciudad="Lisboa");

#Nombre Producto y su respectiva categoria debido a la relacion entre la tabla Product y la tabla Categoria Producto.
select p.nombreproducto,(select c.nombrecategoria from categoriaproducto as c where p.SKU=c.SKU) as categoria from product as p;

#Codigo para descubrir cuantos pedidos hizo cada cliente.
select c.nombrecliente,(select count(p.idcliente) from pedidos as p where p.idcliente=c.idcliente) from cliente as c;
select c.nombrecliente,pd.producto from cliente as c join(select t.*, (select count(sku) from pedidos as p where p.idcliente=t.idcliente) as producto from cliente as t) as pd on pd.idcliente=c.idcliente group by c.nombrecliente;

#Pedidos y detalles de los realizados en la Argentina mediante una subconsulta.
select * from pedidos where idciudad in (select nombreciudad from pais where nombrepais="Argentina");

#Subconsulta any, cuando el dato a devolver es 1.
select nombrecliente from cliente where idcliente=any(select idcliente from pedidos where idcliente=10000);

#Promedio de gasto por cliente y el año extraido de la operación.
select idcliente,(select avg(ingresos)),(select year(fechadepedido)) from pedidos group by idcliente;
select c.nombrecliente,(select avg(p.ingresos) from pedidos as p where p.idcliente=c.idcliente) as promedio from cliente as c;

#Promedio de gasto por cliente redondeado a dos decimales y efectuado con Join.
select c.nombrecliente,pa.nombrepais,round((select avg(p.ingresos)),2) as promedio from cliente as c join pedidos as p on c.idcliente=
p.idcliente right join pais as pa on pa.nombreciudad=p.idciudad group by c.nombrecliente;

#En esta caso realizo una combinacion de join y subconsultas.
select c.nombrecliente,pd.country from cliente as c join (select p.*,(select pa.nombrepais from pais as pa where pa.nombreciudad=p.idciudad) as country
from pedidos as p) as pd on c.idcliente=pd.idcliente group by c.nombrecliente;

#Un caso similar al anterior para contar los pedidos de zapatillas por cada cliente
select  c.nombrecliente,count(pd.total) from cliente as c join (select pro.*,(select cat.nombrecategoria from categoriaproducto as cat
where cat.sku=pro.sku and cat.nombrecategoria="Shoes") as total from product as pro) as pd join pedidos as p on c.idcliente=p.idcliente and pd.sku=p.sku group by c.nombrecliente;

#Promedio de precio de producto por categoria.
select cat.nombrecategoria,round((select avg(p.precioproducto) from product as p where p.sku=cat.sku),2) from categoriaproducto as cat group by cat.nombrecategoria;

#Verificación de pais con combinación.
select c.nombrecliente,pad.paiss from cliente as c join(select p.*,(select nombrepais from pais  as pa where p.idciudad=pa.nombreciudad) as paiss from pedidos as p) as pad
on pad.idcliente=c.idcliente group by c.nombrecliente;

#Más combinación
select c.nombrecliente,count(cat.nombrecategoria) from cliente as c join pedidos as p on p.idcliente=c.idcliente join product as pro
on pro.sku=p.sku join categoriaproducto as cat on cat.sku=pro.sku where pro.Sku like "S%" group by c.nombrecliente;

#Ingresos por categoria
select cat.nombrecategoria,sum(p.ingresos) from categoriaproducto as cat right join product as pro on cat.sku=pro.sku join
pedidos as p on p.sku=pro.sku group by cat.nombrecategoria;

#Pedido segun cliente seleccionado.
select p.nombrepais,count(idpedidos) from pais as p join pedidos on p.nombreciudad=idciudad where Idcliente=10000 group by p.nombrepais;

#Gasto por pais
select   p.nombrepais,sum(ingresos) from pais as p join pedidos on p.nombreciudad=idciudad group by p.nombrepais;

#Verificicacion que el cliente realizo transacciones.
select IdCliente,NombreCliente,edad from Cliente as c where exists(select * from pedidos where c.idcliente=idcliente and Ingresos>80);
select IdCliente,NombreCliente,edad from Cliente where IdCliente in(select IdCliente from Pedidos where Ingresos>80);

#Clientes que pidieron determinado producto
select NombreCliente from Cliente where IdCliente = any(select IdCliente from Pedidos where SKU="S05") group by NombreCliente;

 # Ciudad por cliente con combinación
select distinct c.nombrecliente,pd.ciudad from cliente as c join (select p.*,(select nombreciudad from pais as pa where pa.nombreciudad=p.idciudad) as ciudad
from pedidos as p ) as pd on pd.idcliente=c.idcliente; 

#Gastos de cliente con condicional de promedio
select p.idcliente,p.ingresos from pedidos as p where p.ingresos>(select avg(p.ingresos) from pedidos as p);
select IdCliente,NombreCliente,edad from Cliente where IdCliente in(select IdCliente from Pedidos where Ingresos>(select avg(ingresos)from pedidos));

#Vista
create view vista_ejemplo as select  p.nombrepais as pais,sum(ingresos) as ingresos from pais as p join pedidos on p.nombreciudad=idciudad group by p.nombrepais;

#Vista sobre otra vista
create view vista_p as select pais,ingresos from vista_ejemplo where ingresos < 200;

#Procedimientos

#Cliente por producto pedido
delimiter //
create procedure clientes_producto(in c_sku varchar(5))
begin
	select NombreCliente from Cliente where IdCliente = any(select IdCliente from Pedidos where SKU=c_sku) group by NombreCliente;
end//
delimiter ;

call clientes_producto("P01");

#Recuento pedido por ciudad y categoria de descuento.
delimiter //
create procedure ciudad_descuento (in p_ciudad varchar(30), in p_dto varchar(30))
begin
	select * from pedidos where idciudad = p_ciudad and CategoriaDescuento = p_dto;
end//
delimiter ;

call ciudad_descuento ("Buenos Aires","BlackFriday");

#Promedio y Suma por ciudad seleccionada
delimiter //
create procedure p_cliente_promedioysuma (in p_ciudad varchar(30), out suma float(6,2), out promedio float(6,2))
begin
	select idciudad from pedidos where idciudad = p_ciudad;
    select sum(ingresos) into suma from pedidos where idciudad = p_ciudad;
    select avg(ingresos) into promedio from pedidos where idciudad = p_ciudad;
end //
delimiter ;
drop procedure p_cliente_promedioysuma;
call p_cliente_promedioysuma ("Buenos Aires",@s,@p);
select @s,@p;

#Triggers
#Ejemplo mas común como puede ser un control de stock.
delimiter //
create trigger control_stock
before insert
on pedidos
for each row
begin
	update Product set stock = Product.stock - new.Unidades where new.SKU = Product.SKU;
end//
delimiter ;

