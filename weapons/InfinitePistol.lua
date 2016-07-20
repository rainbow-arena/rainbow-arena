--- Require ---
local Class = require("lib.hump.class")
--- ==== ---


--- Classes ---
local wep_Projectile = require("weapons.Projectile")
local ret_DotReticle = require("weapons.components.reticles.DotReticle")
--- ==== ---


--- Class definition ---
local wep_InfinitePistol = Class{__includes = wep_Projectile}
--- ==== ---


--- Local functions ---
--- ==== ---


--- Class functions ---
function wep_InfinitePistol:init(args)
	self.reticle = ret_DotReticle()

	return wep_Projectile.init(self, args)
end

---

function wep_InfinitePistol:fire_begin(world, wielder)
	if self:can_fire() then
		self:fire_projectile(world, wielder)
	end
end

---

function wep_InfinitePistol:draw_reticle()
	self.reticle:draw()
end
--- ==== ---


return wep_InfinitePistol
