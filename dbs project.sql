drop database if exists fest_database3;
CREATE DATABASE `fest_database3` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
use fest_database3;
drop table if exists user;
drop table if exists attending;
drop table if exists performers;
drop table if exists event;
drop table if exists performing;
drop table if exists sponsors;
drop table if exists sponsoring;
drop table if exists vendors;

CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `vendors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone_no` varchar(100) NOT NULL,
  `booth_location` varchar(100) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `sponsors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `contributed_amount` float NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `performers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `genre` varchar(100) NOT NULL,
   `date` varchar(100) NOT NULL,
  `time` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `event` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
   `date` varchar(100) NOT NULL,
  `time` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL,
  `tickets_left` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `performing` (
  `id` int NOT NULL AUTO_INCREMENT,
  `performers_id` int NOT NULL,
  `event_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `performing_cns` (`performers_id`,`event_id`),
  KEY `event_id` (`event_id`),
  CONSTRAINT `performing_ibfk_1` FOREIGN KEY (`performers_id`) REFERENCES `performers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `performing_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `attending` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `event_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attend_cns` (`user_id`,`event_id`),
  KEY `event_id` (`event_id`),
  CONSTRAINT `attending_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `attending_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `sponsoring` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sponsors_id` int NOT NULL,
  `event_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sponsor_cns` (`sponsors_id`,`event_id`),
  KEY `event_id` (`event_id`),
  CONSTRAINT `sponsoring_ibfk_1` FOREIGN KEY (`sponsors_id`) REFERENCES `sponsors` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sponsoring_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 insert into event(name,date,time,location,tickets_left) values ('n2o','2023-04-01', '20:00:00','audi',2);
 insert into event(name,date,time,location,tickets_left) values ('amit trivedi','2023-04-02','20:00:00','south park',2);
select * from event;


drop procedure if exists add_user;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_user`(IN user_name varchar(100),IN user_email varchar(100) ,IN event_name varchar(100))
BEGIN
	 IF (SELECT tickets_left FROM event where name=event_name) > 0 THEN
   BEGIN
      IF NOT EXISTS (SELECT * FROM user WHERE name=user_name AND email=user_email) THEN
      BEGIN
         INSERT INTO user (name, email) VALUES (user_name, user_email);
      END ;
      
      END IF;
      IF EXISTS (SELECT id FROM user WHERE name=user_name) THEN
      BEGIN
         INSERT INTO attending (user_id, event_id) VALUES ((SELECT id FROM user WHERE name=user_name), (SELECT id FROM event WHERE name=event_name));
         UPDATE event SET tickets_left = tickets_left - 1 where name=event_name;
      END;
   END IF;
END;
END IF;

END$$
DELIMITER ;



drop procedure if exists add_performers;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_performers`(IN performer_name varchar(100),IN performer_genre varchar(100) , IN performer_time varchar(100),IN performer_date varchar(100),IN event_name varchar(100))
BEGIN
	IF NOT EXISTS (SELECT * FROM performers WHERE name=performer_name) THEN
      BEGIN
         INSERT INTO performers (name, genre,time, date) VALUES ( performer_name, performer_genre, performer_time,performer_date);
       END ;
      
       END IF;
       IF EXISTS (SELECT id FROM performers WHERE name=performer_name) THEN
      BEGIN
          INSERT INTO performing (performers_id, event_id) VALUES ((SELECT id FROM performers WHERE name=performer_name), (SELECT id FROM event WHERE name=event_name));
          
       END;
    END IF;
END$$
DELIMITER ;

drop procedure if exists add_sponsor;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_sponsor`(IN sponsor_name varchar(100),IN sponsor_amount float ,IN event_name varchar(100))
BEGIN
	 	IF NOT EXISTS (SELECT * FROM sponsors WHERE name=sponsor_name) THEN
     
         INSERT INTO sponsors (name, contributed_amount) VALUES ( sponsor_name,sponsor_amount );
      
      
       END IF;
       IF EXISTS (SELECT id FROM sponsors WHERE name=sponsor_name) THEN
     
          INSERT INTO sponsoring (sponsors_id, event_id) VALUES ((SELECT id FROM sponsors WHERE name=sponsor_name), (SELECT id FROM event WHERE name=event_name));
          
     
    END IF;
END$$
DELIMITER ;
 -- call add_sponsor("pepsi","100000","n2o");

INSERT INTO `fest_database3`.`vendors`(`name`,`phone_no`,`booth_location`,`product_name`)VALUES('Amul','9878886677','South Park','Ice cream');




-- call add_user ("samyak","someing@gmail.com","n2o");


select * from event;





