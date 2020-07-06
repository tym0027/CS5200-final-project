import plotly.express as px
import plotly.graph_objects as go

import pymysql
import pandas as pd
import numpy as np


### CONNECTION to DATABASE
cnx = pymysql.connect(host="localhost", 
									user="root", 
									password="fuckoff99", 
									db="us_elections_final", 
									cursorclass=pymysql.cursors.DictCursor);


### INIT CURSER
cur = cnx.cursor()

# initialize list of lists 

data = []; 
locations = [];
colors = [];
title = ''
winner = ''
loser = ''
spoiler = ''
  
def contact_database(sql_stmt, verbosity=True):
	global title, winner, loser, spoiler
	try:
		if verbosity:
			print("\nMySQL statement: ", sql_stmt)
		cur.execute(sql_stmt)
		if verbosity:
			rows = cur.fetchall()
			for row in rows:
				print("\tresponse: ", row)
				if row['STATE'] == 'us':
					continue
				title = row['office'] + " " + row["election_date"]
				
				winner = row['quick_tid_lookup(election.winner_id)']
				loser = row['quick_tid_lookup(election.loser_id)']
				spoiler = row['quick_tid_lookup(election.spoiler_id)']
				map = [winner,loser,spoiler]
				
				locations.append(row['STATE'].upper())
				# np.array([row['winner_popular_vote'],row['loser_popular_vote'],row['spoiler_popular_vote']])

				value = max([row['winner_popular_vote'],row['loser_popular_vote'],row['spoiler_popular_vote']])
				color = [row['winner_popular_vote'],row['loser_popular_vote'],row['spoiler_popular_vote']].index(value)
				colors.append(map[color])
				data.append([row['STATE'].upper(),row['winner_popular_vote'],row['loser_popular_vote'],row['spoiler_popular_vote']])
	except pymysql.err.IntegrityError:
		print("\tcatch: obj ", sql_stmt.split(",")[1][:-1] ," already in database!!!")
	except:
		print("\tUNEXPECTED ERROR!!!")


while True:
	data = []; 
	locations = [];
	colors = [];
	title = ''
	winner = ''
	loser = ''
	spoiler = ''
	
	print("Would you like to visualize the election results of")
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
		
	sql_stmt = "CALL get_election_result_data(\"{election}\")".format(election=_election)
	contact_database(sql_stmt)

	df = pd.DataFrame(data, columns = ['code',str(winner),str(loser),str(spoiler)])


	# fig = px.choropleth(df,locations=["CA", "TX", "NY"], locationmode="USA-states", color=[1,2,3], scope="usa")
	fig = px.choropleth(df,locations=locations, locationmode="USA-states", color=colors, scope="usa",hover_name=df['code'],hover_data=[str(winner),str(loser),str(spoiler)],title=title)
	fig.show()
	print()