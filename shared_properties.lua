-- Expose properties value from the scripts
-- Allows for outside scripts to use as long as they have the object url that match

local shared_properties = {}
---@type table<url, table<hash, {[string | hash]: any}>>
shared_properties["properties"] = {}

-- - Create a key that every script can use. Using url does not work, but hash does.
-- -@param object_url url The object that the user want to access
-- -@return hash
-- local function create_key(object_url)
-- 	return object_url
-- end

--- Get properties from object. If NOT found and create is true, create a table for the object
---@param key hash The access key
---@param create? boolean Create a table if it does not exist
---@return {}?
function shared_properties.get_object_properties(key, create)
	if not shared_properties["properties"][key] and create then
		shared_properties["properties"][key] = {}
	end
	return shared_properties["properties"][key]
end

--- Get a property from the object, return the value if found, nil if not
---@param key hash The access key
---@param property_id string | hash The property unique id to distinguish from the others 
---@return any?
function shared_properties.get_property(key, property_id)
	if shared_properties.get_object_properties(key, false) then
		return shared_properties["properties"][key][property_id]
	end
	return nil
end

--- Update a property, Create the table if can not find the table. 
--- Return value if updated, nil if not (Unlikely because the table is created)
---@param key hash The access key
---@param property_id string | hash The property unique id to distinguish from the others 
---@param value any
---@return any?
function shared_properties.update_property(key, property_id, value)
	if shared_properties.get_object_properties(key, true) then
		shared_properties["properties"][key][property_id] = value
		return value
	end
	print("property: ".. property_id.. "not found in "..key)
	return nil
end

--- Print out a property. 
--- Printing a property from an another script outside the script might return nil if it is "init" because it is not created.
---@param key hash The access key
---@param property_id string | hash The property unique id to distinguish from the others 
function shared_properties.print_property(key, property_id)
	if shared_properties["properties"][key] and shared_properties.get_property(key, property_id)then
		print("shared_properties[\""..property_id.. "\"]: ".. shared_properties.get_property(key, property_id))
	else
		print("shared_properties[\""..property_id.. "\"]: nil")
	end
end

--- Delete the properties table
---@param key hash The access key
function shared_properties.delete(key)
	shared_properties["properties"][key] = nil
end

return shared_properties