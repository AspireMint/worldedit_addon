local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

local _, PARAMTYPE_GROUP = dofile(path.."/data/paramtype.lua")
local AXIS = dofile(path.."/data/axis.lua")

local FLIP = {
	[PARAMTYPE_GROUP.facedir] = {
		[AXIS.x] = {[0]=10, 13, 4, 19, 2, 14, 22, 18, 20, 12, 0, 16, 9, 1, 5, 23, 11, 21, 7, 3, 8, 17, 6, 15},
		[AXIS.y] = {[0]=8, 17, 6, 15, 22, 18, 2, 14, 0, 16, 20, 12, 11, 21, 7, 3, 9, 1, 5, 23, 10, 13, 4, 19},
		[AXIS.z] = {[0]=4, 19, 10, 13, 0, 16, 20, 12, 22, 18, 2, 14, 7, 3, 11, 21, 5, 23, 9, 1, 6, 15, 8, 17}
	},
	[PARAMTYPE_GROUP.wallmounted] = {
		[AXIS.x] = {[0]=0, 1, 3, 2, 4, 5},
		[AXIS.y] = {[0]=1, 0, 2, 3, 4, 5},
		[AXIS.z] = {[0]=0, 1, 2, 3, 5, 4}
	},
	[PARAMTYPE_GROUP.special] = {
		[AXIS.x] = {[0]=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16, 19, 18, 17, 12, 15, 14, 13, 20, 21, 22, 23},
		[AXIS.y] = {[0]=20, 23, 22, 21, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 0, 3, 2, 1},
		[AXIS.z] = {[0]=0, 1, 2, 3, 8, 9, 10, 11, 4, 5, 6, 7, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23}
	}
}

return FLIP
