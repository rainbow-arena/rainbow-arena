--[[
	Rainbow Arena, a game by LegoSpacy
]]

--[[
	Stuff to do:
		Graphics, visual effects (like screenshake)
		Content: weapons, powerups, etc.
		Matches: Actual match/level logic
]]

local gs = require("lib.hump.gamestate")

local state_game = require("states.game")

function love.load()
	gs.registerEvents()

	gs.switch(state_game)
end
