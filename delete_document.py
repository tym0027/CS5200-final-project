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
	resp = []
	try:
		if verbosity:
			print("\nMySQL statement: ", sql_stmt)
		cur.execute(sql_stmt)
		rows = cur.fetchall()
		for row in rows:
			resp.append(row)
	except pymysql.err.IntegrityError:
		print("\tcatch: pymysql.err.IntegrityError!!!")
	except:
		print("\tUNEXPECTED ERROR!!!")
		
	return resp

while True:
	nums = []
	sql_stmt = "CALL get_documents()"
	resp = contact_database(sql_stmt)
	
	print("\ndocuments: ")
	for i in range(0,len(resp)):
		print(str(resp[i]['document_id']) + ") " + resp[i]['document_name'] + "\n\t" + resp[i]["publish_date"] + "\n\t" + resp[i]["src"])  
		nums.append(str(resp[i]['document_id']))
	ans = input("insert number to delete - > ")
	
	if ans not in nums:
		continue
	_id = ans
	print("You want to delete {" + str(resp[int(ans) - 1]['document_name']) + "} is this correct?")
	ans = input("please use [Yy | Nn] for yes or no - > ")
	if ans not in ['Y', 'y', 'N', 'n']:
		continue
	elif ans in ['N', 'n']:
		print("Restarting...\n")
		continue
	elif ans in ['Y', 'y']:
		sql_stmt = "CALL delete_document(\"{name}\",{id})".format(name=resp[int(_id) - 1]['document_name'],id=int(_id)) # e.g.: "For only {price:.2f} dollars!"; print(txt.format(price = 49));
		contact_database(sql_stmt)
		break
	
cur.close()
cnx.close()