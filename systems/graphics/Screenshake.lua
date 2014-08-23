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
				assert( ss.intensity and ss.falloff, "Screenshake component missing field(s)!")

				-- Initialise starting time if this is a timed source.
				if not ss.timer and ss.duration then
					source.Screenshake.timer = ss.duration
				end

				-- Step screenshake timer.
				if ss.timer then
					ss.timer = ss.timer - dt
					if ss.timer <= 0 then
						source.Screenshake = nil
						return
					end
				end

				local intensity = ss.intensity
				if ss.timer and ss.duration then -- Adjust timed source intensity.
					intensity = intensity * (ss.timer / ss.duration)
				end

				local camera_pos = vector.new(camera.x, camera.y)
				local dist_to_source = (source.Position - camera_pos):len()

				-- (Falloff is pixels distance per one intensity level drop.)
				local final_intensity = clamp(0, intensity - (dist_to_source/ss.falloff), math.huge)

				camera.screenshake = camera.screenshake + final_intensity
			end
		}
	},

	events = {
		{ -- Screenshake for arena wall collisions.
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				local duration = 0.1
				local intensity = 5 -- TODO: Use mass and velocity to calculate intensity.

				world:spawnEntity{
					Position = pos:clone(),
					Lifetime = duration,
					Screenshake = {
						intensity = intensity,
						falloff = 200,
						duration = duration
					}
				}
			end
		},
		{ -- Screenshake for entity collision.
			event = "EntityCollision",
			func = function(world, ent1, ent2, mtv)
				local duration = 0.1
				local intensity = 5

				world:spawnEntity{
					Position = ent2.Position + mtv,
					Lifetime = duration,
					Screenshake = {
						intensity = intensity,
						falloff = 200,
						duration = duration
					}
				}
			end
		}
	}
}
