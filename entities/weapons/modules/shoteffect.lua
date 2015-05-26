return {
	init = function(self, arg)
		assert(arg.shakedur and arg.shakeamp and arg.shakerad
			or not (arg.shakedur and arg.shakeamp and arg.shakerad),
			"Screenshake only partially defined!")

		if arg.shakedur and arg.shakeamp and arg.shakerad then
			self.shakedur = arg.shakedur
			self.shakeamp = arg.shakeamp
			self.shakerad = arg.shakerad
		end

		if arg.shotsound then
			self.shotsound = arg.shotsound

			local sd = love.sound.newSoundData(arg.shotsound)
			self._shotsoundlen = sd:getDuration()
		end
	end,

	do_effect = function(self, host, world)
		local temp = {
			Position = host.Position:clone(),

			DestroyWithParent = true,

			Lifetime = math.max(self.shakedur or 0, self._shotsoundlen or 0)
		}

		if self._shakedur then
			temp.Screenshake = {
				duration = self.shakedur,
				intensity = self.shakeamp,
				radius = self.shakerad
			}
		end

		if self._shotsound then
			temp.Sound = {
				source = love.audio.newSource(self.shotsound)
			}
		end

		local ent = world:spawn_entity(temp)

		ent.Parent = host

		return ent
	end
}
