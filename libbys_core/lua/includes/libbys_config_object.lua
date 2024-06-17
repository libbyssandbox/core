AddCSLuaFile()

local CONOBJ = {}
CONOBJ.__index = CONOBJ

function CONOBJ:ConfigInit()
	self.m_Config = {}
	self.m_ConfigTypes = {}
	self.m_ConfigCategories = {}
end

function CONOBJ:GetConfig()
	return self.m_Config
end

function CONOBJ:GetConfigCategories()
	return self.m_ConfigCategories
end

function CONOBJ:SetConfigValue(key, value)
	-- Wipe it out
	if value == nil then
		self:SetConfigCategory(key, nil)
		self.m_Config[key] = nil

		return
	end

	-- Only setup if it doesn't exist yet
	if self.m_Config[key] ~= nil then
		self.m_Config[key] = util.ForceType(value, self.m_ConfigTypes[key])
	else
		local ValueType = util.GetValueForce(value)
		self.m_ConfigTypes[key] = ValueType

		self.m_Config[key] = util.ForceType(value, ValueType)

		-- Add to default category
		self:SetConfigCategory(key, "Global")
	end
end

function CONOBJ:GetConfigValue(key)
	return self.m_Config[key]
end

function CONOBJ:SetConfigCategory(key, category)
	category = string.ToPascalKey(category)

	-- Remove the old one
	local existing = self:GetConfigCategory(key)

	if existing then
		self.m_ConfigCategories[existing][key] = nil
	end
	if category == nil then return end

	-- Setup new one
	if not self.m_ConfigCategories[category] then
		self.m_ConfigCategories[category] = {}
	end

	self.m_ConfigCategories[category][key] = true
end

function CONOBJ:GetConfigCategory(key)
	for category, keys in next, self.m_ConfigCategories do
		if keys[key] then
			return category
		end
	end

	return nil
end

return CONOBJ
