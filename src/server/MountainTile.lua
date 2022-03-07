local ServerScriptService = game:GetService("ServerScriptService")

local STONE_RANGE = {8, 48}
local SNOW_RANGE = {64, 96}
local MID_RANGE = {STONE_RANGE[2], SNOW_RANGE[1]}

local STONE_COLOR = Vector3.new(0.2, 0.2, 0.2)
local SNOW_COLOR = Vector3.new(1, 1, 1)

local Super = require(ServerScriptService.Server.MapTile)
local MountainTile = Super:Extend()

function MountainTile:Build()
	Super.Build(self)

	local part = self.Model.PrimaryPart
	local color = Vector3.new(part.Color.R, part.Color.G, part.Color.B)

	if self:IsNumberInRange(self.Height, STONE_RANGE) then
		color = self:Lerp(color, STONE_COLOR, self:GetScalarInRange(self.Height, STONE_RANGE))
	
	elseif self:IsNumberInRange(self.Height, MID_RANGE) then
		color = STONE_COLOR
	
	elseif self.Height > SNOW_RANGE[1] then
		color = self:Lerp(STONE_COLOR, SNOW_COLOR, self:GetScalarInRange(self.Height, SNOW_RANGE))
	end

	part.Color = Color3.new(color.X, color.Y, color.Z)
end

return MountainTile