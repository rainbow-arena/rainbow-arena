local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local clamp = util.math.clamp

---

local shake_threshold_speed = 150

---

return {
	systems = {
		{
			name = "UpdateScreenshakeSource",
			requires = {"Position", "Screenshake"},
			update = function(source, world, dt)
				local ss = source.Screenshake
				assert( ss.intensity and ss.radius, "Screenshake component missing field(s)!")

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

				local camera_pos = vector.new(world.camera.x, world.camera.y)
				local dist_to_source = (source.Position - camera_pos):len()

				local final_intensity = clamp(0, intensity * (1 - (dist_to_source/ss.radius)), math.huge)

				world:add_screenshake(final_intensity)
			end
		}
	},

	events = {
		{ -- Screenshake for arena wall collisions.
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				world:spawnEntity{
					Position = pos:clone(),
					Lifetime = 0.1,
					Screenshake = {
						intensity = entity.Velocity:len() / shake_threshold_speed,
						radius = 100,
						duration = 0.1
					}
				}
			end
		},
		{ -- Screenshake for entity collision.
			event = "PhysicsCollision",
			func = function(world, ent1, ent2, mtv)
				local intensity = 1

				world:spawnEntity{
					Position = ent2.Position + mtv,
					Lifetime = 0.1,
					Screenshake = {
						intensity = (ent1.Velocity + ent2.Velocity):len() / shake_threshold_speed,
						radius = 100,
						duration = 0.1
					}
				}
			end
		}
	}
}
