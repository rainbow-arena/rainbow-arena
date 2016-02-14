--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- System ---
local sys_Stare = tiny.processingSystem()
sys_Stare.filter = tiny.requireAll("DesiredAimAngle", "StareAt")
--- ==== ---


--- Constants ---
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Stare:process(e, dt)
	local world = self.world.world

	local target = e.StareAt
	e.DesiredAimAngle = math.atan2(
		target.Position.y - e.Position.y,
		target.Position.x - e.Position.x
	)
end
--- ==== ---

return Class(sys_Stare)
