local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local clamp = util.math.clamp
local floor = math.floor

return {
	systems = {
		{
			name = "UpdateScreenshakeSource",
			requires = {"Position", "Screenshake"},
			update = function(source, world, dt, camera)
				local ss = source.Screenshake
				assert( ss.intensity and ss.falloff, "Invalid screenshake entity" .. (source.Name and (": " .. source.Name)) )

				-- Initialise starting time if this is a timed source.
				if source.Lifetime and not ss.lifetime then
					source.Screenshake.lifetime = source.Lifetime
				end

				local intensity = ss.intensity
				-- Adjust timed source intensity (linearly interpolates through lifetime).
				if source.Lifetime and ss.lifetime then
					intensity = intensity * (source.Lifetime / ss.lifetime)
				end

				-- TODO: Final screenshake intensity should take into account
				-- how far away the source is and its intensity.
				local camera_pos = vector.new(camera.x, camera.y)
				local dist_to_source = (source.Position - camera_pos):len()

				-- (Falloff is pixels distance per one intensity level drop.)
				local final_intensity = clamp(0, intensity - dist_to_source/ss.falloff, math.huge)

				camera.screenshake = camera.screenshake + final_intensity
			end
		}
	}
}
