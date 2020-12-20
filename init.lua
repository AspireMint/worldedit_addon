local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

worldedit._override = {}

do
	local rotate_stairs, test_rotation = dofile(path.."/rotate_stairs.lua")
	local old_rotate = worldedit.rotate
	worldedit.rotate = function(pos1, pos2, axis, angle)
		rotate_stairs(pos1, pos2, axis, angle)
		local count, pos1, pos2 = old_rotate(pos1, pos2, axis, angle)
		return count, pos1, pos2
	end
	worldedit._override.rotate = {
		old = old_rotate,
		new = worldedit.rotate
	}
	--test_rotation()
end
