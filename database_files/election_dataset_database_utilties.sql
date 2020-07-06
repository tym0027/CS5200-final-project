USE us_elections_final;

DROP PROCEDURE IF EXISTS init_topic;
DELIMITER //
CREATE PROCEDURE init_topic
(IN _type VARCHAR(50), IN _name VARCHAR(256))
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
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_into_entity_table;
DELIMITER //
CREATE  PROCEDURE insert_into_entity_table
(IN _type VARCHAR(50), IN _name VARCHAR(256))
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
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_into_election_table;
DELIMITER //
CREATE  PROCEDURE insert_into_election_table
(IN _name VARCHAR(256), IN _off VARCHAR(50), IN _d VARCHAR(50), IN _win VARCHAR(256), IN _lose VARCHAR(256), IN _spoil VARCHAR(256))
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
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS insert_into_event_table;
DELIMITER //
CREATE  PROCEDURE insert_into_event_table
(IN _name VARCHAR(256), IN start_d VARCHAR(50), IN end_d VARCHAR(50))
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
        
END //
DELIMITER ;

# id, _state, winner_vote, winner_dels, loser_vote, loser_dels, spoiler_vote, spoiler_dels
DROP PROCEDURE IF EXISTS insert_into_election_results_table;
DELIMITER //
CREATE  PROCEDURE insert_into_election_results_table
(IN _name VARCHAR(256), IN _state VARCHAR(256), IN winner_vote INT, IN winner_dels INT, IN loser_vote  INT, IN loser_dels INT, IN spoiler_vote  INT, IN spoiler_dels INT)
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
        
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS insert_into_endorsements_table;
DELIMITER //
CREATE  PROCEDURE insert_into_endorsements_table
(IN _name VARCHAR(256), IN endorser VARCHAR(256), IN endorsee VARCHAR(256),IN _date VARCHAR(50))
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
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_into_documents_table;
DELIMITER //
CREATE  PROCEDURE insert_into_documents_table
(IN _name VARCHAR(256), IN _type VARCHAR(50), IN _date VARCHAR(50), IN _src VARCHAR(500))
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
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS insert_into_positions_table;
DELIMITER //
CREATE  PROCEDURE insert_into_positions_table
(IN _author VARCHAR(256), IN _text VARCHAR(5000), IN doc_name VARCHAR(100))
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
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS tag;
DELIMITER //
CREATE  PROCEDURE tag
(IN pos_text VARCHAR(5000), IN topic_name VARCHAR(256))
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
END //
DELIMITER ;


DROP FUNCTION IF EXISTS quick_tid_lookup;
DELIMITER $$
CREATE FUNCTION quick_tid_lookup
(_id INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
	DECLARE _name TEXT;
    
    SELECT topic_name INTO _name 
		FROM topic 
		WHERE topic.master_id = _id;

    RETURN(_name);
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS quick_pid_lookup;
DELIMITER $$
CREATE FUNCTION quick_pid_lookup
(_id INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
	DECLARE _name TEXT;
    
    SELECT position_text INTO _name 
		FROM positions 
		WHERE positions.position_id = _id;

    RETURN(_name);
END $$
DELIMITER ;