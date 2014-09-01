local class = require("lib.hump.class")

---

local e_proj_base = class{}

---

-- Only affect the target if: the projectile and the target both
-- have a Team component and they are on different teams; or
-- one or both do not have a team component.
local function collision_eligible(projectile, target)
	if projectile.Team and target.Team then
		if projectile.Team == target.Team then
			return false
		end
	end

	return true
end

---

function e_proj_base:init()
	self.Projectile = true
	self.ArenaBounded = true

	self.CollisionExcludeComponents = {"Projectile"}
end

function e_proj_base:OnEntityCollision(world, target, mtv)
	if collision_eligible(self, target) then
		self:on_collision(world, target, mtv)
	end
end

function e_proj_base:on_collision(world, target, mtv)

end

---

return e_proj_base
