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

		if verbosity:
			rows = cur.fetchall()
			for row in rows:
				print(row)
	except pymysql.err.IntegrityError:
		print("\tcatch: obj ", sql_stmt.split(",")[1][:-1] ," already in database!!!")
	except:
		print("\tUNEXPECTED ERROR!!!")

while True:
	print("insert old name ")
	old_name = input(" - > ")
	
	print("insert new name ")
	new_name = input(" - > ")
	
	print("Confirm: changing name {" + old_name + "} to new name {" + new_name + "}")
	print("Is this correct?")
	ans = input("please use [Yy | Nn] for yes or no - > ")
	
	if ans not in ['Y', 'y', 'N', 'n']:
		continue
	elif ans in ['N', 'n']:
		print("Restarting...\n")
		continue
	elif ans in ['Y', 'y']:
		sql_stmt = "CALL fix_name(\"{old_name}\",\"{new_name}\")".format(old_name=old_name,new_name=new_name) # e.g.: "For only {price:.2f} dollars!"; print(txt.format(price = 49));
		contact_database(sql_stmt)
		break
	
cur.close()
cnx.close()
