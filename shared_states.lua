-- Expose state_machine from the scripts
-- Allows for outside scripts to use as long as they have the object url that match
local state_machine = require("shared_stats.state_machine")

local shared_states = {}
---@type table<url, table<hash, {[string | hash]: state_machine}>>
shared_states["state_machines"] = {}

-- - Create a key that every script can use. Using url does not work, but hash does.
-- -@param object_url url The object that the user want to access
-- -@return hash
-- local function create_key(object_url)
-- 	return object_url
-- end

--- Get Machines from object. If NOT found and create is true, create a table for the object
---@param key hash The access key
---@param create? boolean Create a table if it does not exist
---@return {}?
function shared_states.get_object_machines(key, create)
	if not shared_states["state_machines"][key] and create then
		shared_states["state_machines"][key] = {}
	end
	return shared_states["state_machines"][key]
end

--- Get a machine from the object, return the machine if found, nil if not
---@param key hash The access key
---@param machine_id string | hash The machine unique id to distinguish from the others 
---@return state_machine?
function shared_states.get_machine(key, machine_id)
	if shared_states.get_object_machines(key, false) and shared_states["state_machines"][key][machine_id]then
		return shared_states["state_machines"][key][machine_id]
	end
	return nil
end

--- Create a state machine and added to the object table. Create a table if not found. Return the state machine
---@param key hash The access key
---@param machine_id string | hash The machine unique id to distinguish from the others 
---@param initial_state string | hash The machine inital state
---@param transitions {transition} The transitions
---@param stats table? Optional table for stats
---@return state_machine
function shared_states.create_state_machine(key, machine_id, initial_state, transitions, stats)
	if shared_states.get_object_machines(key, true) and not shared_states.get_machine(key, machine_id) then
		shared_states["state_machines"][key][machine_id] = state_machine.create(initial_state, transitions, stats)
	end
	return shared_states["state_machines"][key][machine_id]
end

-- ---Create Transition for State Machine
-- ---@param from_state string | hash
-- ---@param to_state string | hash
-- ---@return transition
-- function shared_states.create_transition(from_state, to_state)
-- 	return {
-- 		["from_state"] = from_state,
-- 		["to_state"] = to_state,
-- 	}
-- end

--- Refers to the state_machine.create_transition instead
--- since they are the same function-wise
-- shared_states.create_transition = state_machine.create_transition

---Create Transition for State Machine
---@param from_state string | hash From state 
---@param to_state string | hash To the state
---@return transition
function shared_states.create_state_transition(from_state, to_state)
	return {
		["from_state"] = from_state,
		["to_state"] = to_state,
		-- ["leave_state_event"] = leave_state_event, -- return false to cancel
		-- ["entered_state_event"] = entered_state_event,
	}
end

--- Print out a machine. 
--- Print a machine outside the script might return nil if it is "init" because it is not created.
---@param key hash The access key
---@param machine_id string | hash The machine unique id
function shared_states.print_machine(key, machine_id)
	if shared_states["state_machines"][key] and shared_states.get_machine(key, machine_id)then
		print("shared_states[\""..machine_id.. "\"]: ".. shared_states.get_machine(key, machine_id))
	else
		print("shared_states[\""..machine_id.. "\"]: nil")
	end
end

--- Delete the table
---@param key hash The key that the user want to access
function shared_states.delete(key)
	shared_states["state_machines"][key] = nil
end

return shared_states