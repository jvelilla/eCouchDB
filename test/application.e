class APPLICATION

create
	make

feature -- Initialization

	make
		do
			create cdb_server
			create cdb_document
			create cdb_database
			test_server
			test_database
		end

	test_server
		do
			print ("%N COUCHDB SERVER API %N")
			print ("%N/:%N"+cdb_server.info)
			print ("%N_all_dbs:%N"+cdb_server.databases)
			print ("%N_config:%N"+cdb_server.config)
			print ("%N_uuids:%N" +cdb_server.uuids)
			print ("%N_stats:%N" +cdb_server.stats)
			print ("%N_active_tasks:"+ cdb_server.active_task)
		 	-- TODO cdb_server.replicate
		end

	test_database
		local
			l_response : STRING
		do
			print ("%N COUCHDB DATABASE API %N")
			print("%NCreation%N"+cdb_database.db_create ("erest"))
			print("%NInfo%N"+cdb_database.info ("erest"))
			print("%NChange feed%N"+cdb_database.change_feed ("erest"))
			print ("%NCompaction:%N" +cdb_database.compaction("erest"))
			--
			--		print("%NTemporary Views%N"+cdb_database.temp_view ("erest", Void))
		end


feature -- Implementation

	cdb_server : CDB_SERVER
	cdb_document : CDB_DOCUMENT
	cdb_database : CDB_DATABASE

end
