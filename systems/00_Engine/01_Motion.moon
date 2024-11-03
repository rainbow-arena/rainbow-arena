vector = require "lib.hump.vector"
tiny = require "lib.tiny"
util = require "lib.util"

class sys_Motion
    new: =>
        @filter = tiny.requireAll("Position", "Velocity", "Forces", "Mass")
        tiny.processingSystem self
        print @update

    process: (e, dt) =>
        world = @world.world

        -- Add drag force.
        if e.Drag
            e.Forces[#e.Forces + 1] = {
                vector: e.Drag * -e.Velocity
            }

        -- Aggregate all forces applied this frame.
        force_sum = vector.new!

        -- Sum the forces and remove as needed.
        i = 1
        while i <= #e.Forces
            force = e.Forces[i]
            remove_force = false

            if not force.duration
                -- Apply force for one frame only.
                force_sum = force_sum + force.vector * dt
                remove_force = true
            elseif force.duration < dt
                -- Force has less than dt duration left.
                force_sum = force_sum + force.vector * force.duration/dt
                remove_force = true
            else
                -- Force has more than dt duration left.
                force_sum = force_sum + force.vector
                force.duration = force.duration - dt

            if remove_force
                table.remove e.Forces, i
            else
                i = i + 1

        -- Convert Force into Acceleration.
        accel = force_sum / e.Mass

        -- Apply Acceleration (and Drag) to Velocity.
        e.Velocity = e.Velocity + accel * dt

        -- Apply Velocity to Position.
        world\move_entity e, e.Position + e.Velocity * dt

return sys_Motion
