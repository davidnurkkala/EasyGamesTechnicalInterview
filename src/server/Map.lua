local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MapTile = require(ServerScriptService.Server.MapTile)
local RiverTile = require(ServerScriptService.Server.RiverTile)
local ForestTile = require(ServerScriptService.Server.ForestTile)
local MountainTile = require(ServerScriptService.Server.MountainTile)
local Noise = require(ServerScriptService.Server.Noise)

local Super = require(ReplicatedStorage.Shared.Class)
local Map = Super:Extend()

function Map:OnCreated()
	assert(self.Size, "missing Size")
	assert(self.TileSize, "missing TileSize")

	self.Grid = {}
	self.Model = nil

	self:Generate()
	self:Build()
end

function Map:GetGrid(x, y)
	if self.Grid[x] then
		return self.Grid[x][y]
	end
end

function Map:SetGrid(x, y, value)
	if not self.Grid[x] then
		self.Grid[x] = {}
	end
	
	self.Grid[x][y] = value
end

function Map:GetNoise(x, y, frequency, seed)
	return (math.noise(x * frequency, y * frequency, seed) + 1) / 2
end

function Map:Generate()
	local seed = math.random(1, 69420420)
	print("Seed is", seed)
	local seedRandom = Random.new(seed)

	-- noise for calculating general height
	local heightNoise = Noise:Create{
		Frequency = 1 / 8,
		Seed = seedRandom:NextInteger(0, 2 ^ 16),
	}
	local heightRange = {8, 32}

	-- noise for calculating rivers
	local riverNoise = Noise:Create{
		Frequency = 1 / 32,
		Seed = seedRandom:NextInteger(0, 2 ^ 16),
	}
	local riverRange do
		local center = 0.5
		local radius = 0.05
		riverRange = {center - radius, center + radius}
	end
	local waterHeight = 8

	-- noise for calculating membership in a forest
	local forestNoise = Noise:Create{
		Frequency = 1 / 64,
		Seed = seedRandom:NextInteger(0, 2 ^ 16),
	}

	-- noise for calculating mountain ranges
	local mountainNoise = Noise:Create{
		Frequency = 1 / 128,
		Seed = seedRandom:NextInteger(0, 2 ^ 16),
	}
	local mountainRange do
		local center = 0.5
		local radius = 0.05
		mountainRange = {center - radius, center + radius}
	end
	local mountainScale = 3

	-- not a huge fan of this rightward drift in this block, but
	-- that's something I don't think I have time to clean up
	-- with this two hour block
	for x = 1, self.Size.X do
		for y = 1, self.Size.Y do
			local tile

			local isRiver = riverNoise:GetInRange(x, y, riverRange)
			if isRiver then
				-- create a river tile
				tile = RiverTile:Create{
					Map = self,
					Position = Vector2.new(x, y),
					Height = waterHeight,
				}
			else
				local scalar = heightNoise:Get(x, y)
				local height = self:Lerp(heightRange[1], heightRange[2], scalar)

				local mountainScalar = mountainNoise:GetRangeScalar(x, y, mountainRange)
				local isMountain = mountainScalar > 0
				if isMountain then
					-- create a mountain tile
					height *= self:Lerp(1, mountainScale, mountainScalar)
					
					tile = MountainTile:Create{
						Map = self,
						Position = Vector2.new(x, y),
						Height = height,
					}
				else
					local isForest = forestNoise:GetBoolean(x, y)
					if isForest then
						-- create a forest tile
						tile = ForestTile:Create{
							Map = self,
							Position = Vector2.new(x, y),
							Height = height,
						}
					else
						-- create a regular grassland tile
						tile = MapTile:Create{
							Map = self,
							Position = Vector2.new(x, y),
							Height = height,
						}
					end
				end
			end

			self:SetGrid(x, y, tile)
		end
	end
end

function Map:Build()
	local model = Instance.new("Model")
	model.Name = "MapModel"
	self.Model = model

	for x = 1, self.Size.X do
		for y = 1, self.Size.Y do
			self:GetGrid(x, y):Build()
		end
	end

	model.Parent = workspace
end

return Map