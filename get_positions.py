import pymysql
import sys


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
	print("\nWould you like to limit position statements to a certain topic?")
	ans = input("please use [Yy | Nn] for yes or no - > ")

	if ans not in ['Y', 'y', 'N', 'n']:
		continue
	elif ans in ['N', 'n']:
		_tag = "all"
	elif ans in ['Y', 'y']:
		_tag = input("\nplease input tag - > ")
		print("Is {" + str(_tag) + "} correct???")
		ans = input("please use [Yy | Nn] for yes or no - > ")
		if ans in ['N', 'n']:
			continue
	
	print("\nWould you like to limit position statements to before a certain date?")
	ans = input("please use [Yy | Nn] for yes or no - > ")

	if ans not in ['Y', 'y', 'N', 'n']:
		continue
	elif ans in ['N', 'n']:
		_date = "none"
	elif ans in ['Y', 'y']:
		_date = input("\nplease input cut off date - > ")
		print("Is {" + str(_date) + "} correct???")
		ans = input("please use [Yy | Nn] for yes or no - > ")
		if ans in ['N', 'n']:
			continue
			
	for pol in sys.argv[1:]:
		_name = pol
		sql_stmt = "CALL get_positions(\"{name}\",\"{date}\",\"{tag}\")".format(name=_name,date=_date,tag=_tag)
		resp = contact_database(sql_stmt)
		
		for row in resp:
			print("\n\n\n",row['author'], " on ", row['publish_date'], " said the following:\n\t",  "\t(excerpted from the ",  row['document_type'], " ", row['document_name'], ")\n\n", row['position_text'],"")
			print("\ntag: ", row['tag'])
		input("\n\n\npress any button to continue...")
	