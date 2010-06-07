note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_CDB_DATABASE

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			create cdb_database
		end

	on_clean
			-- <Precursor>
		do

		end

feature -- Test routines

	test_compact
			-- New test routine
		local
		 l_response : STRING
		do
			l_response := cdb_database.compaction("erest")
			assert ("Not null", l_response /= Void)
		end

	test_temp_view
		local
			l_response : STRING
		do
			-- temp_view require a valid json
			l_response := cdb_database.temp_view("erest",Void)
			assert ("Not null", l_response /= Void)
		end

	test_view_cleanup
		local
			l_response : STRING
		do
			l_response := cdb_database.view_cleanup ("erest")
			assert ("Not null", l_response /= Void)
		end

	test_update
		do
			create cdb_document
			print ("%NUpdate a document%N"+ cdb_document.update("erest/7f549eb903ee29c3e66db6b039009c0f","{%"key%":%"testupdate%"}"))
		end

		
feature -- Implementation
	cdb_database : CDB_DATABASE
	cdb_document : CDB_DOCUMENT
end


