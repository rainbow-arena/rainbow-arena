local screenshake = {}

function screenshake.apply(xamp, yamp)
  if xamp >= 1 and yamp >= 1 then
    love.graphics.translate(math.random(xamp*2)-xamp, math.random(yamp*2)-yamp)
  end
end

return screenshake
