note
	description: "[
                   Shared factory class for creating HTTP_CLIENT objects. 
		 		 ]"

	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_HTTP_CLIENT

feature -- Access
	http : HTTP_CLIENT
		once
			create Result.make
		end
end
