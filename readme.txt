### Run Environment
	
	I developed both the server and client portions of the database on Windows 10.
	
	My server code was developed using MySQL in MySQL Workbench.
	
	My client code runs on Bash for Windows, so should be theoretically able to run from an ubuntu environment, but I did not test that.

	
	
### Installation

	1. Download Anaconda:
	https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart
	
		NOTE: I was able to use the ubuntu install instructions with Bash for Windows 10
	
	2. Download MySQL Workbench to host Database server:
	https://dev.mysql.com/downloads/workbench/

	3. Install conda environment from environment.yaml
	requires: numpy, pymysql, plotly, pandas, os, sys
	
	4. Run the sql code provided yourself, or import the data dump with associated functions and procedures into mysql workbench.
	
	5. Follow the formatting in the function calls section to use client code 
	
### Function Calls

# load_data.py

	python load_data.py
	
	Loads the data on the disk into the database.
	
# delete_document.py

	python delete_document.py
	
	deletes a document from the document table after a series of prompts to the user.

# fix_name.py

	python fix_name.py
	
	Updates a topic_name in the topic table after a series of prompts to the user.

# get_election_results.py

	python get_election_results.py
	
	Allows a user to select an election whose election results are stored within the databse. Data is read and visualized with a plotly chloropleth.

# get_endorsements.py

	python get_endorsements.py
	
	Allows a user to request all of the endorsements for presidential canidate in a given year - past endorsements are included. 

# get_positions.py

	python get_positions.py "{politician_name-1}" "{politician_name-2}" "{politician_name-N}"
	
	Pass a list of politicians names surrounded in quotes to sample the position statements recorded in the database. 
	Additional prompts allow  the user to further filter the data.

# topics.py

	python topics.py
	
	The storage of all the topics that end up in the topics table.
	
# environment.yml
	
	This is the conda environment file that stores all of the python modules used by the database client

	
### Subdirectories	
	
# data/

	this is where the position and election results data lives.
	- election_results.csv
		This has all of the state election results for all elections. State elections have one entry - the total results for their state.
		Presidential elections have all 50 states and then the total results for the us as a whole
		Results for the presidential election include popular vote totals as well as delegate totals
			(state elections have delgate values set to NULL)
	- ./positions/
		Each document annotated has a file associated with it
		Within each file is a metadata line that goes into the document table
		Every other line is a position taken from the document followed by a single line of topic tags seperated by commas
			
# database_files/

	Here are the raw sql files to reconstruct the database, as well as a data export from MySQL Workbench