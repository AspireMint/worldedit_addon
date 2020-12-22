local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

worldedit._override = {}

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

do
	local addon = dofile(path.."/rotate_stairs.lua")
	local addon_flip = dofile(path.."/flip_stairs.lua")
	
	local old = worldedit.rotate
	worldedit.rotate = function(pos1, pos2, axis, angle)
		local volume, pos1, pos2 = old(pos1, pos2, axis, angle)
		addon(pos1, pos2, axis, angle)
		
		do--hotfix
			local angle = angle % 360
			local flip1,flip2
			if angle == 90 then
				if axis == 'x' then
					flip1 = 'y'
				elseif axis == 'y' then
					flip1 = 'z'
				elseif axis == 'z' then
					flip1 = 'x'
				end
			elseif angle == 180 then
				if axis == 'x' then
					flip1 = 'y'
					flip2 = 'z'
				elseif axis == 'y' then
					flip1 = 'x'
					flip2 = 'z'
				elseif axis == 'z' then
					flip1 = 'x'
					flip2 = 'y'
				end
			else
				if axis == 'x' then
					flip1 = 'z'
				elseif axis == 'y' then
					flip1 = 'x'
				elseif axis == 'z' then
					flip1 = 'y'
				end
			end
			addon_flip(pos1, pos2, flip1)
			if flip2 then
				addon_flip(pos1, pos2, flip2)
			end
		end
		
		return volume, pos1, pos2
	end
	worldedit._override.rotate = {
		old = old,
		new = worldedit.rotate
	}
end
