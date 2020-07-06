-- create the database
DROP DATABASE IF EXISTS us_elections_final;
CREATE DATABASE us_elections_final;
-- select the database
USE us_elections_final;

CREATE TABLE topic
(
	master_id				INT	UNIQUE PRIMARY KEY	NOT NULL	AUTO_INCREMENT,
	topic_type				VARCHAR(50)		NOT NULL,
	topic_name				VARCHAR(256)	NOT NULL
);

CREATE TABLE current_event
(
	master_id		INT PRIMARY KEY	auto_increment,
    start_date		DATE	NOT NULL,
    end_date		DATE	NOT NULL,
    
    CONSTRAINT current_event_fk_topic
		FOREIGN KEY (master_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE election
(
	master_id		INT PRIMARY KEY	auto_increment,
    office			VARCHAR(50),
    election_date	VARCHAR(50)	NOT NULL,
    winner_id		INT	NOT NULL,
    loser_id		INT	NOT NULL,
    spoiler_id		INT,
    
    CONSTRAINT election_fk_topic0
		FOREIGN KEY (master_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT election_fk_topic1
		FOREIGN KEY (winner_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT election_fk_topic2
		FOREIGN KEY (loser_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT election_fk_topic3
		FOREIGN KEY (spoiler_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE election_result
(
	master_id						INT,
    # election_year					INT				NOT NULL,
    STATE							VARCHAR(10)		NOT NULL,
    winner_popular_vote				BIGINT	NOT NULL,
    winner_electoral_delegates		BIGINT	NOT NULL,
    loser_popular_vote				BIGINT	NOT NULL,
    loser_electoral_delegates		BIGINT	NOT NULL,
    spoiler_popular_vote			BIGINT,
    spoiler_electoral_delegates		BIGINT,
    
    CONSTRAINT election_result_pk
		PRIMARY KEY (master_id,STATE),
    CONSTRAINT election_result_fk_topic
		FOREIGN KEY (master_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE political_entity
(
	master_id				INT	UNIQUE PRIMARY KEY	NOT NULL,
	entity_type				VARCHAR(50)		NOT NULL,
    
    CONSTRAINT political_entity_fk_topic
		FOREIGN KEY (master_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE endorsements
(
	election_id				INT		NOT NULL,
	endorser_id				INT		NOT NULL,
    endorsee_id				INT		NOT NULL,
    on_date					VARCHAR(50)	NOT NULL,
    
    CONSTRAINT endorsements_pk
		PRIMARY KEY (election_id, endorser_id, endorsee_id),
	CONSTRAINT endorsements_fk_topic0
		FOREIGN KEY (endorser_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT endorsements_fk_topic1
		FOREIGN KEY (endorsee_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT endorsements_fk_topic2
		FOREIGN KEY (election_id)
		REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE documents
(
	document_id				INT	UNIQUE PRIMARY KEY	NOT NULL	auto_increment,
	document_type			VARCHAR(50),
    document_name			VARCHAR(250),
    publish_date			VARCHAR(50),
    src						VARCHAR(500)
);

CREATE TABLE positions
(
	position_id				INT	UNIQUE PRIMARY KEY	NOT NULL	auto_increment,
	author_id				INT	NOT NULL,
    position_text			VARCHAR(5000),
    document_id				INT,
    
    CONSTRAINT positions_fk_documents
		FOREIGN KEY (document_id)
        REFERENCES documents(document_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT positions_fk_topic
		FOREIGN KEY (author_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE refers_to
(
	position_id				INT	NOT NULL,
    tagged_id				INT	NOT NULL,
    
    CONSTRAINT refers_to_pk
		PRIMARY KEY (position_id, tagged_id),
	CONSTRAINT refers_to_fk_positions0
		FOREIGN KEY (position_id)
        REFERENCES positions(position_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT refers_to_fk_topic0
		FOREIGN KEY (tagged_id)
        REFERENCES topic(master_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);