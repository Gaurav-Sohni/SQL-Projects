CREATE DATABASE eCommerce;



CREATE TABLE products(
	product_id INT NOT NULL IDENTITY(1,1),
	name VARCHAR(100) NOT NULL,
	unit_type_id INT NOT NULL,
	price_per_unit FLOAT NOT NULL,
	PRIMARY KEY ( product_id )
);



CREATE TABLE unit_type(
	unit_type_id INT NOT NULL IDENTITY (200,1),
	unit_name VARCHAR(100) NOT NULL,
	PRIMARY KEY ( unit_type_id )
);



ALTER TABLE products
	ADD CONSTRAINT FK_unit_type_id 
		FOREIGN KEY ( unit_type_id )
		REFERENCES unit_type ( unit_type_id )
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION;



INSERT INTO 
	unit_type ( unit_name ) 
	VALUES ( 'each' ),( 'KG' ),( 'L' ),( 'pair' );



INSERT INTO
	products ( name, unit_type_id, price_per_unit )
	VALUES ( 'Pen', 200, 5 ), ( 'Oil', 202, 90), ( 'Tomato', 201, 18);



CREATE TABLE customers(
	customer_id INT NOT NULL IDENTITY(100,1),
	customer_name VARCHAR(100) NOT NULL,
	customer_address VARCHAR(200) NOT NULL,
	PRIMARY KEY ( customer_id )
);



CREATE TABLE sellers(
	seller_id INT NOT NULL IDENTITY(1010,1),
	product_id INT NOT NULL,
	PRIMARY KEY ( seller_id ),
	CONSTRAINT FK_product_id FOREIGN KEY ( product_id ) 
		REFERENCES products ( product_id ) 
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION 
);



INSERT INTO 
	customers ( customer_name, customer_address )
	VALUES ( 'Ram', 'Geeta Colony, Delhi'), 
	( 'Bhuvan', 'Laxmi Nagar, Delhi'), 
	( 'Sachin Sharma', 'Patel Nagar, Gurugram');



ALTER TABLE sellers
	ADD	seller_name VARCHAR(100) NOT NULL;
ALTER TABLE sellers
	ADD	seller_address VARCHAR(100) NOT NULL;
ALTER TABLE sellers
	ADD	seller_contact BIGINT NOT NULL;



INSERT INTO 
	sellers( product_id ,seller_name, seller_address, seller_contact  )
	VALUES ( 2,'ABC', 'Delhi', 9898989898), 
	( 1,'Radhey', 'Lucknow', 1212121212), 
	( 3,'360 Kiryana', 'Faridabad', 1234567890);



CREATE TABLE orders(
	order_id INT NOT NULL IDENTITY(10,1),
	customer_id INT NOT NULL,
	total FLOAT NOT NULL,
	datetime SMALLDATETIME,
	PRIMARY KEY ( order_id ),
	FOREIGN KEY ( customer_id )
		REFERENCES customers ( customer_id )
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION
);



CREATE TABLE ordered_items(
	order_id INT NOT NULL, 
	product_id INT NOT NULL,
	seller_id INT NOT NULL, 
	quantity FLOAT NOT NULL,
	total_price FLOAT NOT NULL,
	PRIMARY KEY ( order_id ),
	FOREIGN KEY ( order_id ) 
		REFERENCES orders ( order_id ) 
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION,
	FOREIGN KEY ( product_id ) 
		REFERENCES products ( product_id ) 
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION
);



CREATE TABLE payments(
	order_id INT NOT NULL,
	payment_id INT NOT NULL IDENTITY(9090,1),
	PRIMARY KEY ( payment_id ),
	FOREIGN KEY ( order_id )
		REFERENCES orders ( order_id )
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
);
