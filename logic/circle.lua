local circle = {}

local vector = require("lib.hump.vector")

local abs = math.abs

function circle.colliding(pos1,r1, pos2,r2)
	-- Circle one -> Circle two
	local distance_vector = pos2 - pos1
	local distance = distance_vector:len()

	if distance < (r1 + r2) then
		-- The circles are colliding.
		local mtv_len = distance - r1 - r2
		local mtv = mtv_len * distance_vector:normalized()

		return true, mtv
	end

	return false
end

return circle
