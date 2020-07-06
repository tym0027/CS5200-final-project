USE us_elections_final;

# QUERY TABLES
SELECT * FROM topic;
SELECT * FROM election;
SELECT * FROM election_result;
SELECT * FROM current_event;
SELECT * FROM political_entity;
SELECT * FROM endorsements;
SELECT * FROM positions;
SELECT * FROM documents;
SELECT * FROM refers_to;

SELECT quick_tid_lookup(author_id) as author,position_text,document_name,quick_tid_lookup(tagged_id) as tag,document_type,publish_date
	FROM positions
	JOIN refers_to ON refers_to.position_id = positions.position_id
    JOIN documents ON documents.document_id = positions.document_id
    WHERE publish_date < "1968-01-01" AND tagged_id = 1;
            
SELECT quick_pid_lookup(position_id), quick_tid_lookup(tagged_id) FROM refers_to ORDER BY position_id;
SELECT quick_pid_lookup(position_id), COUNT(*) as number_of_tags FROM refers_to GROUP BY position_id;
        
SELECT quick_tid_lookup(election_id), quick_tid_lookup(endorser_id), quick_tid_lookup(endorsee_id), on_date 
		FROM endorsements;

SELECT quick_tid_lookup(election_id),quick_tid_lookup(endorser_id),quick_tid_lookup(endorsee_id),on_date FROM endorsements;

SELECT topic.master_id, topic.topic_name, political_entity.entity_type, topic.topic_type FROM political_entity
	JOIN topic	ON topic.master_id = political_entity.master_id;

### THIS IS HOW YOU LOAD DATA - 2 STEP PROCESS
CALL init_topic("ideological", "the self"); # except for idealogical topics - then it is 1 step process

CALL init_topic("political_entity", "Richard Nixon");
CALL insert_into_entity_table("politician", "Richard Nixon");

SELECT election.office, election.election_date, quick_tid_lookup(election.winner_id), quick_tid_lookup(election.loser_id), quick_tid_lookup(election.spoiler_id), election_result.STATE,election_result.winner_popular_vote,election_result.winner_electoral_delegates,election_result.loser_popular_vote,election_result.loser_electoral_delegates,election_result.spoiler_popular_vote,election_result.spoiler_electoral_delegates
			FROM election
            JOIN election_result on election.master_id = election_result.master_id
			WHERE election.master_id = 60;