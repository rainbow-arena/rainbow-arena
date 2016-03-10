--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")

local angle = require("util.angle")
--- ==== ---


--- Classes ---
local wep_Projectile = require("weapons.Projectile")
--- ==== ---


--- Class definition ---
local wep_EnergyPistol = Class{__includes = wep_Projectile}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_EnergyPistol:init(args)
	assert(util.table.check(args, {
		"cooldown"
	}, "wep_EnergyPistol"))

	self.cooldown = args.cooldown

	self.heat = 0

	return wep_Projectile.init(self, args)
end


---

function wep_EnergyPistol:fire_begin(world, wielder)
	if self.heat == 0 then
		self:fire_projectile(world, wielder)
		self.heat = self.cooldown
	end
end

function wep_EnergyPistol:firing(world, wielder, dt)

end

function wep_EnergyPistol:fire_end(world, wielder)

end

function wep_EnergyPistol:update(world, wielder, dt)
	self.heat = self.heat - dt
	if self.heat < 0 then
		self.heat = 0
	end
end
--- ==== ---


return wep_EnergyPistol
