function serialize(t)
	assert(type(t) == "table", "Can only serialize tables.")
	if not t then return nil end
	local s = "{"
	for k, v in pairs(t) do
		if type(k) == "string" then k = k
		elseif type(k) == "number" then k = "["..k.."]"
		else error("Attempted to serialize a table with an invalid key: "..tostring(k))
		end
		if type(v) == "string" then v = "\""..v.."\""			
		elseif type(v) == "table" then v = serialize(v)
		elseif type(v) == "boolean" then v = v and "true" or "false"
		elseif type(v) == "userdata" then v = ("%q"):format(tostring(v))
		end
		s = s..k.."="..v..","
	end
	return s.."}"
end