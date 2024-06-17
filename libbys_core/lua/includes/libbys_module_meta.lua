AddCSLuaFile()

local ConfigObject = include("includes/libbys_config_object.lua")

local MODULE = {}
MODULE.__index = MODULE

AccessorFunc(MODULE, "m_strName", "Name", FORCE_STRING)
AccessorFunc(MODULE, "m_bEnabled", "Enabled_Internal", FORCE_BOOL)

function MODULE:Init()
	self:ConfigInit()

	self.m_ConVars = {}
end

function MODULE:Setup(name)
	self:SetName(name)
	self:SetEnabled(true)
end

function MODULE:OnEnabled()
	-- For override
end

function MODULE:OnDisabled()
	-- For override
end

function MODULE:SetEnabled(status)
	self:SetEnabled_Internal(status)

	util.SafeCallback(self:GetEnabled_Internal() and self.OnEnabled or self.OnDisabled, self)
end
MODULE.GetEnabled = MODULE.GetEnabled_Internal

function MODULE:AddHook(event, callback)
	gameevent.Listen(event)

	hook.Add(event, self:GetName(), function(...)
		return callback(self, ...)
	end)
end

function MODULE:RemoveHook(event)
	hook.Remove(event, self:GetName())
end

function MODULE:CreateConVar(name, default, flags, help, min, max)
	name = string.ToSnakeKey(name)

	local existing = GetConVar(name)

	if existing then
		self.m_ConVars[name] = existing
	else
		self.m_ConVars[name] = CreateConVar(name, default, flags, help, min, max)
	end

	return self.m_ConVars[name]
end

function MODULE:GetConVars()
	return self.m_ConVars
end

function MODULE:GetConVar(name)
	name = string.ToSnakeKey(name)

	return self.m_ConVars[name]
end

return setmetatable(MODULE, ConfigObject)
