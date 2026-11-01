-- Expose properties value from the scripts
-- Allows for outside scripts to use as long as they have the object url that match

local object_properties = {}
---@type table<url, table<hash, {[string]: any}>>
object_properties["stats"] = {}

--- Create a key that every script can use. Using url does not work, but hash does.
---@param object_url url
---@return hash
local function create_key(object_url)
	return object_url.path
end

--- Get stats from object or Create a list for the key object_url in object_properties["stats"]
---@param object_url url
---@param create? boolean
---@return {} | nil
function object_properties.get_object_stats(object_url, create)
	local key = create_key(object_url)
	if object_properties["stats"][key] then
		return object_properties["stats"][key]
	elseif create == true then
		object_properties["stats"][key] = {}
		return object_properties["stats"][key]
	end
	return nil
end

--- Print out a property. Print a property outside the script might return nil if it is "init" because it is not created.
---@param object_url url
---@param property string
function object_properties.print_property(object_url, property)
	local key = create_key(object_url)
	if object_properties["stats"][key]  and object_properties.get_property(object_url, property)then
		print("object_properties[\""..property.. "\"]: ".. object_properties.get_property(object_url, property))
	else
		print("object_properties[\""..property.. "\"]: nil")
	end
end

--- Update a property 
---@param object_url url
---@param property string
---@param value any
---@return any
function object_properties.update_property(object_url, property, value)
	local key = create_key(object_url)
	if object_properties.get_object_stats(object_url, true) then
		object_properties["stats"][key][property] = value
		return value
	end
	print("property: ".. property.. "not found in "..key)
	return value
end

--- Get a property 
---@param object_url url
---@param property string
---@return any | nil
function object_properties.get_property(object_url, property)
	local key = create_key(object_url)
	if object_properties.get_object_stats(object_url, false) and object_properties["stats"][key][property] then
		return object_properties["stats"][key][property]
	end
	return nil
end

--- Delete the stat properties
---@param object_url url
function object_properties.delete(object_url)
	local key = create_key(object_url)
	object_properties["stats"][key] = nil
	
end

return object_properties