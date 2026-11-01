--Type docs: https://luals.github.io/wiki/annotations/#diagnostic

local state_machine = {}
local state_machine_mt = {
	__index = state_machine
}

---@alias transition {["from_state"] : string | hash, ["to_state"] : string | hash}
---@alias event fun(self : table, from_state : hash, to_state : hash, stats_table : table): boolean

-- OLD: 
-- ,["leave_state_event"] : event | nil, ["entered_state_event"] : event | nil 
--@param leave_state_event event | nil
--@param entered_state_event event | nil
-- END

-- -Create Transition for State Machine
-- -@param from_state string | hash
-- -@param to_state string | hash
-- -@return transition
-- function state_machine.create_state_transition(from_state, to_state)
-- 	return {
-- 		["from_state"] = from_state,
-- 		["to_state"] = to_state,
-- 		-- ["leave_state_event"] = leave_state_event, -- return false to cancel
-- 		-- ["entered_state_event"] = entered_state_event,
-- 	}
-- end

--- Create State Machine
---@class state_machine
---@field initial_state string | hash Inital State of the machine
---@field transitions {transition} The transitions of the machine
---@field stats table? Optional table to store properties
---@field get_current_state fun(self: state_machine): string | hash Get current state from machine
---@field set_state fun(self: state_machine, state: string | hash): string | hash | nil Set state based on the transitions
---@field match_state fun(self: state_machine, state: string | hash): boolean Match state to the current state
function state_machine.create(initial_state, transitions, stats)
	local self = {}
	setmetatable(self, state_machine_mt)
	self["stats"] = stats or {}
	self["current_state"] = initial_state
	self["transitions"] = transitions
	return self
end

---Set state for state machine
---@param self state_machine
---@param state string | hash
---@return string | hash | nil
function state_machine:set_state(state)
	local current_state = self:get_current_state()
	if state == current_state then
		return current_state
	end
	for index, value in ipairs(self["transitions"]) do
		local from_state = value["from_state"]
		local to_state = value["to_state"]
		if from_state == current_state and to_state == state then
			-- if value["leave_state_event"]  then
			-- 	if value["leave_state_event"](self, from_state, to_state, self.stats_table) == false then
			-- 		break
			-- 	end
			-- end
			self["current_state"] = state
			-- if 	value["entered_state_event"] then
			-- 	value["entered_state_event"](self, from_state, to_state, self.stats_table)
			-- end
			return self["current_state"]
		end
	end
	return nil
end

--- Get current state from state machine
---@param self state_machine
---@return string | hash
function state_machine:get_current_state()
	return self["current_state"]
end

---Match state with current state
---@param self state_machine
---@param state string | hash
---@return boolean
function state_machine:match_state(state)
	if self:get_current_state() == state then
		return true
	end
	return false
end

return state_machine