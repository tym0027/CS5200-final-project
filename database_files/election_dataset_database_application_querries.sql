USE us_elections_final;

DROP PROCEDURE IF EXISTS get_election_result_data;
DELIMITER //
CREATE PROCEDURE get_election_result_data
(IN _election VARCHAR(256))
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
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_endorsements;
DELIMITER //
CREATE PROCEDURE get_endorsements
(IN _election VARCHAR(256))
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
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS fix_name;
DELIMITER //
CREATE PROCEDURE fix_name
(IN old_name VARCHAR(256), IN new_name VARCHAR(256))
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
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS get_documents;
DELIMITER //
CREATE PROCEDURE get_documents
()
BEGIN
	SELECT *
		FROM documents;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_document;
DELIMITER //
CREATE PROCEDURE delete_document
(IN _name VARCHAR(250), IN _id INT)
BEGIN
	DELETE 
		FROM documents
		WHERE document_id = _id
        AND document_name = _name;
	COMMIT;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS get_positions;
DELIMITER //
CREATE PROCEDURE get_positions
(IN _name VARCHAR(250), IN _date VARCHAR(50), IN _tag VARCHAR(250))
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
END //
DELIMITER ;