local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

local PARAMTYPE = dofile(path.."/data/paramtype.lua")

local util = {}

util.get_index = function(paramtype)
	return PARAMTYPE[paramtype].index
end

util.get_mask = function(paramtype)
	return PARAMTYPE[paramtype].mask
end

util.paramtype_or_special_case = function(node)
	if string.match(node.name, 'stairs:slab') then
		return 'special_slab'
	end
	local ndef = minetest.registered_nodes[node.name]
	return ndef.paramtype2
end

return util
