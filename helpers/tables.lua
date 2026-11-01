-- More Table Functions (From more modern version of Lua)
-- Version: 1.0

local tables = {}

---Find value from table
---@param from_table table The Table where value is in
---@param find_value number | string Find this value
---@return integer | nil
function tables.find(from_table, find_value)
	for index, value in ipairs(from_table) do
		if value == find_value then
			return index
		end
	end
end

--- Move elements from a table to another table
---@param from_table table The Table where elements are moving from
---@param from_start_index integer Starting index of moving elements
---@param from_end_index integer Ending index of moving elements
---@param to_start_index integer Starting Index where elements are inserted in the destination table 
---@param to_table table The destination table where the elements are moved in
---@return table The destination table
function tables.move(from_table, from_start_index, from_end_index, to_start_index, to_table)
	local index_offset = 0 --start at one since it start to insert on the end of to_table
	for index = from_start_index, from_end_index, 1 do
		local value = from_table[index]
		table.insert(to_table, to_start_index + index_offset, value)
		index_offset = index_offset + 1
	end
	return to_table
end
