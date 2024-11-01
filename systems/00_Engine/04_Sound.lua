--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local tiny = require("lib.tiny")

local util = require("lib.util")
--- ==== ---


--- System ---
local sys_Sound = Class(tiny.processingSystem())
sys_Sound.filter = tiny.requireAll("Position", "Sound")
--- ==== ---


--- Local functions ---
local function draw_entity_debug_info(e)
    local str_t = {}

    ---

    --str_t[#str_t + 1] = (""):format()

    if e.Name then
        str_t[#str_t + 1] = ("Name: %s"):format(e.Name)
    end

    str_t[#str_t + 1] = ("Position: (%.2f, %.2f)"):format(e.Position.x, e.Position.y)

    if e.Sound then
        str_t[#str_t + 1] = ("Sound progress: %.2f"):format(e.Sound.source:tell() / e.Sound.source:getDuration())
    end

    ---

    local str = table.concat(str_t, "\n")

    local text_w = love.graphics.getFont():getWidth(str)

    local x = e.Position.x - text_w/2
    local y = e.Position.y + 10

    love.graphics.setColor(255, 255, 255)
    love.graphics.print(str, math.floor(x), math.floor(y))
end
--- ==== ---


--- System functions ---
function sys_Sound:process(e, dt)
    local world = self.world.world

    ---

    local sound = e.Sound
    assert(sound.source, "Sound component missing source field!")

    ---

    sound.source:setPosition(
        e.Position.x / world.SOUND_POSITION_SCALE,
        e.Position.y / world.SOUND_POSITION_SCALE, 0)

    if e.Velocity then
        sound.source:setVelocity(
            e.Velocity.x / world.SOUND_POSITION_SCALE,
            e.Velocity.y / world.SOUND_POSITION_SCALE, 0)
    end

    sound.source:setVolume(sound.volume)

    -- If source has finished playing and isn't a looping source, remove the entity.
    if not sound.source:isLooping() and sound.source:isStopped() and sound.played then
        if sound.removeOnFinish then
            world:remove_entity(e)
            return
        end
    end

    ---

    -- If source hasn't been started, start it.
    if not sound.played then
        sound.source:play()
        sound.played = true
    end

    if world.speed == 0 then
        -- Pause source.
        sound.source:pause()
    else
        if sound.source:isPaused() then
            -- Resume source.
            sound.source:resume()
        end
        sound.source:setPitch(sound.pitch * world.speed)
    end

    ---

    if world.DEBUG then
        draw_entity_debug_info(e)
    end
end
--- ==== ---

return sys_Sound
