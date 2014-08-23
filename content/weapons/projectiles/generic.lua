local weaputil = require("content.weapons.logic.weaputil")
local util = require("lib.self.util")

-- Only affect the target if: the projectile and the target both
-- have a Team component and they are on different teams; or
-- one or both do not have a team component.
--
-- TODO: Projectiles probably affect entities other than
-- just combatants.
local function collision_eligible(projectile, target)
	if projectile.Team and target.Team then
		if projectile.Team == target.Team then
			return false
		else
			return true
		end
	else
		return true
	end
end

---

return function()
	return {
		ArenaBounded = 0,

		OnProjectileCollision = {},
		OnEntityCollision = function(self, world, target, mtv)
			if self.OnProjectileCollision and collision_eligible(self, target) then
				for _, func in ipairs(self.OnProjectileCollision) do
					func(self, world, target, mtv)
				end
			end
		end
	}
end
