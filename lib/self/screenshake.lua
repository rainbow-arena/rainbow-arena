local screenshake = {}

local floor = math.floor

function screenshake.apply(xamp, yamp)
	xamp, yamp = floor(xamp), floor(yamp)

	if xamp >= 1 and yamp >= 1 then
		love.graphics.translate(
			love.math.random(0, xamp*2)-xamp,
			love.math.random(0, yamp*2)-yamp
		)
	end
end

return screenshake
