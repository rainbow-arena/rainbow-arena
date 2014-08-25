local bullet = require("entities.projectiles.bullet")
local proj_weapon = require("entities.weapons.base_projectile")

return function(cooldown, bullet_radius, bullet_speed, bullet_damage, bullet_mass)
	local pistol = proj_weapon(bullet(bullet_radius, bullet_mass, bullet_damage),
		bullet_speed, cooldown)

	pistol.type = "single"

	return pistol
end
