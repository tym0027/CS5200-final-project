import pymysql
from topics import *
from os import listdir
from os.path import isfile, join


### CONNECTION to DATABASE
cnx = pymysql.connect(host="localhost", 
									user="root", 
									password="fuckoff99", 
									db="us_elections_final", 
									cursorclass=pymysql.cursors.DictCursor);


### INIT CURSER
cur = cnx.cursor()

def contact_database(sql_stmt, verbosity=True):
	try: 
		if verbosity:
			print("\nMySQL statement: ", sql_stmt)
		cur.execute(sql_stmt)
		if verbosity:
			rows = cur.fetchall()
			for row in rows:
				print("\tresponse: ", row)
	except pymysql.err.IntegrityError:
		print("\tcatch: obj ", sql_stmt.split(",")[1][:-1] ," already in database!!!")
	except:
		print("\tUNEXPECTED ERROR!!!")



### INSERT IDEOLOGICAL TOPIC DATA	
for item in ideological_topics:
	sql_stmt = "CALL init_topic(\"ideological\", \"{name}\")".format(name=item.lower()) # e.g.: "For only {price:.2f} dollars!"; print(txt.format(price = 49));
	contact_database(sql_stmt)

### INSERT POLITICAL ENTITY DATA		
for item in newspapers:
	sql_stmt = "CALL init_topic(\"political_entity\", \"{name}\")".format(name=item.lower()) 
	contact_database(sql_stmt)
	
	# CALL insert_into_entity_table("politician", "John Kennedy");
	sql_stmt = "CALL insert_into_entity_table(\"newspaper\", \"{name}\")".format(name=item.lower())
	contact_database(sql_stmt)


for item in organizations:
	sql_stmt = "CALL init_topic(\"political_entity\", \"{name}\")".format(name=item.lower()) 
	contact_database(sql_stmt)
	
	# CALL insert_into_entity_table("politician", "John Kennedy");
	sql_stmt = "CALL insert_into_entity_table(\"organization\", \"{name}\")".format(name=item.lower())
	contact_database(sql_stmt)		

for item in parties:
	sql_stmt = "CALL init_topic(\"political_entity\", \"{name}\")".format(name=item.lower()) 
	contact_database(sql_stmt)
	
	# CALL insert_into_entity_table("politician", "John Kennedy");
	sql_stmt = "CALL insert_into_entity_table(\"party\", \"{name}\")".format(name=item.lower())
	contact_database(sql_stmt)	

for item in policians:
	sql_stmt = "CALL init_topic(\"political_entity\", \"{name}\")".format(name=item.lower()) 
	contact_database(sql_stmt)
	
	# CALL insert_into_entity_table("politician", "John Kennedy");
	sql_stmt = "CALL insert_into_entity_table(\"polician\", \"{name}\")".format(name=item.lower())
	contact_database(sql_stmt)	

### INSERT CURRENT EVENTS
for item in current_events.keys():
	# INSERT AS TOPIC
	sql_stmt = "CALL init_topic(\"current_event\", \"{name}\")".format(name=item.lower()) 
	contact_database(sql_stmt)
	sql_stmt = "CALL insert_into_event_table(\"{name}\",\"{start_date}\",\"{end_date}\")".format(name=item.lower(), start_date=current_events[item][0],end_date=current_events[item][1]) 
	contact_database(sql_stmt)
		
### INSERT ELECTION DATA
# election_data = open("./elections_results.csv", 'r').read()
for item in elections.keys():
	# INSERT AS TOPIC
	sql_stmt = "CALL init_topic(\"election\", \"{name}\")".format(name=item.lower()) 
	contact_database(sql_stmt)	
	# CALL insert_into_election_table("1962 - Govenor of California", "Govenor (CA)", '1962-11-06', "Pat Brown", "Richard Nixon", "John Kennedy");
	sql_stmt = "CALL insert_into_election_table(\"{name}\",\"{office}\",\"{date}\",\"{winner}\",\"{loser}\",\"{spoiler}\")".format(name=item.lower(),office=elections[item][0], date=elections[item][1], winner=elections[item][2], loser=elections[item][3], spoiler=elections[item][4]) 
	contact_database(sql_stmt)
	# INSERT AS ELECTION
	# CALL insert_into_election_table("1960 - President of the United States", "President (US)", '1960-11-08', "John Kennedy", "Richard Nixon", "none");

### INSERT ELECTION RESULTS DATA	
election_data = open("./data/elections_results.csv", 'r').read().split('\n')
for item in election_data:
	if item == '':
		continue
	arr = item.split(",")
	sql_stmt = "CALL insert_into_election_results_table({name},{state},{wv},{wd},{lv},{ld},{sv},{sd})".format(name=arr[0],state=arr[1],wv=arr[2],wd=arr[3],lv=arr[4],ld=arr[5],sv=arr[6],sd=arr[7]) 
	contact_database(sql_stmt)
	
### INSERT POSITION DATA
onlyfiles = [f for f in listdir("./data/positions/") if isfile(join("./data/positions/", f))]
for f in onlyfiles:
	data = open("./data/positions/" + f, 'r').read().split("\n")
	document_data = data[0].split(",")
	sql_stmt = "CALL insert_into_documents_table(\"{name}\",\"{type}\",\"{date}\",\"{src}\")".format(name=document_data[0],type=document_data[1],date=document_data[2],src=document_data[3])
	contact_database(sql_stmt)
	
	tags = data[2::2]
	text = data[1::2]
	length = len(tags)
	# print(len(tags),len(text))
	# print(tags[0])
	# print(text[0])
	for i  in range(0,length):
		sql_stmt = "CALL insert_into_positions_table(\"{name}\",\"{text}\",\"{doc_name}\")".format(name=document_data[-1], text=text[i],doc_name=document_data[0])
		contact_database(sql_stmt)
		
		for t in tags[i].split(','):
			if t == "":
				continue
			sql_stmt = "CALL tag(\"{text}\",\"{topic}\")".format(text=text[i],topic=t)
			contact_database(sql_stmt)

### INSERT INITIAL ENDORSEMENTS
for item in endorsements:			
	sql_stmt = "CALL insert_into_endorsements_table(\"{election}\", \"{endorser}\",\"{endorsee}\",\"{date}\")".format(election=item[0],endorser=item[1],endorsee=item[2],date=item[3]) 
	contact_database(sql_stmt)

	
cur.close()
cnx.close()
