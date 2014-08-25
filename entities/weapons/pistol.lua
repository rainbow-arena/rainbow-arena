local bullet = require("entities.projectiles.bullet")
local ss_proj_weapon = require("entities.weapons.singleshot_projectile")

return function(cooldown, bullet_radius, bullet_mass, bullet_speed, bullet_damage)
	return ss_proj_weapon(cooldown, bullet_speed,
		bullet(bullet_radius, bullet_mass, bullet_damage))
end
