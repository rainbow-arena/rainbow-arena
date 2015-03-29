local timer = require("lib.hump.timer")
local util = require("lib.self.util")

---

local math_clamp = util.math.clamp

---

local COLLISION_SOUND = "audio/collision.wav"
local MAX_VOLUME_SPEED = 1600
local COLLISION_MAX_VOLUME = 0.5

local can_spawn_col_sound = true
local SOUND_SPAWN_DELAY = 0.05

---

return {
	systems = {
		{
			name = "UpdateSoundSource",
			requires = {"Position", "Sound"},
			update = function(source, world, dt)
				local ss = source.Sound
				assert(ss.source, "Sound component missing source field!")

				ss.source:setPosition(source.Position.x/SOUND_POSITION_SCALE, source.Position.y/SOUND_POSITION_SCALE, 0)

				-- If source hasn't been started, start it.
				if not ss.played then
					ss.source:play()
					ss.played = true
				end

				if world.speed == 0 then
					-- Pause source.
					ss.source:pause()
				else
					if ss.source:isPaused() then
						-- Resume source.
						ss.source:resume()
					end
					ss.source:setPitch((ss.pitch or 1) * world.speed)
				end

				if ss.volume then
					ss.source:setVolume(ss.volume)
				end

				-- If source has finished playing, remove the component.
				if ss.source:isStopped() and ss.played and not ss.paused then
					source.Sound = nil
				end
			end
		}
	},

	events = {
		{ -- Sound for arena wall collisions.
			event = "ArenaCollision",
			func = function(world, entity, pos, side)
				local source = love.audio.newSource(COLLISION_SOUND)

				world:spawn_entity{
					Position = pos,
					Lifetime = 0.3,
					Sound = {
						source = source,
						volume = math_clamp(0, entity.Velocity:len() / MAX_VOLUME_SPEED, COLLISION_MAX_VOLUME)
					}
				}
			end
		},
		{ -- Sound for entity collision.
			event = "PhysicsCollision",
			func = function(world, ent1, ent2, mtv)
				if can_spawn_col_sound then
					local source = love.audio.newSource(COLLISION_SOUND)
					local pos = ent2.Position + mtv

					world:spawn_entity{
						Position = pos,
						Lifetime = 0.3,

						Sound = {
							source = source,
							volume = math_clamp(0, (ent1.Velocity + ent2.Velocity):len() / MAX_VOLUME_SPEED, COLLISION_MAX_VOLUME)
						}
					}

					can_spawn_col_sound = false
					world.timer:add(SOUND_SPAWN_DELAY, function()
						can_spawn_col_sound = true
					end)
				end
			end
		}
	}
}
