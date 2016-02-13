--- Require ---
local vector = require("lib.hump.vector")
local timer = require("lib.hump.timer")

local circle = require("util.circle")
local entity = require("util.entity")
local color = require("util.color")
--- ==== ---


--- Classes ---
local World = require("World")

local ent_Combatant = require("entities.Combatant")
local ent_Explosion = require("entities.Explosion")
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


--- Gamestate definition ---
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
		Player = true
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
	world:register_event("EntityCollision", function(world, e1, e2, mtv)
		world:add_entity(ent_Explosion{
			position = entity.getmidpoint(e1, e2),
			radius = 100,
			duration = 1,
			damage = 75,
			force = 0
		})
	end)
	--]]
end


-- Entering and leaving ---
function Game:init()
	self.world = World()

	self.world.DEBUG = false
	self.world.speed = 1

	---

	spawn_test_entities(self.world)
end

function Game:enter(prev, ...)

end

function Game:leave()

end
-- ==== --


-- Updating ---
local function draw_debug_info(self, x, y)
	local str_t = {}

	---

	--str_t[#str_t + 1] = (""):format()

	str_t[#str_t + 1] = ("Entities: %d"):format(self.ecs:getEntityCount())

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
	if key == "t" then
		self.world.DEBUG = not self.world.DEBUG
	end
end

function Game:mousepressed(x, y, b)


end
-- ==== --
--- ==== ---


return Game

