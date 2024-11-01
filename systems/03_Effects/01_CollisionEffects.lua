--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")
local timer = require("lib.hump.timer")

local tiny = require("lib.tiny")

local util = require("lib.util")

local entity = require("util.entity")
--- ==== ---


--- Classes ---
local ent_Sound = require("objects.entities.Sound")
local ent_Screenshake = require("objects.entities.Screenshake")
--- ==== ---


--- System ---
local sys_CollisionEffects = Class(tiny.system())
--- ==== ---


--- Constants ---
local EFFECT_SPAWN_DELAY = 0.05

---

local MAX_PULSE_SPEED = 800

---

local COLLISION_SOUND = "assets/audio/collision.wav"
local MAX_VOLUME_SPEED = 1000
local COLLISION_SPEED_THRESHOLD = 1
local COLLISION_MAX_VOLUME = 0.5

---

local SHAKE_STEP_SPEED = 300
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
    self.timer = timer.new()

    self.collision_sound_ok = true
    self.collision_shake_ok = true
end

function sys_CollisionEffects:onAddToWorld(world)
    local world = world.world

    world:register_event("PostPhysicsCollision", function(world, e1, e2, mtv)
        -- Color pulse
        local v1, v2 = calculate_double_entity_pulse(e1, e2)
        if e1.pulse then e1:pulse(v1) end
        if e2.pulse then e2:pulse(v2) end

        -- Sound and screenshake
        if (e1.Velocity - e2.Velocity):len() > COLLISION_SPEED_THRESHOLD then
            if self.collision_sound_ok then
                world:add_entity(ent_Sound{
                    Position = entity.getmidpoint(e1, e2),
                    soundpath = COLLISION_SOUND,
                    volume = util.math.clamp(0,
                        (e1.Velocity + e2.Velocity):len() / MAX_VOLUME_SPEED,
                        COLLISION_MAX_VOLUME),
                    removeOnFinish = true
                })

                self.collision_sound_ok = false
                self.timer:after(EFFECT_SPAWN_DELAY, function() self.collision_sound_ok = true end)
            end

            if self.collision_shake_ok then
                world:add_entity(ent_Screenshake{
                    Position = entity.getmidpoint(e1, e2),
                    intensity = (e1.Velocity + e2.Velocity):len() / SHAKE_STEP_SPEED,
                    radius = 100,
                    duration = 0.1,
                    removeOnFinish = true
                })

                self.collision_shake_ok = false
                self.timer:after(EFFECT_SPAWN_DELAY, function() self.collision_shake_ok = true end)
            end
        end
    end)
end

function sys_CollisionEffects:update(dt)
    self.timer:update(dt)
end
--- ==== ---

return sys_CollisionEffects
