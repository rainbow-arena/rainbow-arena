--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")
--- ==== ---


--- Module ---
local ret_DotReticle = {}
--- ==== ---


--- Class functions ---
function ret_DotReticle.draw(args)
	-- Point.
	love.graphics.circle("fill", 0,0, 2)
end
--- ==== ---


return ret_DotReticle
