local game = {}

local ces = require("lib.self.ces")
local camera = require("lib.hump.camera")
local vector = require("lib.hump.vector")
local timer = require("lib.hump.timer")
local spatialhash = require("lib.self.spatialhash")
local util = require("lib.self.util")

local screenshake = require("lib.self.screenshake")

local circleutil = require("util.circle")

local aabb = circleutil.aabb
local colliding = circleutil.colliding

local world
local player

local game_speed = 1

local PLAYER_RADIUS = 30

local function loadSystems(dir)
	for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
		if love.filesystem.isDirectory(dir .. "/" .. item) then
			loadSystems(dir .. "/" .. item)
		else
			local t = dofile(dir .. "/" .. item)

			if t.systems then
				for _, system in ipairs(t.systems) do
					world:addSystem(system)
				end
			end
			if t.events then
				for _, eventitem in pairs(t.events) do
					world:registerEvent(eventitem.event, eventitem.func)
				end
			end
		end
	end
end

-- TODO: Move event bus out of ces.lua and override some ces functions?
function game:init()
	world = ces.new()

	world.camera = camera.new()
	world.screenshake = 0
	world.hash = spatialhash.new()

	---

	local oldspawn = world.spawnEntity
	function world:spawnEntity(t)
		local entity = oldspawn(self, t)

		if entity.Position and entity.Radius then
			self.hash:insert_object(entity, aabb(
				entity.Radius, entity.Position.x, entity.Position.y))
		end

		return entity
	end

	local olddestroy = world.destroyEntity
	function world:destroyEntity(entity)
		olddestroy(self, entity)

		if entity.Position and entity.Radius then
			self.hash:remove_object(entity, aabb(
				entity.Radius, entity.Position.x, entity.Position.y))
		end
	end

	function world:move_entity_to(entity, x, y)
		local oldpos = entity.Position

		local newpos
		if not y then
			newpos = x
		else
			newpos = vector.new(x, y)
		end

		entity.Position = newpos

		local old_x1,old_y1, old_x2,old_y2 = aabb(entity.Radius, oldpos.x, oldpos.y)
		local new_x1,new_y1, new_x2,new_y2 = aabb(entity.Radius, newpos.x, newpos.y)

		self.hash:move_object(entity, old_x1,old_y1, old_x2,old_y2, new_x1,new_y1, new_x2,new_y2)
	end

	---

	function world:add_screenshake(intensity)
		self.screenshake = self.screenshake + intensity
	end

	---

	loadSystems("systems")
end

local function generate_position(radius)
	return vector.new(
		love.math.random(radius, world.w - radius),
		love.math.random(radius, world.h - radius)
	)
end

local function find_position(radius, tries)
	for try = 1, tries or 10 do
		local ok = true

		local pos = generate_position(radius)
		for entity in pairs(world:getEntitiesWith{"Position", "Radius"}) do
			if colliding(pos,radius, entity.Position,entity.Radius) then
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

function game:enter(previous, w, h, nbots)
	world:clearEntities()

	world.w, world.h = w or 1000, h or 1000

	local c_drag, c_accel = calculate_drag_accel(800, 5)

	local bullet_c = require("entities.projectiles.physical")
	local bullet = bullet_c()

	for k,v in pairs(bullet_c) do print(k) end
	print("---")
	for k,v in pairs(bullet) do print(k) end

	local pistol = require("entities.weapons.projectile"){
		max_heat = 4,
		shot_heat = 0.25,

		kind = "single",
		projectile = bullet,
		projectile_speed = 800,
		shot_delay = 0.1
	}

	local minigun = require("entities.weapons.triple_minigun"){
		max_heat = 10,
		shot_heat = 0.2,

		kind = "single",
		projectile = bullet,
		projectile_speed = 800,

		initial_shot_delay = 0.3,
		final_shot_delay = 0.05,
		spinup_time = 2
	}

	player = world:spawnEntity{
		Name = "Player",
		Team = "Player",

		Color = {0, 255, 255},

		Radius = PLAYER_RADIUS,
		Position = find_position(PLAYER_RADIUS),
		Velocity = vector.new(0, 0),
		Acceleration = vector.new(0, 0),

		Drag = c_drag,
		MoveAcceleration = c_accel,

		CollisionPhysics = true,

		Weapon = minigun,

		Player = true,
		CameraTarget = true
	}

	-- Place test balls.
	for n = 1, 50 do
		local radius = 30
		world:spawnEntity{
			Name = "Ball " .. n,

			Color = {255, 0, 0},

			Radius = radius,
			Position = find_position(radius),
			Velocity = vector.new(0, 0),
			Acceleration = vector.new(0, 0),

			Drag = c_drag,
			MoveAcceleration = c_accel,

			CollisionPhysics = true
		}
	end
end

function game:update(dt)
	game_speed = util.math.clamp(0.1, game_speed, 7)

	world.screenshake = 0

	local adjdt = dt * game_speed
	timer.update(adjdt)
	world:runSystems("update", adjdt)
end

function game:draw()
	world.camera:attach()

	screenshake.apply(world.screenshake, world.screenshake)

	-- Arena boundaries.
	love.graphics.line(0,0, 0,world.h)
	love.graphics.line(0,world.h, world.w,world.h)
	love.graphics.line(world.w,world.h, world.w,0)
	love.graphics.line(world.w,0, 0,0)

	world:runSystems("draw", main_camera)
	world.camera:detach()

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Speed multiplier: " .. game_speed, 10, 10)
	love.graphics.print(
		"Entities: " .. util.table.nelem(world.entities),
		10, 10 + love.graphics.getFont():getHeight()
	)
end


function game:keypressed(key, isrepeat)
	world:emitEvent("KeyPressed", key, isrepeat)
end

function game:keyreleased(key)
	world:emitEvent("KeyReleased", key)
end

function game:mousepressed(x, y, b)
	if b == "wd" then
		game_speed = game_speed - 0.1
	elseif b == "wu" then
		game_speed = game_speed + 0.1
	end

	if b == "r" then
		world:spawnEntity(require("entities.explosion"){
			position = vector.new(world.camera:worldCoords(x, y))
		})
	end

	world:emitEvent("MousePressed", x, y, b)
end

function game:mousereleased(x, y, b)
	world:emitEvent("MouseReleased", x, y, b)
end

return game
