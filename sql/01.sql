CREATE TABLE gutPayments
( idPayment integer primary key
, shortref varchar (3)
, payment varchar(100)
, bVisible smallint default 1 
);

CREATE TABLE items 
( idItem integer primary key
, itemDate	date
, itemDescription varchar(500)
, itemIn	float
, itemOut	float
, refPayment integer
, itemClosed smallint default 0
, itemvisible smallint default 1
); 


