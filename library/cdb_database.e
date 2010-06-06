note
	description: "Summary description for {CDB_DATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDB_DATABASE
inherit
	SHARED_HTTP_CLIENT

feature -- Access
	db_create ( a_db : STRING) : STRING
			-- Database creation
		do
			Result := http.put("/"+a_db,Void)
		end

	delete ( a_db : STRING) : STRING
			-- Database deletion
		do
			Result := http.delete ("/"+a_db)
		end

	info ( a_db : STRING) : STRING
			-- Database information
		do
			Result := http.get ("/"+a_db)
		end

	change_feed ( a_db : STRING) : STRING
			-- Feed of changes in the database
		do
			Result := http.get ("/"+a_db+"/_changes")
		end

	compaction (a_db : STRING) : STRING
			-- Data Compaction
		do
			Result := http.post ("/"+a_db+"/_compact",void)
		end

	bulk_docs (a_db : STRING; documents : STRING) : STRING
			-- Update many documents at once
		do
			Result := http.post ("/"+a_db+"/_bulk_docs/",documents)
		end

	temp_view (a_db : STRING; view_code : STRING) : STRING
			-- Run an ad-hoc view
		do
			Result := http.post ("/"+a_db+"/_temp_view", view_code)
		end

	view_cleanup (a_db : STRING) : STRING
			-- Cleanup view data
		do
			Result := http.post ("/"+a_db+"/_view_cleanup",void)
		end

end
