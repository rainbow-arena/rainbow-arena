local game = {}

local ces = require("lib.self.ces")
local spatialhash = require("lib.self.spatialhash")
local screenshake = require("lib.self.screenshake")
local util = require("lib.self.util")

local circleutil = require("util.circle")

local camera = require("lib.hump.camera")
local vector = require("lib.hump.vector")
local signal = require("lib.hump.signal")
local timer = require("lib.hump.timer")

---

local aabb = circleutil.aabb
local colliding = circleutil.colliding

local nelem = util.table.nelem

---

local PLAYER_RADIUS = 30

SOUND_POSITION_SCALE = 256

---

local world

---

local function load_systems(dir)
	for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
		if love.filesystem.isDirectory(dir .. "/" .. item) then
			load_systems(dir .. "/" .. item)
		else
			local t = love.filesystem.load(dir .. "/" .. item)()

			if type(t) ~= "table" then
				error(("System file \"%s\" doesn't return a table!"):format(dir .."/" .. item))
			end

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

---

function game:init()
	world = ces.new()

	world.camera = camera.new()
	world.signal = signal.new()
	world.screenshake = 0
	world.hash = spatialhash.new()
	world.speed = 1

	---

	love.audio.setOrientation(0,0,-1, 0,1,0)
	love.audio.setDistanceModel("inverse clamped")

	---

	function world:registerEvent(event, func)
		self.signal:register(event, func)
	end

	function world:emitEvent(event, ...)
		self.signal:emit(event, self, ...)
	end

	function world:clearEvents()
		self.signal:clear()
	end

	local olddestroy = world.destroyEntity
	function world:destroyEntity(entity)
		self:emitEvent("EntityDestroyed", entity)
		olddestroy(self, entity)
	end

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

	load_systems("systems")
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

	local bullet = require("entities.projectiles.bullet")()

	local pistol = require("entities.weapons.projectile"){
		max_heat = 2,
		shot_heat = 0.1,

		kind = "single",
		projectile = bullet,
		projectile_speed = 800,
		shot_delay = 0.5,

		shot_sound = "audio/weapons/laser_shot.wav"
	}

	local minigun = require("entities.weapons.triple_minigun"){
		max_heat = 2,
		shot_heat = 0.01,

		kind = "single",
		projectile = bullet,
		projectile_speed = 800,

		initial_shot_delay = 0.3,
		final_shot_delay = 0.05,
		spinup_time = 2,

		shot_sound = "audio/weapons/laser_shot.wav"
	}

	player = world:spawnEntity{
		Name = "Player",
		Team = "Player",

		Color = {0, 255, 255},

		Radius = PLAYER_RADIUS,
		Position = find_position(PLAYER_RADIUS),
		Velocity = vector.new(0, 0),
		Acceleration = vector.new(0, 0),

		Rotation = 0,
		RotationSpeed = 2,

		Drag = c_drag,
		MoveAcceleration = c_accel,

		CollisionPhysics = true,

		Weapon = minigun,

		Player = true,
		CameraTarget = true
	}

	-- Place test balls.
	for n = 1, 10 do
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
	world.speed = util.math.clamp(0.1, world.speed, 7)
	local adjdt = dt * world.speed

	love.audio.setPosition(world.camera.x/SOUND_POSITION_SCALE, world.camera.y/SOUND_POSITION_SCALE, 0)

	world.screenshake = 0

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

	world:runSystems("draw")
	world.camera:detach()

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Speed multiplier: " .. world.speed, 10, 10)
	love.graphics.print(
		"Entities: " .. nelem(world.entities),
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
		world.speed = world.speed - 0.1
	elseif b == "wu" then
		world.speed = world.speed + 0.1
	end

	if b == "r" then
		world:spawnEntity(require("entities.effects.explosion"){
			position = vector.new(world.camera:worldCoords(x, y)),
			force = 2*10^6
		})
	end

	world:emitEvent("MousePressed", x, y, b)
end

function game:mousereleased(x, y, b)
	world:emitEvent("MouseReleased", x, y, b)
end

return game
