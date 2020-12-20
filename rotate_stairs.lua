local PARAMTYPE = {
	facedir_group = 0,
	--[[+]] facedir = {index=0, mask=32},
	--[[+]] colorfacedir = {index=0, mask=32},
	wallmounted_group = 1,
	--[[+]] wallmounted = {index=1, mask=8},
	--[[+]] colorwallmounted = {index=1, mask=8}
}

local AXIS = {
    x = 0,
    y = 1,
    z = 2
}

-- DO NOT MODIFY
local ROTATION = {
	[PARAMTYPE.facedir_group] = {
		[AXIS.x] = {[0]=4, 5, 6, 7, 22, 23, 20, 21, 0, 1, 2, 3, 13, 14, 15, 12, 19, 16, 17, 18, 10, 11, 8, 9},
		[AXIS.y] = {[0]=1, 2, 3, 0, 13, 14, 15, 12, 17, 18, 19, 16, 9, 10, 11, 8, 5, 6, 7, 4, 23, 20, 21, 22},
		[AXIS.z] = {[0]=16, 17, 18, 19, 5, 6, 7, 4, 11, 8, 9, 10, 0, 1, 2, 3, 20, 21, 22, 23, 12, 13, 14, 15}
	},
	[PARAMTYPE.wallmounted_group] = {
		[AXIS.x] = {[0]=4, 5, 2, 3, 1, 0},
		[AXIS.y] = {[0]=0, 1, 5, 4, 2, 3},
		[AXIS.z] = {[0]=3, 2, 0, 1, 4, 5}
	}
}

local test_rotation = function()
    local errors = 0
    for pti,at in pairs(ROTATION) do
        for ai,rt in pairs(at) do
            for c=4,1,-1 do
                local found_rot = {}
                for ri=0,#rt do
                    local o = rt[ri]
                    
                    function rotate(p, c)
                        if c < 1 then
                            return p
                        end
                        c = c-1
                        return rotate(rt[p], c)
                    end
                    
                    local p2 = rotate(o, c)
                    if found_rot[p2] or c==4 and o ~= p2 then
                        errors = errors + 1
                        --[[
						print("WARNING: rot.table corrupted:",
                            "paramtype_index:"..pti,
                            "axis_index: "..ai,
                            "origin: "..o,
                            "param2:"..p2)
						]]
                    else
                        found_rot[p2] = true
                    end
                end
                for fri=0,#rt do
                    if not found_rot[fri] then
                        error("FATAL ERROR: corrupted rotation table, fix it ASAP")
                    end
                end
            end
        end
    end
    if errors == 0 then
        print("Everything looks ok to me. Shhhh if you see any problems.")
    else
        print("DO NOT TOUCH ROTATION TABLE!!! Errors: "..errors)
    end
end

local get_axis_index = function(axis)
	local axis_index = axis == "x" and 0 or axis == "y" and 1 or axis == "z" and 2 or -1
	if axis_index == -1 then
		error("Are you trying to open new dimension? Not in this universe!")
	end
	return axis_index
end

local get_repetition = function(angle)
    local get_positive_angle = function(angle)
        angle = angle % 360
        return angle % 90 == 0 and angle or 0--=do not rotate
    end
    return get_positive_angle(angle) / 90
end

local rotate = function(rotation_table, param2, axis)
    return rotation_table[axis][param2]
end

local get_new_rotation = function(rotation_table, origin, axis_index, angle)
    local count = get_repetition(angle)
    local rotation = origin
    for i=1,count do
        rotation = rotate(rotation_table, rotation, axis_index)
    end
    return rotation
end

local rotation_exist = function(paramtype)
	if not PARAMTYPE[paramtype] then
		return false
	end
	local paramtype_index = PARAMTYPE[paramtype].index
	return paramtype_index and ROTATION[paramtype_index]
end

local can_rotate = function(node)
	local ndef = minetest.registered_nodes[node.name]
	return ndef and rotation_exist(ndef.paramtype2)
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
				if can_rotate(node) then
					local ndef = minetest.registered_nodes[node.name]
					local paramtype_index = PARAMTYPE[ndef.paramtype2].index
					local rotation = node.param2 % PARAMTYPE[ndef.paramtype2].mask
					local axis_index = get_axis_index(axis)
					local new_rotation = get_new_rotation(ROTATION[paramtype_index], rotation, axis_index, angle)
					local param2_supplement = node.param2 - rotation
					node.param2 = new_rotation + param2_supplement
					minetest.swap_node(pos, node)
				end
			end
		end
	end
end

return rotate_stairs, test_rotation
