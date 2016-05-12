--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")
local timer = require("lib.hump.timer")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- Classes ---
--- ==== ---


--- System ---
local sys_Reticule = Class(tiny.system())
--- ==== ---


--- Constants ---
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Reticule:init()

end

function sys_Reticule:update(dt)
	local world = self.world.world
end
--- ==== ---

return sys_Reticule
