return {
	init = function(self, delay)
		self.shottimer = 0
		self.shotdelay = delay
	end,

	on_fire = function(self, host, world)
		self.shottimer = self.shotdelay
	end,

	can_fire = function(self, host, world)
		return self.shottimer == 0
	end,

	update = function(self, host, world, dt)
		self.shottimer = self.shottimer - dt
		if self.shottimer < 0 then
			self.shottimer = 0
		end
	end
}
