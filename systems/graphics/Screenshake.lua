local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local clamp = util.math.clamp

return {
	systems = {
		{
			name = "UpdateScreenshakeSource",
			requires = {"Position", "Screenshake"},
			update = function(source, world, dt, camera)
				local ss = source.Screenshake
				assert( ss.intensity and ss.falloff, "Screenshake component missing field(s)" .. (source.Name and (" in entity: " .. source.Name)) )

				-- Initialise starting time if this is a timed source.
				if source.Lifetime and not ss.lifetime then
					source.Screenshake.lifetime = source.Lifetime
				end

				local intensity = ss.intensity
				if source.Lifetime and ss.lifetime then -- Adjust timed source intensity.
					intensity = intensity * (source.Lifetime / ss.lifetime)
				end

				local camera_pos = vector.new(camera.x, camera.y)
				local dist_to_source = (source.Position - camera_pos):len()

				-- (Falloff is pixels distance per one intensity level drop.)
				local final_intensity = clamp(0, intensity - (dist_to_source/ss.falloff), math.huge)

				camera.screenshake = camera.screenshake + final_intensity
			end
		}
	}
}
