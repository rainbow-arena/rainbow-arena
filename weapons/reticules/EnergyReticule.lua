--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")
--- ==== ---


--- Classes ---
--- ==== ---


--- System ---
local ret_EnergyReticule = Class{}
--- ==== ---


--- Constants ---
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function ret_EnergyReticule:draw(self, level)
	-- Point.
	love.graphics.circle("fill", 0,0, 2)

	-- Bar outline
	--love.graphics.arc("line")
end
--- ==== ---

return ret_EnergyReticule
