--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")
--- ==== ---


--- System ---
local sys_Weapon = Class(tiny.processingSystem())
sys_Weapon.filter = tiny.requireAll("Weapon", "AimAngle") -- TODO: Weapons which aren't aimed?
--- ==== ---


--- Local functions ---
--- ==== ---


--- System functions ---
function sys_Weapon:process(e, dt)
	local world = self.world.world

	local weapon = e.Weapon

	if e.Firing then
		if not e.is_firing then
			e.is_firing = true
			weapon:fire_begin(world, e)
		else
			weapon:firing(world, e, dt)
		end
	else -- if not e.Firing then
		if e.is_firing then
			e.is_firing = false
			weapon:fire_end(world, e)
		end
	end

	weapon:update(world, e, dt)
end
--- ==== ---

return sys_Weapon
