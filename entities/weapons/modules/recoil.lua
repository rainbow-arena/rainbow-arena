local function calculate_recoil_velocity(projectile_mass, projectile_velocity,
	firer_mass, firer_velocity)

	return firer_velocity - ((projectile_mass * projectile_velocity) / firer_mass)
end

---

return {
	apply = function(self, host, projectile)
		host.Velocity = calculate_recoil_velocity(
			projectile.Mass, projectile.Velocity,
			host.Mass, host.Velocity)
	end
}
