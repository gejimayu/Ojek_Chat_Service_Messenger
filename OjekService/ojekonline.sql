DROP TABLE IF EXISTS user_history;
DROP TABLE IF EXISTS driver_history;
DROP TABLE IF EXISTS order_data;
DROP TABLE IF EXISTS pref_location;
DROP TABLE IF EXISTS driver;
DROP TABLE IF EXISTS user;

CREATE TABLE user (
	id_user int NOT NULL AUTO_INCREMENT,
	name varchar(50),
	username varchar(50),
	prof_pic varchar(255),
	email varchar(100),
	phone_number varchar(20),
	driver_status varchar(10),
	PRIMARY KEY (id_user)
);

INSERT INTO user(name, username, prof_pic, email, phone_number, driver_status) 
VALUES 	("Pika1", "pikapika", "img/pika1.png", "cobacoba@gmail.com", "085723289999", "true"),
		("Pika2", "pikapika2", "img/pika2.png", "cobacoba2@gmail.com", "085723289999", "true"),
		("Pika3", "pikapika3", "img/kakashi.png", "cobacoba3@gmail.com", "085723289999", "true"),
		("Pika4", "pikapika4", "img/naruto1.png", "cobacoba4@gmail.com", "08239293929", "true"),
		("Pika5", "pikapika5", "img/naruto2.jpg", "cobacoba5@gmail.com", "08239293929", "true"),
		("Pika6", "pikapika6", "img/naruto3.jpg", "cobacoba6@gmail.com", "08239293929", "true"),
		("Pika7", "pikapika7", "img/oro.png", "cobacoba7@gmail.com", "085723289999", "false"),
		("Pika8", "pikapika8", "img/sasuke.png", "cobacoba8@gmail.com", "085723289999", "false"),
		("kuning", "pika", "img/blank_ava.png", "tes@asd.ib", "123412341234", "true"),
		("asem", "pikalol", "img/220688.jpg", "asd@gmx.s", "12341234", "true");

CREATE TABLE driver (
	id_driver int NOT NULL,
	avgrating FLOAT,
	num_votes int,
	PRIMARY KEY (id_driver),
	FOREIGN KEY (id_driver) REFERENCES user(id_user)
);

INSERT INTO driver VALUES (1,3.66667,3),(2,0,0),(3,0,0),(4,4,1),(5,0,1),(6,0,0),(9,3,1),(10,3.5,2);

CREATE TABLE pref_location (
	id_loc int NOT NULL AUTO_INCREMENT,
	id_driver int NOT NULL,
	location varchar(255),
	PRIMARY KEY (id_loc),
	FOREIGN KEY (id_driver) REFERENCES driver(id_driver)
);

INSERT INTO `pref_location` VALUES (1,1,'BEC'),(2,1,'ITB'),(3,2,'Jurang'),(4,2,'Kolong Jembatan'),(5,3,'Kuburan'),(6,3,'Jurang'),(7,4,'Kolng Jembatan'),(8,4,'ITB'),(9,5,'BEC'),(10,5,'Kuburan'),(11,6,'Jurang'),(12,6,'Kuburan'),(15,10,'mana ya'),(16,10,'hmm hmm');


CREATE TABLE order_data (
	id_order int NOT NULL AUTO_INCREMENT,
	id_driver int NOT NULL,
	id_user int NOT NULL,
	date_order DATE,
	origin varchar(255),
	destination varchar(255),
	rating int,
	comment varchar(255),
	PRIMARY KEY (id_order),
	FOREIGN KEY (id_driver) REFERENCES driver(id_driver),
	FOREIGN KEY (id_user) REFERENCES user(id_user)
);

INSERT INTO `order_data` VALUES (1,1,10,'2017-10-07','bec','itb',4,'lumayan lah'),(2,10,2,'2017-10-07','cianjur','jakarta',5,'hebat kamu'),(3,9,10,'2017-10-07','cianjur','surabaya',3,'weeew'),(4,10,10,'2017-10-07','surabaya','cianjur',2,'masa dari cianjur ke surabaya makan waktu 3 jam'),(5,1,2,'2017-10-07','Surga','Neraka',4,'mayan'),(6,4,10,'2017-10-07','bec','itb',4,'qwdwq'),(7,1,9,'2017-10-07','Bec','wdw',3,'wdwdw');


CREATE TABLE driver_history (
	id_history int NOT NULL AUTO_INCREMENT,
	id_driver int NOT NULL,
	id_user int NOT NULL,
	date_order DATE,
	customer_name varchar(255),
	origin varchar(255),
	destination varchar(255),
	rating int,
	comment varchar(255),
	hide tinyint(1),
	PRIMARY KEY (id_history)
);

INSERT INTO `driver_history` VALUES (1,1,10,'2017-10-07','asem','bec','itb',4,'lumayan lah',0),(2,10,2,'2017-10-07','Pika2','cianjur','jakarta',5,'hebat kamu',1),(3,9,10,'2017-10-07','asem','cianjur','surabaya',3,'weeew',0),(4,10,10,'2017-10-07','asem','surabaya','cianjur',2,'masa dari cianjur ke surabaya makan waktu 3 jam',1),(5,1,2,'2017-10-07','Pika2','Surga','Neraka',4,'mayan',0),(6,4,10,'2017-10-07','asem','bec','itb',4,'qwdwq',0),(7,1,9,'2017-10-07','kuningan','Bec','wdw',3,'wdwdw',0);

CREATE TABLE user_history (
	id_history int NOT NULL AUTO_INCREMENT,
	id_user int NOT NULL,
	id_driver int NOT NULL,
	date_order DATE,
	customer_name varchar(255),
	origin varchar(255),
	destination varchar(255),
	rating int,
	comment varchar(255),
	hide tinyint(1),
	PRIMARY KEY(id_history)
);

INSERT INTO `user_history` VALUES (1,10,1,'2017-10-07','Pika1','bec','itb',4,'lumayan lah',1),(2,2,10,'2017-10-07','asem','cianjur','jakarta',5,'hebat kamu',1),(3,10,9,'2017-10-07','kuningan','cianjur','surabaya',3,'weeew',0),(4,10,10,'2017-10-07','asem','surabaya','cianjur',2,'masa dari cianjur ke surabaya makan waktu 3 jam',1),(5,2,1,'2017-10-07','Pika1','Surga','Neraka',4,'mayan',1),(6,10,4,'2017-10-07','Pika4','bec','itb',4,'qwdwq',1),(7,9,1,'2017-10-07','Pika1','Bec','wdw',3,'wdwdw',0);
