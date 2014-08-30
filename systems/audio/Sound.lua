--local vector = require("lib.hump.vector")
local util = require("lib.self.util")

local clamp = util.math.clamp

---

local collision_sound = "audio/collision.wav"
local volume_threshold_speed = 500

---

return {
	systems = {
		{
			name = "UpdateSoundSource",
			requires = {"Position", "Sound"},
			update = function(source, world, dt)
				local ss = source.Sound
				assert(ss.source, "Sound component missing field(s)!")

				ss.source:setPosition(source.Position.x, source.Position.y, 0)

				local pitch = world.speed
				if ss.pitch then
					pitch = pitch * ss.pitch
				end
				ss.source:setPitch(pitch)

				ss.source:setVolume(ss.volume or 0.4)

				if not ss.playing then
					ss.source:play()
					ss.playing = true
				end

				if ss.source:isStopped() and ss.playing then
					source.Sound = nil
				end
			end
		}
	},

	events = {
		{ -- Sound for arena wall collisions.
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				world:spawnEntity{
					Position = pos:clone(),
					Lifetime = 0.4,
					Sound = {
						source = love.audio.newSource(collision_sound),
						volume = clamp(0, entity.Velocity:len() / volume_threshold_speed, 1)
					}
				}
			end
		},
		{ -- Sound for entity collision.
			event = "PhysicsCollision",
			func = function(world, ent1, ent2, mtv)
				world:spawnEntity{
					Position = ent2.Position + mtv,
					Lifetime = 0.4,
					Sound = {
						source = love.audio.newSource(collision_sound),
						volume = clamp(0, (ent1.Velocity + ent2.Velocity):len() / volume_threshold_speed, 1)
					}
				}
			end
		}
	}
}
