--- Require ---
local util = require("lib.util")
--- ==== ---


--- Module ---
local ret_DotReticle = {}
--- ==== ---


--- Functions ---
function ret_DotReticle.draw(args)
	-- Point.
	love.graphics.circle("fill", 0,0, 2)
end
--- ==== ---


return ret_DotReticle
