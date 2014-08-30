local sound = {}

function sound.play(source, pos)
	source:setPosition(pos.x, pos.y, 0)
	source:play()
end

function sound.play_file(file, pos)
	sound.play(love.audio.newSource(file), pos)
end

return sound
