note
	description: "Summary description for {DOCUMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DOCUMENT

feature -- Initialization

feature -- Access
	id : STRING
	revision : STRING
	data : JSON_VALUE

feature -- Element Change

	set_id ( a_id : STRING)
		do
			id := a_id
		ensure
			id_assigned: id = a_id
		end

	set_revision ( a_revision : STRING)
		do
			revision := a_revision
		ensure
			revision_assigned : revision = a_revision
		end

	set_data ( a_data : JSON_VALUE)
		do
			data := a_data
		ensure
			data_assigned : data = a_data
		end
end
