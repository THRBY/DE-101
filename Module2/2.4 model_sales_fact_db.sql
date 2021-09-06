-- ***************************************************;

DROP TABLE IF EXISTS "calendar";

-- ************************************** "calendar"

CREATE TABLE IF NOT EXISTS "calendar"
(
 "order_date" date NOT NULL,
 "ship_date"  date NOT NULL,
 "year"       int4range NOT NULL,
 "quater"     varchar(5) NOT NULL,
 "month"      int4range NOT NULL,
 "week"       int4range NOT NULL,
 "week_day"   int4range NOT NULL,
 CONSTRAINT "PK_46" PRIMARY KEY ( "order_date", "ship_date" )
);

--
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
--checking
select * from calendar_dim; 

-- ***************************************************;

DROP TABLE IF EXISTS "customer";

-- ************************************** "customer"

CREATE TABLE IF NOT EXISTS "customer"
(
 "customer_id"   varchar(8) NOT NULL,
 "customer_name" varchar(22) NOT NULL,
 "segment"       varchar(11) NOT NULL,
 CONSTRAINT "PK_41" PRIMARY KEY ( "customer_id" )
);

--deleting rows
truncate table customer;

--inserting table customer


--checking table customer


-- ***************************************************;

DROP TABLE IF EXISTS "shipping";

-- ************************************** "shipping"

CREATE TABLE IF NOT EXISTS "shipping"
(
 "ship_id"   int NOT NULL,
 "ship_mode" varchar(14) NOT NULL,
 CONSTRAINT "PK_28" PRIMARY KEY ( "ship_id" )
);


-- ***************************************************;

DROP TABLE IF EXISTS "product";

-- ************************************** "product"

CREATE TABLE IF NOT EXISTS "product"
(
 "product_id"   int NOT NULL,
 "category"     varchar(15) NOT NULL,
 "sub_category" varchar(11) NOT NULL,
 "product_name" varchar(127) NOT NULL,
 CONSTRAINT "PK_22" PRIMARY KEY ( "product_id" )
);



-- ***************************************************;

DROP TABLE IF EXISTS "geography";

-- ************************************** "geography"

CREATE TABLE IF NOT EXISTS "geography"
(
 "geo_id"      int NOT NULL,
 "сountry"     varchar(13) NOT NULL,
 "city"        varchar(17) NOT NULL,
 "state"       varchar(20) NOT NULL,
 "postal_code" int4range NULL,
 "region"      varchar(7) NOT NULL,
 "person"      varchar(17) NOT NULL,
 CONSTRAINT "PK_10" PRIMARY KEY ( "geo_id" )
);



-- ***************************************************;

DROP TABLE IF EXISTS "sales_fact";



-- ************************************** "sales_fact"

CREATE TABLE IF NOT EXISTS "sales_fact"
(
 "row_id"      int4range NOT NULL,
 "order_id"    varchar(14) NOT NULL,
 "geo_id"      int NOT NULL,
 "sales"       numeric(9, 4) NOT NULL,
 "quantity"    int4range NOT NULL,
 "discount"    numeric(4, 2) NOT NULL,
 "profit"      numeric(21, 16) NOT NULL,
 "product_id"  int NOT NULL,
 "ship_id"     int NOT NULL,
 "customer_id" varchar(8) NOT NULL,
 "order_date"  date NOT NULL,
 "ship_date"   date NOT NULL,
 CONSTRAINT "PK_32" PRIMARY KEY ( "row_id" ),
 CONSTRAINT "FK_49" FOREIGN KEY ( "geo_id" ) REFERENCES "geography" ( "geo_id" ),
 CONSTRAINT "FK_52" FOREIGN KEY ( "product_id" ) REFERENCES "product" ( "product_id" ),
 CONSTRAINT "FK_55" FOREIGN KEY ( "ship_id" ) REFERENCES "shipping" ( "ship_id" ),
 CONSTRAINT "FK_61" FOREIGN KEY ( "customer_id" ) REFERENCES "customer" ( "customer_id" ),
 CONSTRAINT "FK_65" FOREIGN KEY ( "order_date", "ship_date" ) REFERENCES "calendar" ( "order_date", "ship_date" )
);

CREATE INDEX "fkIdx_51" ON "sales_fact"
(
 "geo_id"
);

CREATE INDEX "fkIdx_54" ON "sales_fact"
(
 "product_id"
);

CREATE INDEX "fkIdx_57" ON "sales_fact"
(
 "ship_id"
);

CREATE INDEX "fkIdx_63" ON "sales_fact"
(
 "customer_id"
);

CREATE INDEX "fkIdx_68" ON "sales_fact"
(
 "order_date",
 "ship_date"
);




