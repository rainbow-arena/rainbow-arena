return function(max_heat)
	local weapon = {
		heat = 0,
		maxheat = maxheat or 1
	}

	-- TODO: Override base weapon functions, but allow extensions to
	-- override these while keeping what's defined here.
	-- Sounds like a job for classes.
	function weapon:fire_start(host, world, pos, dir)

	end

	function weapon:fire_update(host, world, dt, pos, dir)
		self.heat = self.heat + dt
	end

	function weapon:fire_end(host, world)

	end

	return weapon
end
