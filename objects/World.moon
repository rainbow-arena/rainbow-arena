signal = require "lib.hump.signal"
vector = require "lib.hump.vector"
camera = require "lib.hump.camera"
timer = require "lib.hump.timer"

tiny = require "lib.tiny"

SH = require "lib.spatialhash"
util = require "lib.util"

circle = require "util.circle"
file = require "util.file"

apply_screenshake = (xamp, yamp) ->
    yamp = yamp or xamp
    xamp, yamp = (math.ceil xamp), (math.ceil yamp)

    if xamp >= 1 and yamp >= 1
        love.graphics.translate (love.math.random 0, xamp * 2) - xamp,
            (love.math.random 0, yamp * 2) - yamp

class World
    new: (system_dir) =>
        @ecs = tiny.world!
        @ecs.world = self

        @hash = SH.new!

        @event = signal.new!
        @timer = timer.new!

        @camera = camera.new!
        @CameraTarget = nil

        love.audio.setDopplerScale 1
        @SOUND_POSITION_SCALE = 256

        @speed = 1

        @load_systems (system_dir or "systems")

        @FILTER_NO_CAMERA = tiny.requireAll "NoCamera"
        @FILTER_WITH_CAMERA = tiny.rejectAll "NoCamera"

    update: (dt) =>
        corrected_dt = dt * @speed

        -- Move camera.
        if @CameraTarget
            if @CameraTarget.Position
                pos = @CameraTarget.Position
                @camera\lookAt pos.x, pos.y

                love.audio.setPosition @camera.x / @SOUND_POSITION_SCALE,
                    @camera.y / @SOUND_POSITION_SCALE,
                    0

            if @CameraTarget.Velocity
                vel = @CameraTarget.Velocity

                love.audio.setVelocity vel.x / @SOUND_POSITION_SCALE,
                    vel.y / @SOUND_POSITION_SCALE,
                    0

        -- Update systems which draw in screen coordinates (eg. GUIs).
        @ecs\update corrected_dt, @FILTER_NO_CAMERA

        -- Update systems which draw in world coordinates.
        @camera\attach!
        if @camera.screenshake then apply_screenshake @camera.screenshake
        @ecs\update corrected_dt, @FILTER_WITH_CAMERA
        @camera\detach!

        -- Update world timer.
        @timer\update corrected_dt

    -- ## Entity management
    add_entity: (e) =>
        e = @ecs\addEntity(e)

        if e.Position and e.Radius
            @hash\insert_object e, circle.aabb e.Radius, e.Position.x, e.Position.y

        e

    update_entity_components: (e) => @ecs\addEntity e

    move_entity: (e, newpos_vec) =>
        assert (vector.isvector newpos_vec), "Entity destination must be a vector!"

        oldpos_vec = e.Position
        e.Position = newpos_vec

        if e.Radius
            old_x1,old_y1, old_x2,old_y2 = circle.aabb e.Radius, oldpos_vec.x, oldpos_vec.y
            new_x1,new_y1, new_x2,new_y2 = circle.aabb e.Radius, newpos_vec.x, newpos_vec.y

            @hash\move_object e, old_x1,old_y1, old_x2,old_y2, new_x1,new_y1, new_x2,new_y2

    remove_entity: (e) =>
        if e.Position and e.Radius
            @hash\remove_object e,
                (circle.aabb e.Radius, e.Position.x, e.Position.y)

        if e.Sound
            e.Sound.source\stop!

        @ecs\removeEntity e

    -- ## Events
    register_event: (event, func) => @event\register event, func
    emit_event: (event, ...) => @event\emit event, self, ...

    -- ## Systems
    load_systems: (system_dir) =>
        file.diriter system_dir, (dir, item) ->
            if item\find ".lua$"
                system = (love.filesystem.load dir .. "/" .. item)!
                @ecs\addSystem system!

return World
