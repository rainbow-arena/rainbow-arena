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
	radius = radius or 16

	-- Point.
	love.graphics.circle("line", 0,0, radius)
end
--- ===
--- ==== ---


return ret_DotReticle
