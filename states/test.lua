local test = {}

---

local vector = require("lib.hump.vector")
local screenshake = require("lib.self.screenshake")
local util = require("lib.self.util")

local circle = require("util.circle")
local color = require("util.color")

local World = require("logic.world")

---

local circle_colliding = circle.colliding
local table_nelem = util.table.nelem

---

local PLAYER_RADIUS = 30

SOUND_POSITION_SCALE = 256

---

local world

function test:init()
	world = World.new()
	world:load_system_dir("systems")
end

local function generate_position(radius)

	local angle = love.math.random() * 2*math.pi
	local magnitude = love.math.random(0, world.r)

	return vector.new(
		magnitude * math.cos(angle),
		magnitude * math.sin(angle)
	)
end

local function find_position(radius, tries)
	for try = 1, tries or 10 do
		local ok = true

		local pos = generate_position(radius)
		for entity in pairs(world:get_entities_with{"Position", "Radius"}) do
			if circle_colliding(pos,radius, entity.Position,entity.Radius) then
				ok = false
				break
			end
		end

		if ok then return pos end
	end
end

-- https://stackoverflow.com/questions/667034/simple-physics-based-movement
local function calculate_drag_accel(max_speed, accel_time)
	local drag = 5/accel_time -- drag = 5/t_max
	local accel = max_speed * drag -- acc = v_max * drag
	return drag, accel
end

function test:enter(previous, w, h, nbots)
	world:clear_entities()

	world.r = r or 600

	local c_drag, c_accel = calculate_drag_accel(800, 5)

	local combatant = require("entities.combatant")

	local player = world:spawn_entity(combatant.new{
		Team = "Player",
		Player = true,

		Position = find_position(PLAYER_RADIUS),

		Radius = PLAYER_RADIUS,
		Color = {255, 255, 255},
		Health = 30,

		Drag = c_drag,
		MoveAcceleration = c_accel,

		Weapon = require("entities.weapons.projectile.machinegun").new{
			projectile = require("entities.projectiles.bullet").new(1)
		}
	})

	world.camera_target = player

	-- Place test balls.
	for n = 1, 50 do
		local color = {color.hsv_to_rgb(love.math.random(0, 359), 255, 255)}

		world:spawn_entity(combatant.new{
			Name = "Ball " .. n,
			Team = "Enemy",

			Position = find_position(PLAYER_RADIUS),

			Radius = PLAYER_RADIUS,
			Color = color,
			Health = 30,

			Drag = c_drag,
			MoveAcceleration = c_accel
		})
	end
end

function test:update(dt)
	world:update(dt)
end

function test:draw()
	world:draw{
		ui = function(self)
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("Speed multiplier: " .. self.speed, 10, 10)
			love.graphics.print(
				"Entities: " .. table_nelem(self.entities),
				10, 10 + love.graphics.getFont():getHeight()
			)
		end
	}
end


function test:keypressed(key, isrepeat)
	world:emit_event("KeyPressed", key, isrepeat)
end

function test:keyreleased(key)
	world:emit_event("KeyReleased", key)
end

function test:mousepressed(x, y, b)
	if b == "wd" then
		world.speed = world.speed - 0.1
	elseif b == "wu" then
		world.speed = world.speed + 0.1
	end

	world:emit_event("MousePressed", x, y, b)
end

function test:mousereleased(x, y, b)
	world:emit_event("MouseReleased", x, y, b)
end

return test
