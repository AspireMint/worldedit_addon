local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

worldedit._override = {}

do
	local addon = dofile(path.."/rotate_stairs.lua")
	local old = worldedit.rotate
	worldedit.rotate = function(pos1, pos2, axis, angle)
		local volume, pos1, pos2 = old(pos1, pos2, axis, angle)
		addon(pos1, pos2, axis, angle)
		return volume, pos1, pos2
	end
	worldedit._override.rotate = {
		old = old,
		new = worldedit.rotate
	}
end

do
	local addon = dofile(path.."/flip_stairs.lua")
	local old = worldedit.flip
	worldedit.flip = function(pos1, pos2, axis)
		local volume = old(pos1, pos2, axis)
		addon(pos1, pos2, axis)
		return volume
	end
	worldedit._override.flip = {
		old = old,
		new = worldedit.flip
	}
end
