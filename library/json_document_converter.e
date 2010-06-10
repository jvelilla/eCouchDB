note
	description: "Summary description for {JSON_DOCUMENT_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_DOCUMENT_CONVERTER


inherit
    JSON_CONVERTER

create
    make

feature {NONE} -- Initialization

    make is
        local
            ucs: UC_STRING
        do
            create ucs.make_from_string ("")
            create object
        end

feature -- Access

    value: JSON_OBJECT

    object: DOCUMENT

feature -- Conversion

    from_json (j: like value): like object is
        local
            ucs: UC_STRING
            jkeys : ARRAY[JSON_STRING]
            i:INTEGER
            parser : JSON_PARSER
            a_data : STRING
        do
            jkeys := j.current_keys
            create Result
            from
            	i := 1
            until
            	i > jkeys.count
            loop
            	if (jkeys.item (i).is_equal (id_key)) then
            		 ucs ?= json.object (j.item (id_key), Void)
         			 check ucs /= Void end
         			 Result.set_id (ucs)
         		elseif (jkeys.item (i).is_equal (revision_key))  then
         					ucs ?= json.object (j.item (revision_key), Void)
         					check ucs /= Void end
         					Result.set_revision (ucs)
         		else
         			ucs ?= json.object (j.item (jkeys.item (i)), Void)
         			a_data :="{"+ jkeys.item (i).representation + ":%""+ ucs.out+"%"}"
         			create parser.make_parser (a_data)
					Result.set_data (parser.parse)
         		end
         		i := i + 1
            end
        end

    to_json (o: like object): like value is
        local
        	jo : JSON_OBJECT
        	jkeys : ARRAY[JSON_STRING]
        	i : INTEGER
        	a_value : JSON_STRING
        do
            create Result.make
            Result.put (json.value (o.id), id_key)
            Result.put (json.value (o.revision),revision_key)
            jo ?= o.data
            if jo /= Void then
            	jkeys  := jo.current_keys
            	from
            		i := 1
            	until
            		i > jkeys.count
            	loop
            		a_value ?= jo.item (jkeys.at (i))
					Result.put (a_value,jkeys.at (i))
					i := i +1
            	end
            end
        end

feature    {NONE} -- Implementation

    id_key: JSON_STRING is
        once
            create Result.make_json ("_id")
        end

	revision_key: JSON_STRING is
        once
            create Result.make_json ("_rev")
        end

end -- class JSON_DOCUMENT_CONVERTER
