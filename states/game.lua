local game = {}

local ces = require("lib.self.ces")
local camera = require("lib.hump.camera")
local vector = require("lib.hump.vector")
local spatialhash = require("lib.self.spatialhash")
local util = require("lib.self.util")

local screenshake = require("lib.self.screenshake")

local circle = require("logic.circle")

local aabb = circle.aabb

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
			if circle.colliding(pos,radius, entity.Position,entity.Radius) then
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

		Weapon = require("content.weapons.pistol")(0.1, 3, nil, 800, 1),

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

local img_particle = love.graphics.newImage("graphics/particle.png")

function game:mousepressed(x, y, b)
	if b == "wd" then
		game_speed = game_speed - 0.1
	elseif b == "wu" then
		game_speed = game_speed + 0.1
	end

	if b == "r" then
		local ax, ay = world.camera:worldCoords(x, y)

		local ps = love.graphics.newParticleSystem(img_particle, 1024)

		local radius = 100

		local sr, sg, sb = 255, 97, 0

		ps:setPosition(ax, ay)
		ps:setEmitterLifetime(0.1)
		ps:setParticleLifetime(0.1,3)
		ps:setEmissionRate(100)
		ps:setSpeed(10, 100)
		ps:setSpread(2 * math.pi)
		ps:setAreaSpread("normal", radius/4, radius/4)
		ps:setColors(sr, sg, sb, 255, sr, sg, sb, 0)
		ps:setSizes(1, 0)
		ps:setSizeVariation(1)
		ps:start()
		ps:emit(512)

		local explosion = world:spawnEntity{
			Position = vector.new(ax, ay),

			Lifetime = 3,

			ParticleSystem = ps,

			Explosion = {
				force = 2*10^6,
				damage = 10,
				radius = radius
			}
		}
	end

	world:emitEvent("MousePressed", x, y, b)
end

function game:mousereleased(x, y, b)
	world:emitEvent("MouseReleased", x, y, b)
end

return game
