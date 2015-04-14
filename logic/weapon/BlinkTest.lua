return {
	systems = {
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
