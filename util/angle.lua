--- Require ---
local vector = require("lib.hump.vector")
--- ==== ---


--- Module ---
local angle = {}
--- ==== ---


--- ==== ---
function angle.angle_to_vector(a)
    return vector.new(math.cos(a), math.sin(a))
end
--- ==== ---


return angle
