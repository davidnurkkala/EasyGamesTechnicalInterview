local ServerScriptService = game:GetService("ServerScriptService")

local Map = require(ServerScriptService.Server.Map)

-- instantiate a map
Map:Create{
	TileSize = 8,
	Size = Vector2.new(128, 128),
}