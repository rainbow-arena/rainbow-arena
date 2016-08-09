--- Require ---
local Class = require("lib.hump.class")

local util = require("lib.util")
--- ==== ---


--- Classes ---
local wep_Projectile = require("weapons.projectile.Projectile")
local ret_CircleReticle = require("weapons.components.reticles.CircleReticle")
--- ==== ---


--- Class definition ---
local wep_Burstgun = Class{__includes = wep_Projectile}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Burstgun:init(args)
	assert(util.table.check(args, {
		"shotPellets", -- How many projectiles are fired per shot.
		"shotBurstDelay" -- Time between burst shots.
	}, "wep_Burstgun"))

	self.shotPellets = args.shotPellets
	self.shotBurstDelay = args.shotBurstDelay

	return wep_Projectile.init(self, args)
end

---

function wep_Burstgun:fire_begin(world, wielder)
	if self:can_fire() then
		world.timer:script(function(wait)
			local proj
			for i = 1, self.shotPellets do
				proj = self:shot_fire_projectile(world, wielder)

				self:shot_add_delay()
				self:shot_add_heat()

				self:shot_play_sound(world, proj.Position:clone())
				self:shot_apply_screenshake(world, wielder.Position:clone())

				wait(self.shotBurstDelay)
			end
		end)
	end

	wep_Projectile.fire_begin(self, world, wielder)
end

---

function wep_Burstgun:draw_reticle()
	ret_CircleReticle.draw()
end
--- ==== ---


return wep_Burstgun
