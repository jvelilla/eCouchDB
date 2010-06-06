note
	description: "Summary description for {CUSTOM_READ_FUNCTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CUSTOM_READ_FUNCTION

inherit
	CURL_DEFAULT_FUNCTION
		redefine
			read_function
		end

create
	make,
	make_with_data
feature -- Redefine
	make_with_data ( a_data : STRING)
		local
			l_file : RAW_FILE
		do
			make
			create l_file.make_open_read_write ("temp_json_data.json")
			l_file.put_string (a_data)
			l_file.close

		end

	file_to_read: RAW_FILE
			-- File for sending data
		once
			create Result.make ("temp_json_data.json")
			Result.open_read
			Result.start
		ensure
			exists: Result.exists
		end

	read_function (a_data_pointer: POINTER; a_size, a_nmemb: INTEGER_32; a_object_id: POINTER): INTEGER_32
			-- <Precursor>
		local
			l_pointer: MANAGED_POINTER
			l_file: RAW_FILE
			l_max_transfer, l_byte_transfered: INTEGER
		do
			l_file := file_to_read
			if not l_file.after then
				l_max_transfer := a_size * a_nmemb
				if l_max_transfer > l_file.count - l_file.position then
					l_max_transfer := l_file.count - l_file.position
				end
				create l_pointer.share_from_pointer (a_data_pointer, l_max_transfer)

				from
				until
					l_file.after or l_byte_transfered >= l_max_transfer
				loop
					l_file.read_character
					l_pointer.put_character (l_file.last_character, l_byte_transfered)

					l_byte_transfered := l_byte_transfered + 1
				end

				Result := l_max_transfer
			else
				-- Result is 0 means stop file transfer
				Result := 0
			end
		end
--	make_with_data ( a_data : STRING)
--		do
--			make
--			data := a_data
--			index := 1
--		end

--	data : STRING

--	read_function (a_data_pointer: POINTER; a_size, a_nmemb: INTEGER_32; a_object_id: POINTER): INTEGER_32
--			-- <Precursor>
--		local
--			l_pointer: MANAGED_POINTER
--			l_data: STRING
--			l_max_transfer, l_byte_transfered: INTEGER
--			i : INTEGER
--		do
--			l_data := data

--			if l_data /= Void then
--				l_max_transfer := l_data.count

--				create l_pointer.share_from_pointer (a_data_pointer, l_max_transfer)

--				from
--					i := 1
--				until
--					i > l_data.count or
--					l_byte_transfered >= l_max_transfer
--				loop
--					l_pointer.put_character (l_data.at (i), l_byte_transfered)
--					l_byte_transfered := l_byte_transfered + 1
--					i := i + 1
--				end

--				Result := l_max_transfer
--			else
--				-- Result is 0 means stop file transfer
--				Result := 0
--			end
--		end
--	
--	index : INTEGER

end -- class CUSTOM_READ_FUNCTION
