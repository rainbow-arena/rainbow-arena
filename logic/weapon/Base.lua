-- TODO: how to trigger custom reset of different ammo systems in a unified way?

return {
	systems = {
		{
			name = "ShotDelay",
			requires = {"ShotDelay"},
			update = function(weapon, host, world, dt)
				weapon._ShotTimer = weapon._ShotTimer or 0

				if not weapon.ShotReady then
					weapon._ShotTimer = weapon._ShotTimer - dt
					if weapon._ShotTimer < 0 then
						weapon._ShotTimer = weapon.ShotDelay
						weapon.ShotReady = true
					end
				end
			end
		},

		{
			name = "AmmoInfinite",
			requires = {"AmmoInfinite"},
			update = function(weapon, host, world, dt)
				weapon.AmmoReady = true
			end
		},
		{
			name = "AmmoHeat",
			requires = {"AmmoHeat"},
			update = function(weapon, host, world, dt)
				weapon._Heat = (weapon._Heat or 0) - dt
				if weapon._Heat < 0 then
					Weapon._Heat = 0

				end
			end
		}
	}
}
