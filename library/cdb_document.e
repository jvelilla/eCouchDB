note
	description: "Summary description for {CDB_DOCUMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDB_DOCUMENT
inherit
	SHARED_HTTP_CLIENT

feature -- Access
	list ( a_db : STRING) : STRING
			-- List of all documents
		do
			Result := http.get ("/"+a_db+"/_all_docs")
		end

	get ( a_db : STRING; a_doc : STRING) : STRING
			-- Retrieve a document
		do
			Result := http.get ("/"+a_db+"/"+a_doc)
		end

	update ( a_db : STRING ; a_doc : STRING) : STRING
			-- Save updated document
		do
			Result := http.put ("/"+a_db,a_doc)
		end

	doc_create ( a_db : STRING; a_data : STRING)  : STRING
			-- Create a new document
		do
			Result := http.post ("/" +a_db,a_data)
		end

	doc_delete ( a_db : STRING; a_doc : STRING) : STRING
			-- Delete document
		do
		end

end
