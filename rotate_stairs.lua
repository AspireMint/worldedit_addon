local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

local paramtype_util = dofile(path.."/utils/paramtype.lua")
local rotate_util = dofile(path.."/utils/rotate.lua")

local get_new_rotation = function(paramtype, axis, origin, angle)
    local count = rotate_util.get_repetition(angle)
    local rotation = origin
    for i=1,count do
        rotation = rotate_util.rotate(paramtype, axis, rotation)
    end
    return rotation
end

local rotate_stairs = function(pos1, pos2, axis, angle)
	local min, max = worldedit.sort_pos(pos1, pos2)

	--make area stay loaded
	local manip = minetest.get_voxel_manip()
	manip:read_from_map(min, max)

	local pos = {}
	for z = min.z, max.z do
		for y = min.y, max.y do
			for x = min.x, max.x do
				pos.x = x; pos.y = y; pos.z = z
				local node = minetest.get_node(pos)
				if rotate_util.can_rotate(node) then
					local ndef = minetest.registered_nodes[node.name]
					local rotation = node.param2 % paramtype_util.get_mask(ndef.paramtype2)
					local new_rotation = get_new_rotation(ndef.paramtype2, axis, rotation, angle)
					local param2_supplement = node.param2 - rotation
					node.param2 = new_rotation + param2_supplement
					minetest.swap_node(pos, node)
				end
			end
		end
	end
end

return rotate_stairs
