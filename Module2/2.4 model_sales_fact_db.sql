-- ***************************************************;

DROP TABLE IF EXISTS "calendar";

-- ************************************** "calendar"

CREATE TABLE IF NOT EXISTS "calendar"
(
 "date_id"  int NOT NULL,
 "year"     int NOT NULL,
 "quarter"  int NOT NULL,
 "month"    int NOT NULL,
 "week"     int NOT NULL,
 "date"     date NOT NULL,
 "week_day" varchar(20) NOT NULL,
 "leap"  varchar(20) NOT NULL,
 CONSTRAINT "PK_99" PRIMARY KEY ( "date_id" )
);

--deleteing rows calendar
truncate table calendar

--inserting table calendar
insert into calendar 
select 
to_char(date,'yyyymmdd')::int as date_id,  
       extract('year' from date)::int as year,
       extract('quarter' from date)::int as quarter,
       extract('month' from date)::int as month,
       extract('week' from date)::int as week,
       date::date,
       to_char(date, 'dy') as week_day,
       extract('day' from
               (date + interval '2 month - 1 day')
              ) = 29
       as leap
  from generate_series(date '2000-01-01',
                       date '2030-01-01',
                       interval '1 day')
       as t(date);

--checking table calendar
select * from calendar; 

-- ***************************************************;

DROP TABLE IF EXISTS "customer";

-- ************************************** "customer"

CREATE TABLE IF NOT EXISTS "customer"
(
 "cust_id"       int NOT NULL,
 "customer_id"   varchar(8) NOT NULL,
 "customer_name" varchar(22) NOT NULL,
 "segment"       varchar(11) NOT NULL,
 CONSTRAINT "PK_41" PRIMARY KEY ( "cust_id" )
);


--deleting rows
truncate table customer;

--inserting table customer
insert into customer 
select 100+row_number() over(), customer_id, customer_name, segment from (select distinct customer_id, customer_name, segment from orders o) tmp;
	
--checking table customer
select * from customer c 

-- ***************************************************;

DROP TABLE IF EXISTS "shipping";

-- ************************************** "shipping"

CREATE TABLE IF NOT EXISTS "shipping"
(
 "ship_id"   int NOT NULL,
 "ship_mode" varchar(14) NOT NULL,
 CONSTRAINT "PK_28" PRIMARY KEY ( "ship_id" )
);

--deleting rows shipping
truncate table shipping;

--inserting talbe shipping
insert into shipping 
select 100+row_number() over(), ship_mode from (select distinct ship_mode from orders) tmp;

--check table shipping 
select * from shipping s;

-- ***************************************************;

DROP TABLE IF EXISTS "product";

-- ************************************** "product"

CREATE TABLE IF NOT EXISTS "product"
(
 "prod_id"   int NOT NULL,
 "category"     varchar(15) NOT NULL,
 "sub_category" varchar(11) NOT NULL,
 "product_name" varchar(127) NOT NULL,
 "product_id"   varchar(15) NOT NULL,
 CONSTRAINT "PK_22" PRIMARY KEY ( "prod_id" )
);

--deleting rows product
truncate table product;

--inserting talbe product
insert into product 
select 100+row_number() over(), category, subcategory, product_name, product_id from (select distinct category, subcategory, product_name, product_id from orders) tmp;

--check table product 
select * from product p;

-- ***************************************************;

DROP TABLE IF EXISTS "geography";

-- ************************************** "geography"

CREATE TABLE IF NOT EXISTS "geography"
(
 "geo_id"      int NOT NULL,
 "country"     varchar(13) NOT NULL,
 "city"        varchar(17) NOT NULL,
 "state"       varchar(20) NOT NULL,
 "postal_code" integer NULL,
 "region"      varchar(7) NOT NULL,
 CONSTRAINT "PK_10" PRIMARY KEY ( "geo_id" )
);


--deleting rows geography
truncate table geography;

--insert table geography
insert into geography 
select 
	100+row_number() over(), 
	country, 
	city, 
	state,
	postal_code,
	region
	from (
		select distinct country, city, state, postal_code, region from orders
		) tmp;

--check table geography
select * from geography;

select distinct country, city, state, postal_code from geography g 
where country is null or city is null or postal_code is null;

-- City Burlington, Vermont doesn't have postal code
update geography 
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

--also update source file
update orders
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;


select * from geography g 
where city = 'Burlington'


-- ***************************************************;

DROP TABLE IF EXISTS "sales_fact";

-- ************************************** "sales_fact"

CREATE TABLE IF NOT EXISTS "sales_fact"
(
 "row_id"        int NOT NULL,
 "order_id"      varchar(14) NOT NULL,
 "geo_id"        int NOT NULL,
 "sales"         numeric(9, 4) NOT NULL,
 "quantity"      integer NOT NULL,
 "discount"      numeric(4, 2) NOT NULL,
 "profit"        numeric(21, 16) NOT NULL,
 "prod_id"       int NOT NULL,
 "ship_id"       int NOT NULL,
 "cust_id"       int NOT NULL,
 "date_id"       int NOT NULL,
 "order_date_id" integer NOT NULL,
 "ship_date_id"  integer NOT NULL,
 CONSTRAINT "PK_101" PRIMARY KEY ( "row_id" )
);

--deleting rows sales_fact
truncate table sales_fact;

--insert table sales_fact
insert into sales_fact
select 
	100+row_number() over(),
	o.order_id,
	geo_id,
	sales,
	quantity 
	,discount 
	,profit 
	,prod_id 
	,ship_id 
	,cust_id 
	,date_id 
	,to_char(order_date,'yyyymmdd')::int as  order_date_id
	,to_char(ship_date,'yyyymmdd')::int as  ship_date_id
from orders o
inner join calendar cl
on o.order_date = cl."date" 
inner join customer c 
on o.customer_name = c.customer_name and o.segment = c.segment and o.customer_id = c.customer_id
inner join shipping s 
on o.ship_mode  = s.ship_mode
inner join product p 
on o.category = p.category and o.subcategory = p.sub_category and o.product_name = p.product_name and o.product_id = p.product_id
inner join geography g 
on g.country = o.country and o.city = g.city and o.state = g.state and o.postal_code = g.postal_code and o.region = g.region;

--check table sales_fact
select * from sales_fact;

--do you get 9994rows?
select count(*) from sales_fact sf
inner join shipping s on sf.ship_id=s.ship_id
inner join geography g on sf.geo_id=g.geo_id
inner join product p on sf.prod_id=p.prod_id
inner join customer cd on sf.cust_id=cd.cust_id;

