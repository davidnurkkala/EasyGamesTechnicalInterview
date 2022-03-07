local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Super = require(ReplicatedStorage.Shared.Class)
local Noise = Super:Extend()

function Noise:OnCreated()
	assert(self.Frequency, "missing Frequency")
	assert(self.Seed, "missing Seed")

	self.Random = Random.new(self.Seed)
	self.OffsetX = self.Random:NextNumber()
	self.OffsetY = self.Random:NextNumber()
	self.Z = self.Random:NextNumber()
end

function Noise:Get(x, y)
	x += self.OffsetX
	y += self.OffsetY
	
	return (math.noise(x * self.Frequency, y * self.Frequency, self.Z) + 1) / 2
end

function Noise:GetBoolean(x, y, percent)
	return self:Get(x, y) <= (percent or 0.5)
end

function Noise:GetInRange(x, y, min, max)
	-- assume we got a pair of numbers if max is nil
	if max == nil then
		min, max = min[1], min[2]
	end

	local noise = self:Get(x, y)
	return (min < noise) and (noise < max)
end

function Noise:GetRangeScalar(x, y, min, max)
	-- assume we got a pair of numbers if max is nil
	if max == nil then
		min, max = min[1], min[2]
	end

	local noise = self:Get(x, y)
	if noise <= min then return 0 end
	if noise > max then return 0 end

	local radius = (max - min) / 2
	local center = (min + max) / 2

	local delta = math.abs(center - noise)
	return 1 - (delta / radius)
end

return Noise