local ServerScriptService = game:GetService("ServerScriptService")

local Super = require(ServerScriptService.Server.MapTile)
local RiverTile = Super:Extend()

function RiverTile:Build()
	Super.Build(self)

	local bedHeight = 0.25

	local part = self.Model.PrimaryPart
	local deltaHeight = bedHeight - part.Size.Y
	part.Size += Vector3.new(0, deltaHeight, 0)
	part.Position += Vector3.new(0, deltaHeight / 2, 0)
	part.Color = Color3.new(0.85, 0.85, 0.45)

	local water = part:Clone()
	water.CanCollide = false
	water.Material = Enum.Material.Foil
	water.Size = Vector3.new(water.Size.X, self.Height - bedHeight, water.Size.Z)
	water.Position += Vector3.new(0, bedHeight / 2 + water.Size.Y / 2, 0)
	water.Color = Color3.new(0.15, 0.45, 0.8)
	water.Parent = self.Model
end

return RiverTile