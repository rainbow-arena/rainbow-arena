return {
	systems = {
		{
			name = "FireBlink",
			requires = {"WeaponBlink"},
			update = function(weapon, host, world, dt)
				if weapon.Firing and weapon.AmmoReady and weapon.ShotReady then
					host.ColorPulse = 1
					weapon.ShotReady = false
				end
			end
		}
	}
}
