local _hashed = {}
_G.hashed = {};
local mt = {
	__index  = function(t, k)
		if _hashed[k] == nil then
			_hashed[k] = hash(k)
		end 
		return _hashed[k]
	end
}
setmetatable(_G.hashed, mt)
