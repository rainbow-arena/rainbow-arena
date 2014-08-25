local minigun = require("entities.weapons.minigun")

return function(start_cooldown, end_cooldown, spinup_time, bullet_radius, bullet_speed, bullet_damage, bullet_mass)
	local triple_minigun = minigun(start_cooldown, end_cooldown, spinup_time, bullet_radius, bullet_speed, bullet_damage, bullet_mass)

	triple_minigun.barrel = -1

	---

	function triple_minigun:fire(world, host, pos, dir)
		pos = pos + dir:perpendicular() * self.barrel * 10
		self:do_fire(world, host, pos, dir)

		self.barrel = self.barrel + 1
		if self.barrel > 1 then
			self.barrel = -1
		end
	end

	return triple_minigun
end

