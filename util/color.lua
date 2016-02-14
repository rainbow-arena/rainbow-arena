--- Require ---
local util = require("lib.util")
--- ==== ---


--- Local functions ---
local range = util.math.range
--- ==== ---


--- Module ---
local color = {}
--- ==== ---


--- Module functions ---
-- https://en.wikipedia.org/wiki/HSL_and_HSV#From_HSV
function color.hsv_to_rgb(h, s, v)
	s = s/255
	v = v/255

	local c = v * s
	local h = h/60

	local x = c * (1 - math.abs(h % 2 - 1))

	local r, g, b = 0, 0, 0

	if range(0, h, 1) then
		r = c
		g = x
	elseif range(1, h, 2) then
		r = x
		g = c
	elseif range(2, h, 3) then
		g = c
		b = x
	elseif range(3, h, 4) then
		g = x
		b = c
	elseif range(4, h, 5) then
		r = x
		b = c
	elseif range(5, h, 6) then
		r = c
		b = x
	end

	local m = v - c

	return (r + m) * 255, (g + m) * 255, (b + m) * 255
end
--- ==== ---


return color
