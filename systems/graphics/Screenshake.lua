return {
	systems = {
		{
			name = "UpdateScreenshakeSource",
			requires = {"Position", "Screenshake"},
			update = function(source, world, dt, camera)
				local ss_intensity = source.Screenshake.intensity

				-- Initialise starting time if this is a timed source.
				if source.Lifetime and not source.Screenshake.lifetime then
					source.Screenshake.lifetime = source.Lifetime
				end

				-- Adjust timed source intensity (linearly interpolates through lifetime).
				if source.Lifetime and source.Screenshake.lifetime then
					ss_intensity = ss_intensity * (source.Lifetime / source.Screenshake.lifetime)
				end

				-- TODO: How to calculate resultant screenshake?
			end
		}
	}
}
