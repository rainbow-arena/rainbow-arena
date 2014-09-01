local sound = {}

function sound.play(source, pos, pitch)
	source:setPosition(pos.x, pos.y, 0)
	source:setPitch(pitch or 1)
	source:play()
end

function sound.play_file(file, pos, pitch)
	sound.play(love.audio.newSource(file), pos, pitch)
end

return sound
