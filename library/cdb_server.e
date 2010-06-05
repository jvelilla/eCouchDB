note
	description: "Summary description for {CDB_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDB_SERVER
inherit
	SHARED_HTTP_CLIENT

feature -- Access
	info : STRING
			-- Get MOTD and version
		do
			Result := http.get ("/")
		end

	databases : STRING
			-- Get a list of databases
		do
			Result := http.get ("/_all_dbs")
		end

	config : STRING
			-- Get configuration data
		do
			Result := http.get ("/_config")
		end

	uuids : STRING
			-- Get a number of UUIDs
		do
			Result := http.get ("/_uuids")
		end

	replicate : STRING
			-- Replicate
		do
			--	Result := http.post ()
		end

	stats : STRING
			-- Statistics overview
		do
			Result := http.get ("/_stats")
		end

	active_task : STRING
			-- Active task list
		do
			Result := http.get ("/_active_tasks")
		end

end
