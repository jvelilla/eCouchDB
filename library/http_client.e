class
	HTTP_CLIENT

create
	make,
	make_with_host_and_port

feature -- Initialization
	make
			-- Create an instance
			-- with defaul host and port
		do
			set_host("http://127.0.0.1")
			set_port(5984)
		end

	make_with_host_and_port ( a_host : STRING; a_port : INTEGER)
		do
			set_host(a_host)
			set_port(a_port)
		end

feature -- Access

	host : STRING
		-- 	default host http://127.0.0.1
	port : INTEGER
		-- default port 5984

feature -- Element Change

	set_host ( a_host : STRING)
			-- set host with `a_host'
		do
			host := a_host
		ensure
			host_defined : host = a_host
		end

	set_port ( a_port : INTEGER)
			-- set port with `a_port'
		do
			port := a_port
		ensure
			port_defined : port = a_port
		end

feature -- HTTP VERBS

	get ( a_uri : STRING) : STRING
		local
			l_result: INTEGER
			l_curl_string: CURL_STRING
			end_point : STRING
		do

			end_point := host + ":" + port.out + a_uri
			print ("%NCalling GET method :" + end_point +"%N" )
			if curl.is_dynamic_library_exists then
				create l_curl_string.make_empty

				curl.global_init

					-- Init the curl session
				curl_handle := curl_easy.init

					-- Specify URL to get
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url, end_point)

					-- Send all data to default Eiffel curl write function
				curl_easy.set_write_function (curl_handle)

					-- We pass our `l_curl_string''s object id to the callback function */
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, l_curl_string.object_id)

					-- Get it!
				l_result := curl_easy.perform (curl_handle)

					--  Cleanup curl stuff
				curl_easy.cleanup (curl_handle)

				Result := l_curl_string.as_string_8

					--You don't need to be aware of memory management issue since Eiffel will handle all of them for you.
				curl.global_cleanup

				if l_result /= 0 then
					print ("There was an error:" + l_result.out)
				end

			else
				io.error.put_string ("cURL library not found!")
				io.error.put_new_line
			end
		end

	put ( a_uri : STRING; a_data : STRING) : STRING
		local
			l_result: INTEGER
			end_point : STRING
			l_curl_string: CURL_STRING
			p: POINTER
			l_fupload: RAW_FILE
		do

			end_point := host + ":" + port.out + a_uri
			print ("%NCalling PUT method :" + end_point +"%N" )
			io.put_new_line

			if curl_easy.is_dynamic_library_exists then
				create l_curl_string.make_empty
				curl_handle := curl_easy.init

					-- First set the URL that is about to receive our POST. This URL can
					-- just as well be a https:// URL if that is what should receive the
					-- data.
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,end_point )

					-- Now specify the PUT data
				if a_data = Void then
					curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_put, end_point)
				else
					-- specify callback read function for upload data
							-- enable uploadig
--					p := curl.slist_append (p, "Content-Type: application/json")
--					curl_easy.setopt_slist (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpheader, p)
--					p := curl.slist_append (p,"Content-Length:"+a_data.count.out)
--					curl_easy.setopt_slist (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpheader, p)
					curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_verbose, 1)
					curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_upload, 1)
					curl_easy.set_curl_function (create {CUSTOM_READ_FUNCTION}.make_with_data(a_data))
					curl_easy.set_read_function (curl_handle)
					create l_fupload.make_open_read ("temp_json_data.json")
					curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_infilesize_large, l_fupload.count)
				end


					-- Send all data to default Eiffel curl write function
                curl_easy.set_write_function (curl_handle)

                    -- We pass our `l_curl_string''s object id to the callback function */
                curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, l_curl_string.object_id)

					-- Perform the request, `l_result' will get the return code
				l_result := curl_easy.perform (curl_handle)
				l_fupload.close
				l_fupload.wipe_out
				Result := l_curl_string.as_string_8
					-- Always cleanup
				curl_easy.cleanup (curl_handle)
			else
				io.error.put_string ("cURL library not found!")
				io.error.put_new_line
			end
	end


	post ( a_uri : STRING; a_data : STRING) : STRING
		local
			l_result: INTEGER
			end_point : STRING
			l_curl_string: CURL_STRING
		do

			end_point := host + ":" + port.out + a_uri
			print ("%NCalling POST method :" + end_point +"%N" )
			io.put_new_line

			if curl_easy.is_dynamic_library_exists then
				create l_curl_string.make_empty
				curl_handle := curl_easy.init

					-- First set the URL that is about to receive our POST. This URL can
					-- just as well be a https:// URL if that is what should receive the
					-- data.
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,end_point )

					-- Now specify the POST data
				if a_data = Void then
					curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_post, end_point)
				else
					curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfields, a_data)
				end


					-- Send all data to default Eiffel curl write function
                curl_easy.set_write_function (curl_handle)

                    -- We pass our `l_curl_string''s object id to the callback function */
                curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, l_curl_string.object_id)

					-- Perform the request, `l_result' will get the return code
				l_result := curl_easy.perform (curl_handle)

				if l_result = 0 then
					Result := l_curl_string.as_string_8
				else
					print ("Error")
				end
					-- Always cleanup
				curl_easy.cleanup (curl_handle)
			else
				io.error.put_string ("cURL library not found!")
				io.error.put_new_line
			end
	end

	delete ( a_uri : STRING) : STRING
		local
			l_result: INTEGER
			end_point : STRING
			l_curl_string: CURL_STRING
		do

			end_point := host + ":" + port.out + a_uri
			print ("%NCalling DELETE method :" + end_point +"%N" )
			io.put_new_line

			if curl_easy.is_dynamic_library_exists then
				create l_curl_string.make_empty
				curl_handle := curl_easy.init

					-- First set the URL that is about to receive our POST. This URL can
					-- just as well be a https:// URL if that is what should receive the
					-- data.
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url,end_point )

					-- Now specify the CUSTOM REQUEST as DELETE
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_customrequest, "DELETE")

					-- Send all data to default Eiffel curl write function
                curl_easy.set_write_function (curl_handle)

                    -- We pass our `l_curl_string''s object id to the callback function */
                curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, l_curl_string.object_id)

					-- Perform the request, `l_result' will get the return code
				l_result := curl_easy.perform (curl_handle)

				if l_result = 0 then
					Result := l_curl_string.as_string_8
				end
					-- Always cleanup
				curl_easy.cleanup (curl_handle)
			else
				io.error.put_string ("cURL library not found!")
				io.error.put_new_line
			end
	end

feature {NONE} -- Implementation

	curl: CURL_EXTERNALS is
			-- cURL externals
		once
			create Result
		end

	curl_easy: CURL_EASY_EXTERNALS is
			-- cURL easy externals
		once
			create Result
		end

	curl_string: CURL_STRING
			-- String used by Eiffel cURL library.

	curl_handle: POINTER;
			-- cURL handle				


end
