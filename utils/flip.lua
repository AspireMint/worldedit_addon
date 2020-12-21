local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

local FLIP = dofile(path.."/data/flip.lua")

local axis_util = dofile(path.."/utils/axis.lua")
local paramtype_util = dofile(path.."/utils/paramtype.lua")

local util = {}

util.flip = function(paramtype, axis, origin)
	local paramtype_index = paramtype_util.get_index(paramtype)
	local axis_index = type(axis)=='number' and axis or axis_util.get_axis_index(axis)
    return FLIP[paramtype_index][axis_index][origin]
end

util.flip_exist = function(paramtype)
	return pcall(util.flip, paramtype, 0, 0)
end

util.can_flip = function(node)
	local paramtype = paramtype_util.paramtype_or_special_case(node)
	return util.flip_exist(paramtype)
end

return util
