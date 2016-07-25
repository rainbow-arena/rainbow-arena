--- Require ---
local Class = require("lib.hump.class")
--- ==== ---


--- Classes ---
local wep_Projectile = require("weapons.projectile.Projectile")
local ret_DotReticle = require("weapons.components.reticles.DotReticle")
--- ==== ---


--- Class definition ---
local wep_Machinegun = Class{__includes = wep_Projectile}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Machinegun:init(args)
	args.shotSound = "audio/weapons/laser_shot.wav"

	return wep_Projectile.init(self, args)
end

---

function wep_Machinegun:firing(world, wielder, dt)
	if self:can_fire() then
		local proj = self:shot_fire_projectile(world, wielder)

		self:shot_add_delay()
		self:shot_add_heat()

		self:shot_play_sound(world, proj.Position:clone())
		self:shot_apply_screenshake(world, proj.Position:clone())
	end
end

---

function wep_Machinegun:draw_reticle()
	ret_DotReticle.draw()
end
--- ==== ---


return wep_Machinegun