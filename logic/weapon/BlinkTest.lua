--

return {
	systems = {
		{
			name = "AmmoInfinite",
			requires = {"AmmoInfinite"},
			update = function(weapon, host, world, dt)
				weapon.AmmoReady = true
			end
		},
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
			name = "FireBlink",
			requires = {"WeaponBlink"},
			update = function(weapon, host, world, dt)
				print(weapon._ShotTimer)
				if weapon.Firing and weapon.AmmoReady and weapon.ShotReady then
					host.ColorPulse = 1
					weapon.ShotReady = false
				end
			end
		}
	}
}
