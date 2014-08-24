local projectile = require("content.weapons.projectiles.bullet")

return function(cooldown, bullet_radius, bullet_mass, bullet_speed, bullet_damage)
	local bullet = projectile(bullet_radius, bullet_mass, bullet_damage)

	return require("content.weapons.singleshot_projectile")(
		cooldown, bullet_speed, bullet)
end
