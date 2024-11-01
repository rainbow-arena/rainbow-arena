--- Require ---
local Class = require("lib.hump.class")

local signal = require("lib.hump.signal")
local vector = require("lib.hump.vector")
local camera = require("lib.hump.camera")
local timer = require("lib.hump.timer")

local tiny = require("lib.tiny")

local SH = require("lib.spatialhash")
local util = require("lib.util")

local circle = require("util.circle")
local file = require("util.file")
--- ==== ---


--- Class definition ---
local World = {}
--- ==== ---


--- Local functions ---
local function apply_screenshake(xamp, yamp)
    yamp = yamp or xamp
    xamp, yamp = math.ceil(xamp), math.ceil(yamp)

    if xamp >= 1 and yamp >= 1 then
        love.graphics.translate(
            love.math.random(0, xamp*2) - xamp,
            love.math.random(0, yamp*2) - yamp
        )
    end
end
--- ==== ---


--- Class functions ---
-- Main --
function World:init(system_dir)
    self.ecs = tiny.world()
    self.ecs.world = self

    self.hash = SH.new()

    self.event = signal.new()
    self.timer = timer.new()

    self.camera = camera.new()
    self.CameraTarget = nil

    love.audio.setDopplerScale(1)
    self.SOUND_POSITION_SCALE = 256

    ---

    self.speed = 1

    ---

    self:load_systems(system_dir or "systems")
end

function World:update(dt)
    local corrected_dt = dt * self.speed

    -- Move camera.
    if self.CameraTarget then
        if self.CameraTarget.Position then
            local pos = self.CameraTarget.Position
            self.camera:lookAt(pos.x, pos.y)

            love.audio.setPosition(
                self.camera.x / self.SOUND_POSITION_SCALE,
                self.camera.y / self.SOUND_POSITION_SCALE,
                0
            )
        end

        if self.CameraTarget.Velocity then
            local vel = self.CameraTarget.Velocity

            love.audio.setVelocity(
                vel.x / self.SOUND_POSITION_SCALE,
                vel.y / self.SOUND_POSITION_SCALE,
                0
            )
        end
    end

    -- Update systems which draw in screen coordinates (eg. GUIs).
    self.ecs:update(corrected_dt, tiny.requireAll("NoCamera"))

    -- Update systems which draw in world coordinates.
    self.camera:attach()
    if self.camera.screenshake then
        apply_screenshake(self.camera.screenshake)
    end
    self.ecs:update(corrected_dt, tiny.rejectAll("NoCamera"))
    self.camera:detach()


    -- Update world timer.
    self.timer:update(corrected_dt)
end
-- ==== --


-- Entities --
function World:add_entity(e)
    e = self.ecs:addEntity(e)

    if e.Position and e.Radius then
        self.hash:insert_object(e, circle.aabb(
            e.Radius, e.Position.x,e.Position.y))
    end

    return e
end

function World:update_entity_components(e)
    return self.ecs:addEntity(e)
end

function World:move_entity(e, newpos_vec)
    assert(vector.isvector(newpos_vec), "Entity destination must be a vector!")

    local oldpos_vec = e.Position
    e.Position = newpos_vec

    if e.Radius then
        local old_x1,old_y1, old_x2,old_y2 = circle.aabb(e.Radius, oldpos_vec.x, oldpos_vec.y)
        local new_x1,new_y1, new_x2,new_y2 = circle.aabb(e.Radius, newpos_vec.x, newpos_vec.y)

        self.hash:move_object(e, old_x1,old_y1, old_x2,old_y2, new_x1,new_y1, new_x2,new_y2)
    end
end

function World:remove_entity(e)
    if e.Position and e.Radius then
        self.hash:remove_object(e, circle.aabb(
            e.Radius, e.Position.x, e.Position.y))
    end

    if e.Sound then
        e.Sound.source:stop()
    end

    self.ecs:removeEntity(e)
end
-- ==== --


-- Events --
function World:register_event(event, func)
    self.event:register(event, func)
end

function World:emit_event(event, ...)
    self.event:emit(event, self, ...)
end
-- ==== --


-- Systems --
function World:load_systems(system_dir)
    file.diriter(system_dir, function(dir, item)
        if item:find(".lua$") then
            local system = love.filesystem.load(dir .. "/" .. item)()
            self.ecs:addSystem(system())
        end
    end)
end
-- ==== --
--- ==== ---


return Class(World)
