/*drop database mystories; create database mystories; use mystories; source mystory.sql;*/

CREATE TABLE story 
(
 story int primary key,
 created datetime
 );


/***************************************************/

CREATE TABLE person
(
 id int NOT NULL AUTO_INCREMENT,
 name varchar(64),
 role enum('victim','aggressor'),
 story int,
 PRIMARY KEY (id),
 FOREIGN KEY (story) REFERENCES story(story) ON DELETE CASCADE
 );


/***************************************************/

CREATE TABLE object
(
 id int NOT NULL AUTO_INCREMENT,
 name varchar(64),
 o_type enum('money','weapon'),
 story int,
 PRIMARY KEY (id),
 FOREIGN KEY (story) REFERENCES story(story) ON DELETE CASCADE
 );


/***************************************************/

CREATE TABLE action
(
 verb varchar(64),
 time int,
 subj int,
 d_obj int,
 i_obj int,
 PRIMARY KEY (time,subj),
 FOREIGN KEY (subj) REFERENCES person(id) ON DELETE CASCADE,
 FOREIGN KEY (d_obj) REFERENCES person(id) ON DELETE CASCADE,
 FOREIGN KEY (i_obj) REFERENCES object(id) ON DELETE CASCADE
 );

/***************************************************/

CREATE TABLE status
(
 id int NOT NULL AUTO_INCREMENT,
 i_time int,
 f_time int,
 subj int,
 attribute enum('alive','manipulated','drunk'),
 PRIMARY KEY (id),
 FOREIGN KEY (subj) REFERENCES person(id) ON DELETE CASCADE
 );

CREATE TABLE relationship
(
 id int NOT NULL AUTO_INCREMENT,
 time int,
 subj int,
 obj int,
 relation enum('sibling','spouse'),
 affinity enum('likes','hates','loves','submits','controls'),
 PRIMARY KEY (id),
 FOREIGN KEY (subj) REFERENCES person(id) ON DELETE CASCADE,
 FOREIGN KEY (obj) REFERENCES person(id) ON DELETE CASCADE
);


CREATE TABLE owns
(
 time int,
 subj int,
 item int,
 FOREIGN KEY (subj) REFERENCES person(id) ON DELETE CASCADE,
 FOREIGN KEY (item) REFERENCES object(id) ON DELETE CASCADE
 );


/***************************************************/



/**** INSERT ****/

INSERT INTO story(story,created)  
	VALUES
	(1,'1/1/1'),
	(2,'2/2/2');

SELECT MAX(story) from story ; /*WHERE user=Me; */

/***************************************************/


SELECT MAX(story) from story)
	VALUES
	('al','victim', (SELECT MAX(story) from story) ),
	('parry','aggressor', 1),
	('eliza','aggressor',1);
	
/***************************************************/


INSERT INTO action(verb,time,subj)
	VALUES
	('jump',0, (select id FROM person WHERE name='al' AND story=1) ),
	('bump',1, (select id FROM person WHERE name='al' AND story=1) );


INSERT INTO object(name,o_type,story)
	VALUES
	('knife','weapon',1);


