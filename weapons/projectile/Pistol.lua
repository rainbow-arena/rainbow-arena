--- Require ---
local Class = require("lib.hump.class")
--- ==== ---


--- Classes ---
local wep_Projectile = require("weapons.projectile.Projectile")
local ret_DotReticle = require("weapons.components.reticles.DotReticle")
--- ==== ---


--- Class definition ---
local wep_Pistol = Class{__includes = wep_Projectile}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_Pistol:init(args)
	return wep_Projectile.init(self, args)
end

---

function wep_Pistol:fire_begin(world, wielder)
	if self:can_fire() then
		self:shot_fire_projectile(world, wielder)
		self:shot_add_delay()
		self:shot_add_heat()
	end
end

---

function wep_Pistol:draw_reticle()
	ret_DotReticle.draw()
end
--- ==== ---


return wep_Pistol
