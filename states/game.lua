--- Require ---
local vector = require("lib.hump.vector")
local timer = require("lib.hump.timer")

local circle = require("util.circle")
local entity = require("util.entity")
--- ==== ---


--- Classes ---
local World = require("World")

local ent_Combatant = require("entities.Combatant")
local ent_Explosion = require("entities.Explosion")
--- ==== ---


--- Local functions ---
--- ==== ---


--- Gamestate definition ---
local Game = {}
--- ==== ---


--- Gamestate functions ---
local function spawn_test_entities(world)
	local window_w, window_h = love.graphics.getDimensions()

	---

	local poorguy = world:add_entity(ent_Combatant{
		Position = vector.new(500, window_h/2),
		Radius = 60,
		Force = vector.new(0, 0),
		Color = {255, 100, 100},
		DesiredAimAngle = 0
	})

	timer.every(0.01, function()
		--poorguy.Health.current = poorguy.Health.current - 10
	end)

	world:add_entity(ent_Combatant{
		Position = vector.new(window_w - 500, window_h/2),
		Force = vector.new(0, 0),
		Color = {100, 100, 255},
		DesiredAimAngle = math.pi,
		Player = true
	})

	---[[
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

	self.world.DEBUG = true
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

end

function Game:mousepressed(x, y, b)


end
-- ==== --
--- ==== ---


return Game

