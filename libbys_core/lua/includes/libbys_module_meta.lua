AddCSLuaFile()

local ConfigObject = include("includes/libbys_config_object.lua")

local MODULE = {}
MODULE.__index = MODULE

AccessorFunc(MODULE, "m_strName", "Name", FORCE_STRING)
AccessorFunc(MODULE, "m_bEnabled", "Enabled_Internal", FORCE_BOOL)

function MODULE:Init()
	self.m_bEnabled = nil -- Kill it so we can test it later

	self:ConfigInit()

	self.m_ConVars = {}
	self.m_Hooks = {}
end

function MODULE:Setup(name)
	self:SetName(name)

	self:SetupConfig()

	if self.m_bEnabled == nil then -- If it wasn't changed during setup, default to enabled
		self:SetEnabled(true)
	end
end

function MODULE:SetupConfig()
	-- For override
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

	-- Global callback
	hook.Run("Libbys_Module_EnabledDisabled", self, self:GetEnabled_Internal())
end
MODULE.GetEnabled = MODULE.GetEnabled_Internal

function MODULE:AddHook(event, callback)
	gameevent.Listen(event)

	hook.Add(event, self:GetName(), function(...)
		return callback(self, ...)
	end)

	self.m_Hooks[event] = true
end

function MODULE:RemoveHook(event)
	hook.Remove(event, self:GetName())

	self.m_Hooks[event] = nil
end

function MODULE:RemoveHooks(event)
	for k, _ in next, self.m_Hooks do
		hook.Remove(event, self:GetName())
	end
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
