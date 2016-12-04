--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")
--- ==== ---


--- Module ---
local ret_DotReticle = {}
--- ==== ---


--- Class functions ---
function ret_DotReticle.draw(radius)
	radius = radius or 2

	-- Point.
	love.graphics.circle("fill", 0,0, radius)
end
--- ==== ---


return ret_DotReticle
