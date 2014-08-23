local projectile = require("content.weapons.logic.projectile")

return function(cooldown, bullet_radius, bullet_mass, bullet_speed, bullet_damage, bullet_lifetime)
	local bullet = projectile.bullet(bullet_radius, bullet_mass, bullet_lifetime, bullet_damage)

	return require("content.weapons.singleshot_projectile")(
		0.1, bullet_speed, bullet)
end
