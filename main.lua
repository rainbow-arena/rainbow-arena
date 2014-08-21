--[[
	Rainbow Arena, a game by LegoSpacy

	Everything is a circle. With a gun. Destroy all enemies.

	Players and bots start in random locations.
]]

local gs = require("lib.hump.gamestate")

local state_game = require("states.game")

function love.load()
	gs.registerEvents()

	gs.switch(state_game)
end
