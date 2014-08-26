local bullet = require("entities.projectiles.bullet")
local proj_weapon = require("entities.weapons.base_projectile")

return function(projectile_prototype, cooldown)
	local pistol = proj_weapon(projectile_prototype, bullet_speed, cooldown)

	pistol.type = "single"

	return pistol
end
