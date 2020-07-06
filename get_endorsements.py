import pymysql



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
		print("~"*100)
		print('election\t\t\t\t|\t\tendorser\t|\tendorsee| date')
		print("~"*100)
		print("~"*100)
		if verbosity:
			rows = cur.fetchall()
			for row in rows:
				print(row['quick_tid_lookup(election_id)'],"\t|\t",row["quick_tid_lookup(endorser_id)"],"\t|\t",row['quick_tid_lookup(endorsee_id)'],"|",row["on_date"])
				print("~"*100)
	except pymysql.err.IntegrityError:
		print("\tcatch: obj ", sql_stmt.split(",")[1][:-1] ," already in database!!!")
	except:
		print("\tUNEXPECTED ERROR!!!")


while True:
	_election	= ''
	
	print("\nWould you like to visualize the election results of")
	print("1. the 1960 us presidential election")
	print("2. the 1964 us presidential election")
	print("3. the 1968 us presidential election")
	inp = input("input number here -> ")
	
	if inp not in ['1', '2', '3']:
		continue
	elif inp == '1':
		_election = "the 1960 us presidential election"	
	elif inp == '2':
		_election = "the 1964 us presidential election"	
	elif inp == '3':
		_election = "the 1968 us presidential election"
		
	sql_stmt = "CALL get_endorsements(\"{election}\")".format(election=_election) # e.g.: "For only {price:.2f} dollars!"; print(txt.format(price = 49));
	contact_database(sql_stmt)

		
cur.close()
cnx.close()
