local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Super = require(ReplicatedStorage.Shared.Class)
local MapTile = Super:Extend()

function MapTile:OnCreated()
	assert(self.Map, "missing Map")
	assert(self.Position, "missing Position")
	assert(self.Height, "missing Height")

	self.Model = nil
end

function MapTile:Build()
	local model = Instance.new("Model")
	model.Name = string.format("Tile%d,%d", self.Position.X, self.Position.Y)

	local part = Instance.new("Part")
	part.Name = "Root"
	part.Material = Enum.Material.SmoothPlastic
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Color = Color3.new(0.15, 0.4, 0.15)
	part.Size = Vector3.new(self.Map.TileSize, self.Height, self.Map.TileSize)
	part.CFrame = CFrame.new(self.Position.X * self.Map.TileSize, self.Height / 2, self.Position.Y * self.Map.TileSize)
	part.Parent = model
	model.PrimaryPart = part

	self.Model = model
	model.Parent = self.Map.Model
end

return MapTile