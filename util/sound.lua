local sound = {}

function sound.play(source, pos)
	source:setPosition(pos.x, pos.y, 0)
	source:play()
end

return sound
