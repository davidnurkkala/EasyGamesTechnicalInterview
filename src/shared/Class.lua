local Class = {}

function Class:Extend(object)
	object = object or {}
	setmetatable(object, self)
	self.__index = self
	return object
end

function Class:Create(object)
	object = self:Extend(object)
	if object.OnCreated then
		object:OnCreated()
	end
	return object
end

function Class:Lerp(a, b, w)
	return a + (b - a) * w
end

function Class:IsNumberInRange(number, range)
	return (number > range[1] and number <= range[2])
end

function Class:GetScalarInRange(number, range)
	if number <= range[1] then
		return 0
	elseif number > range[2] then
		return 1
	else
		return (number - range[1]) / (range[2] - range[1])
	end
end

return Class