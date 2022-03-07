local ServerScriptService = game:GetService("ServerScriptService")

local ForestTileRandom = Random.new()

local Super = require(ServerScriptService.Server.MapTile)
local ForestTile = Super:Extend()

function ForestTile:Build()
	Super.Build(self)

	local foliageSize = self.Map.TileSize * 0.6
	local trunkThickness = foliageSize * 0.3
	local maxDelta = (self.Map.TileSize - foliageSize) / 2
	local delta = Vector3.new(
		ForestTileRandom:NextNumber(-maxDelta, maxDelta),
		self.Height / 2,
		ForestTileRandom:NextNumber(-maxDelta, maxDelta)
	)

	local trunk = self.Model.PrimaryPart:Clone()
	trunk.Size = Vector3.new(trunkThickness, foliageSize, trunkThickness)
	trunk.Color = Color3.new(0.25, 0.15, 0)
	trunk.Material = Enum.Material.Wood
	trunk.CFrame = self.Model.PrimaryPart.CFrame + delta + Vector3.new(0, trunk.Size.Y / 2, 0)
	trunk.Parent = self.Model

	local foliage = trunk:Clone()
	foliage.Size = Vector3.new(foliageSize, foliageSize, foliageSize)
	foliage.Color = Color3.new(0, 0.3, 0.25)
	foliage.Material = Enum.Material.Grass
	foliage.CFrame = trunk.CFrame + Vector3.new(0, trunk.Size.Y / 2, 0)
	foliage.Parent = self.Model
end

return ForestTile