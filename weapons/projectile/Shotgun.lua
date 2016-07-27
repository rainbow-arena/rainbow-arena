--- Require ---
local Class = require("lib.hump.class")

local util = require("lib.util")
--- ==== ---


--- Classes ---
local wep_Projectile = require("weapons.projectile.Projectile")
local ret_DotReticle = require("weapons.components.reticles.DotReticle")
--- ==== ---


--- Class definition ---
local wep_Shotgun = Class{__includes = wep_Projectile}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Shotgun:init(args)
	assert(util.table.check(args, {
		"shotPellets" -- How many projectiles are fired per shot.
	}, "wep_Shotgun"))

	self.shotPellets = args.shotPellets

	return wep_Projectile.init(self, args)
end

---

function wep_Shotgun:fire_begin(world, wielder)
	if self:can_fire() then
		local proj
		for i = 1, self.shotPellets do
			proj = self:shot_fire_projectile(world, wielder)
		end

		self:shot_add_delay()
		self:shot_add_heat()

		self:shot_play_sound(world, proj.Position:clone())
		self:shot_apply_screenshake(world, wielder.Position:clone())
	end

	wep_Projectile.fire_begin(self, world, wielder)
end

---

function wep_Shotgun:draw_reticle()
	ret_DotReticle.draw()
end
--- ==== ---


return wep_Shotgun
