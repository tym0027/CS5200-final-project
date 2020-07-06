CREATE DATABASE  IF NOT EXISTS `us_elections_final` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `us_elections_final`;
-- MySQL dump 10.13  Distrib 8.0.20, for Win64 (x86_64)
--
-- Host: localhost    Database: us_elections_final
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `current_event`
--

DROP TABLE IF EXISTS `current_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `current_event` (
  `master_id` int NOT NULL AUTO_INCREMENT,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  PRIMARY KEY (`master_id`),
  CONSTRAINT `current_event_fk_topic` FOREIGN KEY (`master_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `document_id` int NOT NULL AUTO_INCREMENT,
  `document_type` varchar(50) DEFAULT NULL,
  `document_name` varchar(250) DEFAULT NULL,
  `publish_date` varchar(50) DEFAULT NULL,
  `src` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`document_id`),
  UNIQUE KEY `document_id` (`document_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `election`
--

DROP TABLE IF EXISTS `election`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `election` (
  `master_id` int NOT NULL AUTO_INCREMENT,
  `office` varchar(50) DEFAULT NULL,
  `election_date` varchar(50) NOT NULL,
  `winner_id` int NOT NULL,
  `loser_id` int NOT NULL,
  `spoiler_id` int DEFAULT NULL,
  PRIMARY KEY (`master_id`),
  KEY `election_fk_topic1` (`winner_id`),
  KEY `election_fk_topic2` (`loser_id`),
  KEY `election_fk_topic3` (`spoiler_id`),
  CONSTRAINT `election_fk_topic0` FOREIGN KEY (`master_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `election_fk_topic1` FOREIGN KEY (`winner_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `election_fk_topic2` FOREIGN KEY (`loser_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `election_fk_topic3` FOREIGN KEY (`spoiler_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `election_result`
--

DROP TABLE IF EXISTS `election_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `election_result` (
  `master_id` int NOT NULL,
  `STATE` varchar(10) NOT NULL,
  `winner_popular_vote` bigint NOT NULL,
  `winner_electoral_delegates` bigint NOT NULL,
  `loser_popular_vote` bigint NOT NULL,
  `loser_electoral_delegates` bigint NOT NULL,
  `spoiler_popular_vote` bigint DEFAULT NULL,
  `spoiler_electoral_delegates` bigint DEFAULT NULL,
  PRIMARY KEY (`master_id`,`STATE`),
  CONSTRAINT `election_result_fk_topic` FOREIGN KEY (`master_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `endorsements`
--

DROP TABLE IF EXISTS `endorsements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `endorsements` (
  `election_id` int NOT NULL,
  `endorser_id` int NOT NULL,
  `endorsee_id` int NOT NULL,
  `on_date` varchar(50) NOT NULL,
  PRIMARY KEY (`election_id`,`endorser_id`,`endorsee_id`),
  KEY `endorsements_fk_topic0` (`endorser_id`),
  KEY `endorsements_fk_topic1` (`endorsee_id`),
  CONSTRAINT `endorsements_fk_topic0` FOREIGN KEY (`endorser_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `endorsements_fk_topic1` FOREIGN KEY (`endorsee_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `endorsements_fk_topic2` FOREIGN KEY (`election_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `political_entity`
--

DROP TABLE IF EXISTS `political_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `political_entity` (
  `master_id` int NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  PRIMARY KEY (`master_id`),
  UNIQUE KEY `master_id` (`master_id`),
  CONSTRAINT `political_entity_fk_topic` FOREIGN KEY (`master_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `positions` (
  `position_id` int NOT NULL AUTO_INCREMENT,
  `author_id` int NOT NULL,
  `position_text` varchar(5000) DEFAULT NULL,
  `document_id` int DEFAULT NULL,
  PRIMARY KEY (`position_id`),
  UNIQUE KEY `position_id` (`position_id`),
  KEY `positions_fk_documents` (`document_id`),
  KEY `positions_fk_topic` (`author_id`),
  CONSTRAINT `positions_fk_documents` FOREIGN KEY (`document_id`) REFERENCES `documents` (`document_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `positions_fk_topic` FOREIGN KEY (`author_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `refers_to`
--

DROP TABLE IF EXISTS `refers_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refers_to` (
  `position_id` int NOT NULL,
  `tagged_id` int NOT NULL,
  PRIMARY KEY (`position_id`,`tagged_id`),
  KEY `refers_to_fk_topic0` (`tagged_id`),
  CONSTRAINT `refers_to_fk_positions0` FOREIGN KEY (`position_id`) REFERENCES `positions` (`position_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `refers_to_fk_topic0` FOREIGN KEY (`tagged_id`) REFERENCES `topic` (`master_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `topic` (
  `master_id` int NOT NULL AUTO_INCREMENT,
  `topic_type` varchar(50) NOT NULL,
  `topic_name` varchar(256) NOT NULL,
  PRIMARY KEY (`master_id`),
  UNIQUE KEY `master_id` (`master_id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'us_elections_final'
--

--
-- Dumping routines for database 'us_elections_final'
--
/*!50003 DROP FUNCTION IF EXISTS `quick_pid_lookup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `quick_pid_lookup`(_id INT) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE _name TEXT;
    
    SELECT position_text INTO _name 
		FROM positions 
		WHERE positions.position_id = _id;

    RETURN(_name);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `quick_tid_lookup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `quick_tid_lookup`(_id INT) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE _name TEXT;
    
    SELECT topic_name INTO _name 
		FROM topic 
		WHERE topic.master_id = _id;

    RETURN(_name);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_document` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_document`(IN _name VARCHAR(250), IN _id INT)
BEGIN
	DELETE 
		FROM documents
		WHERE document_id = _id
        AND document_name = _name;
	COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fix_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fix_name`(IN old_name VARCHAR(256), IN new_name VARCHAR(256))
BEGIN
	DECLARE _id INT;
    
	SELECT master_id INTO _id
		FROM topic
		WHERE topic_name = old_name;

	UPDATE topic
		SET topic_name = new_name
		WHERE master_id = _id;
	COMMIT;
    
	SELECT *
		FROM topic
		WHERE topic_name = new_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_documents` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_documents`()
BEGIN
	SELECT *
		FROM documents;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_election_result_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_election_result_data`(IN _election VARCHAR(256))
BEGIN
	DECLARE cnt int;
    DECLARE id int;
    
	SELECT topic.master_id, COUNT(*) INTO id, cnt 
		FROM topic
        WHERE topic.topic_name = _election;
        
	if cnt > 0 THEN
		SELECT election.office, election.election_date, quick_tid_lookup(election.winner_id), quick_tid_lookup(election.loser_id), quick_tid_lookup(election.spoiler_id), election_result.STATE,election_result.winner_popular_vote,election_result.winner_electoral_delegates,election_result.loser_popular_vote,election_result.loser_electoral_delegates,election_result.spoiler_popular_vote,election_result.spoiler_electoral_delegates
			FROM election
            JOIN election_result on election.master_id = election_result.master_id
			WHERE election.master_id = id;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_endorsements` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_endorsements`(IN _election VARCHAR(256))
BEGIN
	DECLARE _date VARCHAR(50);
    DECLARE _id INT;
    DECLARE candidate1 INT;
    DECLARE candidate2 INT;
    DECLARE candidate3 INT;
	
    SELECT topic.master_id, election.election_date, election.winner_id, election.loser_id, election.spoiler_id INTO _id, _date, candidate1, candidate2, candidate3
		FROM topic
        JOIN election ON topic.master_id = election.master_id
        WHERE topic.topic_name = _election;
   
	SELECT quick_tid_lookup(election_id), quick_tid_lookup(endorser_id), quick_tid_lookup(endorsee_id), on_date 
		FROM endorsements
        WHERE endorsements.on_date < _date
        AND (endorsements.endorsee_id = candidate1 OR endorsements.endorsee_id = candidate2 OR endorsements.endorsee_id = candidate3);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_positions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_positions`(IN _name VARCHAR(250), IN _date VARCHAR(50), IN _tag VARCHAR(250))
BEGIN
	DECLARE _id INT;
    DECLARE _cnt INT;
    DECLARE _tag_id INT;
	
    SELECT master_id INTO _id
		FROM topic
		WHERE topic_name = _name;
    
    if _tag != "all" then
		SELECT master_id,COUNT(*) INTO _tag_id,_cnt
			FROM topic
			WHERE topic_name = _tag;
	end if;
    
    if _cnt > 0 OR _tag = "all" then
		if _date = "none" then
			if _tag = "all" then
				SELECT quick_tid_lookup(author_id) as author,position_text,document_name,quick_tid_lookup(tagged_id) as tag,document_type,publish_date
					FROM positions
					JOIN refers_to ON refers_to.position_id = positions.position_id
					JOIN documents ON documents.document_id = positions.document_id
                    WHERE author_id = _id;
			else
				SELECT quick_tid_lookup(author_id) as author,position_text,document_name,quick_tid_lookup(tagged_id) as tag,document_type,publish_date
					FROM positions
					JOIN refers_to ON refers_to.position_id = positions.position_id
					JOIN documents ON documents.document_id = positions.document_id
                    WHERE author_id = _id
                    AND tagged_id = _tag_id;
			end if;
		else
			if _tag = "all" then
				SELECT quick_tid_lookup(author_id) as author,position_text,document_name,quick_tid_lookup(tagged_id) as tag,document_type,publish_date
					FROM positions
					JOIN refers_to ON refers_to.position_id = positions.position_id
					JOIN documents ON documents.document_id = positions.document_id
					WHERE author_id = _id
                    AND publish_date < _date;
			else
				SELECT quick_tid_lookup(author_id) as author,position_text,document_name,quick_tid_lookup(tagged_id) as tag,document_type,publish_date
					FROM positions
					JOIN refers_to ON refers_to.position_id = positions.position_id
					JOIN documents ON documents.document_id = positions.document_id
					WHERE author_id = _id
                    AND publish_date < _date
                    AND tagged_id = _tag_id;
			end if;
		end if;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_topic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_topic`(IN _type VARCHAR(50), IN _name VARCHAR(256))
BEGIN
	DECLARE cnt int;
    
	SELECT COUNT(*) INTO cnt 
		FROM topic 
        WHERE  topic.topic_type = _type
        AND topic.topic_name = _name;
	if cnt = 0 THEN
		insert into topic (topic_type,topic_name) values (_type,_name);
        COMMIT;
	END IF;
    
	SELECT *
		FROM topic 
		WHERE  topic.topic_type = _type
		AND topic.topic_name = _name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_into_documents_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_documents_table`(IN _name VARCHAR(256), IN _type VARCHAR(50), IN _date VARCHAR(50), IN _src VARCHAR(500))
BEGIN
	DECLARE cnt INT;
    
	SELECT COUNT(*) INTO cnt 
		FROM documents 
        WHERE  documents.document_type = _type
        AND documents.document_name = _name;
	if cnt = 0 THEN
		insert into documents (document_type,document_name,publish_date,src) values (_type,_name,_date,_src);
        COMMIT;
	END IF;
    
    SELECT *
		FROM documents 
        WHERE  documents.document_type = _type
        AND documents.document_name = _name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_into_election_results_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_election_results_table`(IN _name VARCHAR(256), IN _state VARCHAR(256), IN winner_vote INT, IN winner_dels INT, IN loser_vote  INT, IN loser_dels INT, IN spoiler_vote  INT, IN spoiler_dels INT)
BEGIN
	DECLARE cnt int;
    DECLARE cnt1 int;
    DECLARE id int;
    
	SELECT COUNT(*), master_id INTO cnt, id
		FROM topic 
        WHERE topic.topic_name = _name;
    
    SELECT COUNT(*) INTO cnt1
		FROM election_result
        WHERE master_id = id AND STATE = _state;
        
    if cnt > 0 AND cnt1 = 0 THEN
		insert into election_result (master_id, STATE, winner_popular_vote, winner_electoral_delegates, loser_popular_vote, loser_electoral_delegates, spoiler_popular_vote, spoiler_electoral_delegates) values (id, _state, winner_vote, winner_dels, loser_vote, loser_dels, spoiler_vote, spoiler_dels);
        COMMIT;
    END IF;
    SELECT *
		FROM election_result
        WHERE master_id = id AND STATE = _state;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_into_election_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_election_table`(IN _name VARCHAR(256), IN _off VARCHAR(50), IN _d VARCHAR(50), IN _win VARCHAR(256), IN _lose VARCHAR(256), IN _spoil VARCHAR(256))
BEGIN
	DECLARE cnt int;
    DECLARE cnt1 int;
    DECLARE id int;
    DECLARE win_id int;
    DECLARE lose_id int;
    DECLARE spoil_id int;
    
	SELECT COUNT(*), master_id INTO cnt, id
		FROM topic 
        WHERE topic.topic_name = _name;

	SELECT master_id INTO win_id
		FROM topic 
        WHERE  topic.topic_type = "political_entity"
        AND topic.topic_name = _win;
        
	SELECT master_id INTO lose_id
		FROM topic 
        WHERE  topic.topic_type = "political_entity"
        AND topic.topic_name = _lose;
	
    if _spoil != "none" THEN
		SELECT master_id INTO spoil_id
			FROM topic 
			WHERE  topic.topic_type = "political_entity"
			AND topic.topic_name = _spoil;
    END IF;
    
    SELECT COUNT(*) INTO cnt1
		FROM election
        WHERE master_id = id;
    
    if cnt > 0 AND cnt1 = 0 THEN
		if _spoil = "none" THEN
			insert into election (master_id,office,election_date,winner_id,loser_id) values (id,_off,_d,win_id,lose_id);
        ELSE
			insert into election (master_id,office,election_date,winner_id,loser_id,spoiler_id) values (id,_off,_d,win_id,lose_id,spoil_id);
        END IF;
        COMMIT;
    END IF;
    
    SELECT *
		FROM election
        WHERE master_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_into_endorsements_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_endorsements_table`(IN _name VARCHAR(256), IN endorser VARCHAR(256), IN endorsee VARCHAR(256),IN _date VARCHAR(50))
BEGIN
	DECLARE cnt1 int;
    DECLARE cnt2 int;
    DECLARE cnt3 int;
    DECLARE cnt4 int;
    DECLARE eid int;
    DECLARE _endorser_id int;
    DECLARE _endorsee_id int;
    
	SELECT COUNT(*), master_id INTO cnt1, eid
		FROM topic 
        WHERE topic.topic_name = _name;
	
    SELECT COUNT(*), master_id INTO cnt2, _endorser_id
		FROM topic 
        WHERE topic.topic_name = endorser;
    
    SELECT COUNT(*), master_id INTO cnt3, _endorsee_id
		FROM topic 
        WHERE topic.topic_name = endorsee;
    
    SELECT COUNT(*) INTO cnt4
		FROM endorsements
        WHERE election_id = eid AND endorser_id=_endorser_id AND endorsee_id=_endorsee_id;
    
    if cnt1 > 0 AND cnt2 > 0 AND cnt3 > 0 AND cnt4 = 0 THEN
		insert into endorsements (election_id,endorser_id,endorsee_id,on_date) values (eid,_endorser_id,_endorsee_id,_date);
        COMMIT;
    END IF;
    
    SELECT *
		FROM endorsements
        WHERE election_id = eid AND endorser_id=_endorser_id AND endorsee_id=_endorsee_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_into_entity_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_entity_table`(IN _type VARCHAR(50), IN _name VARCHAR(256))
BEGIN
	DECLARE cnt int;
    DECLARE cnt1 int;
    DECLARE id int;
    
	SELECT COUNT(*), master_id INTO cnt, id
		FROM topic 
        WHERE topic.topic_name = _name;
	
    SELECT COUNT(*) INTO cnt1
		FROM political_entity 
		WHERE  master_id = id;
        
    if cnt > 0 AND cnt1 = 0 THEN
		insert into political_entity (master_id,entity_type) values (id,_type);
        COMMIT;
    END IF;
    
    SELECT *
		FROM political_entity 
		WHERE  master_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_into_event_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_event_table`(IN _name VARCHAR(256), IN start_d VARCHAR(50), IN end_d VARCHAR(50))
BEGIN
	DECLARE cnt int;
    DECLARE cnt1 int;
    DECLARE id int;
    DECLARE win_id int;
    DECLARE lose_id int;
    DECLARE spoil_id int;
    
	SELECT COUNT(*), master_id INTO cnt, id
		FROM topic 
        WHERE topic.topic_name = _name;
    
    SELECT COUNT(*) INTO cnt1
		FROM current_event 
		WHERE  master_id = id;
	
    if cnt > 0 and cnt1 = 0 THEN
		insert into current_event (master_id,start_date,end_date) values (id,start_d,end_d);
        COMMIT;
    END IF;
	
    SELECT *
		FROM current_event 
		WHERE  master_id = id;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_into_positions_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_positions_table`(IN _author VARCHAR(256), IN _text VARCHAR(5000), IN doc_name VARCHAR(100))
BEGIN
	DECLARE cnt INT;
    DECLARE cnt1 INT;
    DECLARE cnt2 INT;
    DECLARE aid INT;
    DECLARE did INT;
    
	SELECT COUNT(*) INTO cnt 
		FROM positions 
        WHERE  positions.position_text = _text;
    
    SELECT COUNT(*), master_id INTO cnt1, aid
		FROM topic 
        WHERE topic.topic_name = _author;
    
    SELECT COUNT(*), document_id INTO cnt2, did
		FROM documents 
        WHERE documents.document_name = doc_name;
    
	if cnt = 0 AND cnt1 > 0 AND cnt2 > 0 THEN
		insert into positions (author_id, position_text, document_id) values (aid, _text, did);
        COMMIT;
	END IF;
    
    SELECT *
		FROM positions 
        WHERE  positions.position_text = _text
        AND positions.author_id = aid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tag`(IN pos_text VARCHAR(5000), IN topic_name VARCHAR(256))
BEGIN
	DECLARE cnt INT;
    DECLARE cnt1 INT;
    DECLARE cnt2 INT;
    DECLARE pid INT;
    DECLARE tid INT;
    
    SELECT COUNT(*), master_id INTO cnt1, tid
		FROM topic 
        WHERE topic.topic_name = topic_name;
	
    SELECT COUNT(*), position_id INTO cnt2, pid
		FROM positions 
        WHERE  positions.position_text = pos_text;
    
    SELECT COUNT(*) INTO cnt 
		FROM refers_to 
        WHERE  refers_to.position_id = pid
        AND refers_to.tagged_id = tid;
	# SET cnt = 0;
	if cnt = 0 AND cnt1 > 0 AND cnt2 > 0 THEN
		insert into refers_to (position_id, tagged_id) values (pid, tid);
        COMMIT;
	END IF;
    
    SELECT *
		FROM refers_to 
        WHERE  refers_to.position_id = pid
        AND refers_to.tagged_id = tid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-06-21 22:51:45
