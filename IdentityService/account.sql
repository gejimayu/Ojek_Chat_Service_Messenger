DROP TABLE IF EXISTS userdata;
DROP TABLE IF EXISTS accesstoken;

CREATE TABLE userdata (
	id_user int NOT NULL AUTO_INCREMENT,
	username varchar(20),
	password varchar(50),
	email varchar(100),
	PRIMARY KEY (id_user)
);

INSERT INTO userdata(username, password, email)
VALUES 	("pikapika", "asdbc", "cobacoba@gmail.com"),
		("pikapika2", "asdbc", "cobacoba2@gmail.com"),
		("pikapika3","asdbc", "cobacoba3@gmail.com"),
		("pikapika4","asdbc", "cobacoba4@gmail.com"),
		("pikapika5","asdbc", "cobacoba5@gmail.com"),
		("pikapika6", "asdbc", "cobacoba6@gmail.com"),
		("pikapika7","asdbc", "cobacoba7@gmail.com"),
		("pikapika8","asdbc", "cobacoba8@gmail.com"),
		("pika", "asdbc", "tes@asd.ib"),
		("pikalol", "asdbc", "asd@gmx.s");

CREATE TABLE accesstoken (
	id_user int NOT NULL,
	token varchar(100),
	expiretime DATETIME
);

INSERT INTO accesstoken
VALUES  (1, "9be9a0968eb941e391f505523d8a8a49", '2017-10-07 23:52:10'),
		(2, "23c41f6f92d642e490eaf5e5797e57bb", '2017-10-07 22:51:55');
