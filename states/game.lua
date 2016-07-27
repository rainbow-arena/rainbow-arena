--- Require ---
local vector = require("lib.hump.vector")
local timer = require("lib.hump.timer")
local camera = require("lib.hump.camera")

local tiny = require("lib.tiny")

local util = require("lib.util")

local circle = require("util.circle")
local entity = require("util.entity")
local color = require("util.color")
--- ==== ---


--- Classes ---
local World = require("World")

local ent_Physical = require("entities.Physical")
local ent_Combatant = require("entities.Combatant")
local ent_Explosion = require("entities.Explosion")

local wep_Pistol = require("weapons.projectile.Pistol")
local wep_Machinegun = require("weapons.projectile.Machinegun")
local wep_Minigun = require("weapons.projectile.Minigun")
local wep_Shotgun = require("weapons.projectile.Shotgun")
--- ==== ---


--- Local functions ---
local function generate_position(radius)
	local angle = love.math.random() * 2*math.pi
	local magnitude = love.math.random(0, radius)

	return vector.new(
		magnitude * math.cos(angle),
		magnitude * math.sin(angle)
	)
end
--- ==== ---


--- Gamestate ---
local Game = {}
--- ==== ---


--- Gamestate functions ---
local function spawn_test_entities(world)
	local window_w, window_h = love.graphics.getDimensions()

	---

	local player = world:add_entity(ent_Combatant{
		Name = "Player",
		Position = vector.new(0, 0),
		Color = {255, 255, 255},
		DesiredAimAngle = math.pi,
		Player = true,

		Weapon = wep_Shotgun{
			projectile = ent_Physical{ -- TODO: Hit recoil, use CollisionPhysics with force but without actual collision?
				Name = "A projectile",

				Position = vector.new(0, 0), -- doesn't matter
				Radius = 3,
				Mass = 10^2,

				Drag = 0,

				CollisionPhysics = true,
				IgnoreExplosion = true,

				onCollision = function(self, world, other)
					---[[
					world:add_entity(ent_Explosion{
						Position = self.Position:clone(),
						radius = 25,
						duration = 0.5,
						damage = 50,
						force = 8 * 10^6
					})
					--]]

					--world:remove_entity(self)
				end
			},

			muzzleVelocity = 800,
			spread = math.pi/20,

			shotPellets = 5,

			shotDelay = 0.2,

			initialShotDelay = 0.3,
			finalShotDelay = 0.05,

			spinupTime = 2,

			shotHeat = 0.0,
			heatLimit = 4,

			shotSound = "audio/weapons/laser_shot.wav",

			screenshake = {
				radius = 60,
				intensity = 2,
				duration = 1,
				removeOnFinish = true,
			}
		}
	})

	world.CameraTarget = player

	for i = 1, 200 do
		world:add_entity(ent_Combatant{
			Name = "Combatant " .. i,
			Position = generate_position(1000),
			Color = {color.hsv_to_rgb(love.math.random(0, 359), 255, 255)},
			DesiredAimAngle = love.math.random() * 2*math.pi,
			StareAt = player
		})
	end

	--[[
	world:register_event("PhysicsCollision", function(world, e1, e2, mtv)
		world:add_entity(ent_Explosion{
			Position = entity.getmidpoint(e1, e2),
			radius = 100,
			duration = 1,
			damage = 75,
			force = 0
		})
	end)
	--]]

	--[[
	local boombox_source = love.audio.newSource("audio/fluorescent.ogg")
	boombox_source:setLooping(true)

	local boombox = world:add_entity(ent_Combatant{
		Name = "Boombox",
		Position = generate_position(1000),
		Radius = 60,
		Color = {color.hsv_to_rgb(love.math.random(0, 359), 255, 255)},
		hue = 0,
		DesiredAimAngle = love.math.random() * 2*math.pi,
		StareAt = player,

		Sound = {
			source = boombox_source,
			volume = 1,
			pitch = 1
		}
	})

	world.ecs:addSystem(tiny.system{
		update = function(self, dt)
			boombox.hue = boombox.hue + 100 * dt
			if boombox.hue > 359 then
				boombox.hue = 0
			end
			boombox.Color = {color.hsv_to_rgb(boombox.hue, 255, 255)}
		end
	})
	--]]
end


-- Entering and leaving ---
function Game:init()
	self.world = World()

	self.world.DEBUG = false
	self.world.speed = 1

	---

	local window_w, window_h = 1280, 720
	love.window.setMode(window_w, window_h)

	---

	spawn_test_entities(self.world)
end

function Game:enter(prev, ...)
	love.mouse.setVisible(false)
end

function Game:leave()
	love.mouse.setVisible(true)
end
-- ==== --


-- Updating ---
local function draw_debug_info(self, x, y)
	local str_t = {}

	---

	--str_t[#str_t + 1] = (""):format()

	str_t[#str_t + 1] = ("Entities: %d"):format(self.ecs:getEntityCount())

	str_t[#str_t + 1] = ("Speed: %.2f"):format(self.speed)

	---

	local str = table.concat(str_t, "\n")

	love.graphics.setColor(255, 255, 255)
	love.graphics.print(str, math.floor(x), math.floor(y))
end

-- Doing all updating in :draw()
function Game:draw()
	local dt = love.timer.getDelta()

	self.world:update(dt)
	timer.update(dt)

	if self.world.DEBUG then
		draw_debug_info(self.world, 10, 10)
	end
end
-- ==== --


-- Input --
function Game:keypressed(key)
	if key == "d" then
		self.world.DEBUG = not self.world.DEBUG
	end
end

function Game:mousepressed(x, y, b)

end

function Game:wheelmoved(x, y)
	if y > 0 then
		self.world.speed = self.world.speed + 0.1
	else
		self.world.speed = self.world.speed - 0.1
	end

	self.world.speed = util.math.clamp(0, self.world.speed, 7)
end
-- ==== --
--- ==== ---


return Game

