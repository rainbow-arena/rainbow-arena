local minigun = require("entities.weapons.minigun")

return function(projectile_prototype, projectile_speed, start_cooldown, end_cooldown, spinup_time)
	local triple_minigun = minigun(projectile_prototype, projectile_speed, start_cooldown, end_cooldown, spinup_time)

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

