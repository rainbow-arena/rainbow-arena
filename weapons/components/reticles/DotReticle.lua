--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")
--- ==== ---


--- Classes ---
--- ==== ---


--- System ---
local ret_EnergyReticle = Class{}
--- ==== ---


--- Constants ---
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function ret_EnergyReticle:draw()
	-- Point.
	love.graphics.circle("fill", 0,0, 2)
end
--- ==== ---

return ret_EnergyReticle
