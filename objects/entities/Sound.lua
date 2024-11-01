--- Require ---
local Class = require("lib.hump.class")
local vector = require("lib.hump.vector")

local util = require("lib.util")
--- ==== ---

--- Classes ---
--- ==== ---

--- Class definition ---
local ent_Sound = Class({})
--- ==== ---

--- Local functions ---
--- ==== ---

--- Class functions ---
function ent_Sound:init(template)
	assert(util.table.check(template, {
		"Position",
		"soundpath",
	}, "ent_Sound"))

	util.table.fill(self, template)

	self.Sound = {
		source = love.audio.newSource(template.soundpath, "static"),
		volume = template.volume or 1,
		pitch = template.pitch or 1,
		removeOnFinish = template.removeOnFinish,
	}

	if template.looping then
		self.Sound.source:setLooping(true)
	end
end
--- ==== ---

return ent_Sound
