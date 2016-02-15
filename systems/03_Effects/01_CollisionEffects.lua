--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")

local entity = require("util.entity")
--- ==== ---


--- Classes ---
local ent_Sound = require("entities.Sound")
--- ==== ---


--- System ---
local sys_CollisionEffects = tiny.system()
--- ==== ---


--- Constants ---
local MAX_PULSE_SPEED = 800

---

local COLLISION_SOUND = "audio/collision.wav"
local MAX_VOLUME_SPEED = 1000
local COLLISION_SPEED_THRESHOLD = 1
local COLLISION_MAX_VOLUME = 0.5

local SOUND_SPAWN_DELAY = 0.05
--- ==== ---


--- Local functions ---
local function calculate_single_entity_pulse(e, velocity)
	return (velocity or e.Velocity:len()) / MAX_PULSE_SPEED
end

local function calculate_double_entity_pulse(e1, e2)
	local diff = e1.Position - e2.Position

	local v1 = e1.Velocity:projectOn(diff)
	local v2 = e2.Velocity:projectOn(diff)

	local res1 = calculate_single_entity_pulse(e1, v1:len())
	local res2 = calculate_single_entity_pulse(e2, v2:len())

	local res = (res1 + res2)/2

	return res, res
end
--- ==== ---


--- System functions ---
function sys_CollisionEffects:init()
	self.collision_sound_timer = 0
end

function sys_CollisionEffects:onAddToWorld(world)
	local world = world.world

	world:register_event("PhysicsCollision", function(world, e1, e2, mtv)
		-- Color pulse
		local v1, v2 = calculate_double_entity_pulse(e1, e2)
		if e1.pulse then e1:pulse(v1) end
		if e2.pulse then e2:pulse(v2) end

		-- Collision sound
		if
			self.collision_sound_timer == 0
			and (e1.Velocity - e2.Velocity):len() > COLLISION_SPEED_THRESHOLD
		then
			world:add_entity(ent_Sound{
				Position = entity.getmidpoint(e1, e2),
				soundpath = COLLISION_SOUND,
				volume = util.math.clamp(0,
					(e1.Velocity + e2.Velocity):len() / MAX_VOLUME_SPEED,
					COLLISION_MAX_VOLUME),
				removeOnFinish = true
			})

			self.collision_sound_timer = SOUND_SPAWN_DELAY
		end
	end)
end

function sys_CollisionEffects:update(dt)
	if self.collision_sound_timer > 0 then
		self.collision_sound_timer = self.collision_sound_timer - dt
		if self.collision_sound_timer <= 0 then
			self.collision_sound_timer = 0
		end
	end
end
--- ==== ---

return Class(sys_CollisionEffects)
